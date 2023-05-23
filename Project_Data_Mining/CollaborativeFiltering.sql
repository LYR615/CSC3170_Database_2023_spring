-- Set the selected user ID and the number of top similar users to consider.
SET @selected_user_id = 514088000;
SET @K = 5;

-- Calculate the mean ratings for each buyer.
WITH buyer_mean_ratings AS (
    SELECT buyer_id, AVG(buyer_evaluation) AS mean_rating
    FROM order_items
    GROUP BY buyer_id
),

-- Normalize the buyer evaluations using the mean ratings.
normalized_order_items AS (
    SELECT oi.buyer_id, oi.product_id,
           (oi.buyer_evaluation - bmr.mean_rating) AS normalized_rating
    FROM order_items oi
    JOIN buyer_mean_ratings bmr ON oi.buyer_id = bmr.buyer_id
),   

-- Calculate the dot product and Euclidean norms.
buyer_product_matrix AS (
    SELECT a.buyer_id AS buyer_id_a, b.buyer_id AS buyer_id_b,
           SUM(a.normalized_rating * b.normalized_rating) AS dot_product,
           SQRT(SUM(a.normalized_rating * a.normalized_rating)) AS norm_a,
           SQRT(SUM(b.normalized_rating * b.normalized_rating)) AS norm_b
    FROM normalized_order_items a
    JOIN normalized_order_items b ON a.product_id = b.product_id
    GROUP BY a.buyer_id, b.buyer_id
),

-- Calculate the similarity scores using the cosine similarity measure.
buyer_similarity AS (
    SELECT buyer_id_a, buyer_id_b,
           dot_product / (norm_a * norm_b) AS similarity,
           RANK() OVER (PARTITION BY buyer_id_a ORDER BY dot_product / (norm_a * norm_b) DESC) AS ranked
    FROM buyer_product_matrix
    WHERE buyer_id_a <> buyer_id_b
),

-- Select the top K similar buyers.
top_k_similar_users AS (
    SELECT buyer_id_a, buyer_id_b, similarity
    FROM buyer_similarity
    WHERE ranked <= @K
),

-- Create a list of all possible buyer-product combinations.
all_combinations AS (
    SELECT DISTINCT a.buyer_id, b.product_id
    FROM order_items a, order_items b
),

-- Select the unpurchased combinations.
unpurchased_combinations AS (
    SELECT ac.buyer_id, ac.product_id
    FROM all_combinations ac
    LEFT JOIN order_items oi ON ac.buyer_id = oi.buyer_id AND ac.product_id = oi.product_id
    WHERE oi.buyer_id IS NULL
),

-- Predict the buyer evaluations for each unpurchased combination.
predicted_evaluations AS (
    SELECT uc.buyer_id, uc.product_id,
           SUM(oi.buyer_evaluation) / @K AS predicted_evaluation
    FROM unpurchased_combinations uc
    JOIN top_k_similar_users tksu ON uc.buyer_id = tksu.buyer_id_a
    JOIN order_items oi ON tksu.buyer_id_b = oi.buyer_id AND uc.product_id = oi.product_id
    WHERE uc.buyer_id = @selected_user_id
    GROUP BY uc.buyer_id, uc.product_id
),

-- Filter out the predicted evaluations which are lower than the selected buyer's mean rating. 
filtered_recommendations AS (
    SELECT buyer_id, product_id, predicted_evaluation
    FROM predicted_evaluations
    WHERE predicted_evaluation > (SELECT mean_rating FROM buyer_mean_ratings WHERE buyer_id = @selected_user_id)
)
SELECT *
FROM filtered_recommendations
ORDER BY predicted_evaluation DESC;