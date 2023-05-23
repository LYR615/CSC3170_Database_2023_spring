-- Set the minimum support and confidence thresholds.
SET @min_support = 0.06;
SET @min_confidence = 0.5;

-- Calculate the total number of orders in the order_items table.
WITH total_orders AS (
  SELECT COUNT(DISTINCT order_id) AS total
  FROM order_items
),

-- Calculate the support of each single item.
single_item_support AS (
  SELECT product_id,COUNT(DISTINCT order_id) * 1.0 / (SELECT total FROM total_orders) AS support
  FROM order_items
  GROUP BY product_id
),

-- Select the frequent single items.
frequent_single_items AS (
  SELECT *
  FROM single_item_support
  WHERE support >= @min_support
),

-- Combine the frequent single items to create pairs of candidate frequent itemsets.
candidate_pairs AS (
  SELECT f1.product_id AS product_id1, f2.product_id AS product_id2
  FROM frequent_single_items f1
  JOIN frequent_single_items f2 ON f1.product_id < f2.product_id
),

-- Calculates the support of each candidate frequent itemset.
pair_support AS (
  SELECT cp.product_id1, cp.product_id2, COUNT(DISTINCT t.order_id) * 1.0 / (SELECT total FROM total_orders) AS support
  FROM candidate_pairs cp
  JOIN order_items t ON cp.product_id1 = t.product_id
  JOIN order_items t2 ON cp.product_id2 = t2.product_id AND t.order_id = t2.order_id
  GROUP BY cp.product_id1, cp.product_id2
),

-- Select the frequent itemsets with size 2.
frequent_itemsets AS (
  SELECT *
  FROM pair_support
  WHERE support >= @min_support
),   

-- Calculate the confidence and lift for each association rule derived from the frequent itemsets.
association_rules AS (
  SELECT fi.product_id1 AS antecedent, fi.product_id2 AS consequent, fi.support / s1.support AS confidence, fi.support / (s1.support * s2.support) AS lift
  FROM frequent_itemsets fi
  JOIN single_item_support s1 ON fi.product_id1 = s1.product_id
  JOIN single_item_support s2 ON fi.product_id2 = s2.product_id
  UNION ALL
  SELECT fi.product_id2 AS antecedent, fi.product_id1 AS consequent, fi.support / s2.support AS confidence, fi.support / (s1.support * s2.support) AS lift
  FROM frequent_itemsets fi
  JOIN single_item_support s1 ON fi.product_id1 = s1.product_id
  JOIN single_item_support s2 ON fi.product_id2 = s2.product_id
),

-- Selects the frequent association rules and outputs them in descending order of confidence.
frequent_rules AS (
  SELECT *
  FROM association_rules
  WHERE confidence >= @min_confidence
)

SELECT *
FROM frequent_rules
ORDER BY confidence DESC;