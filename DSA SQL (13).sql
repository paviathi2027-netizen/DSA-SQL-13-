WITH calls_details AS (SELECT 
pc.caller_id,
pc.receiver_id,
caller.country_id as call_country,
receiver.country_id as receiver_country
FROM phone_calls as pc 
LEFT JOIN phone_info caller 
ON caller.caller_id = pc.caller_id

LEFT JOIN phone_info receiver
ON receiver.caller_id = pc.receiver_id)

SELECT 
round(100.0 * sum(CASE WHEN call_country != receiver_country THEN 1 ELSE 0 END ) / count(*), 1) 
AS international_call
FROM calls_details;

# OR
# IN PostgreSQL
SELECT ROUND(100.0 * COUNT(*) FILTER(WHERE b.country_id != c.country_id) /
  COUNT(*), 1)
FROM phone_calls AS a
JOIN phone_info AS b
  ON a.caller_id = b.caller_id
JOIN phone_info AS c
  ON a.receiver_id = c.caller_id