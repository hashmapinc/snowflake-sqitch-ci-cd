-- Deploy flipr:flips to snowflake
-- requires: appschema
-- requires: users

USE WAREHOUSE &warehouse;
CREATE TABLE flipr.flips (
    id        INTEGER        PRIMARY KEY,
    nickname  TEXT           NOT NULL REFERENCES flipr.users(nickname),
    body      VARCHAR(180)   NOT NULL DEFAULT '',
    timestamp TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
