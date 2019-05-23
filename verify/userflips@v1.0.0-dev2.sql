-- Verify flipr:userflips on snowflake

USE WAREHOUSE &warehouse;
SELECT id, nickname, fullname, body, timestamp
  FROM flipr.userflips
 WHERE FALSE;
