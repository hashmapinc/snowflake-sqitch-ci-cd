-- Deploy flipr:users to snowflake
-- requires: appschema

USE WAREHOUSE &warehouse;
CREATE TABLE flipr.users (
    nickname  TEXT         PRIMARY KEY,
    password  TEXT         NOT NULL,
    fullname  TEXT         NOT NULL,
    twitter   TEXT         NOT NULL,
    timestamp TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
