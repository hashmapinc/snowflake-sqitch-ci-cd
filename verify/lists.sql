-- Verify flipr:lists on snowflake

USE WAREHOUSE &warehouse;
SELECT nickname, name, description, created_at
  FROM flipr.lists
 WHERE FALSE;
