-- Verify flipr:users on snowflake

USE WAREHOUSE &warehouse;
SELECT nickname, password, fullname, twitter, timestamp
  FROM flipr.users
WHERE FALSE;
