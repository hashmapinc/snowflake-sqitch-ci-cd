-- Deploy flipr:hashtags to snowflake
-- requires: flips

USE WAREHOUSE &warehouse;
CREATE TABLE flipr.hashtags (
    flip_id   INTEGER       NOT NULL REFERENCES flipr.flips(id),
    hashtag   VARCHAR(128)  NOT NULL,
    PRIMARY KEY (flip_id, hashtag)
);
