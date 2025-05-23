{{
    config(
        materialized="external",
        location="datalake/silver/books_rating.parquet",
        format="parquet"
    )
}}

SELECT DISTINCT
    Id AS id,
    Title AS title,
    price::FLOAT AS price,
    User_id AS user_id,
    profileName AS profile_name,
    "review/helpfulness" AS review_helpfulness,
    "review/score"::SMALLINT AS review_score,
    "review/summary" AS review_summary,
    "review/text" AS review_text,
    ingest_time,
    TO_TIMESTAMP("review/time") AS review_time
FROM {{ ref("brz_books_rating") }}
WHERE
    id IS NOT NULL
    AND title IS NOT NULL
