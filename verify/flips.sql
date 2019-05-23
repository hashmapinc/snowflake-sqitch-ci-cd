-- Verify flipr:flips on snowflake

USE WAREHOUSE &warehouse;
SELECT id, nickname, body, timestamp
  FROM flipr.flips
 WHERE FALSE;
