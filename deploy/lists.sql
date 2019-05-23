-- Deploy flipr:lists to snowflake
-- requires: appschema
-- requires: flips

USE WAREHOUSE &warehouse;
CREATE TABLE flipr.lists (
    nickname    TEXT         NOT NULL REFERENCES flipr.users(nickname),
    name        TEXT         NOT NULL,
    description TEXT         NOT NULL,
    created_at  TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
