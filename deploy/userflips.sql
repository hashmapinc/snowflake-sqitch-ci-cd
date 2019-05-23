-- Deploy flipr:userflips to snowflake
-- requires: appschema
-- requires: users
-- requires: flips

USE WAREHOUSE &warehouse;
CREATE OR REPLACE VIEW flipr.userflips AS
SELECT f.id, u.nickname, u.fullname, u.twitter, f.body, f.timestamp
  FROM flipr.users u
  JOIN flipr.flips f ON u.nickname = f.nickname;
