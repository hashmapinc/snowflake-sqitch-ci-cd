-- Verify flipr:hashtags on snowflake

USE WAREHOUSE &warehouse;
SELECT flip_id, hashtag FROM flipr.hashtags WHERE FALSE;
