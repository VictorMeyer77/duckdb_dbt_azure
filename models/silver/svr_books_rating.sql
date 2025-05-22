{{
    config(
        materialized="external",
        location="datalake/silver/books_rating.parquet",
        format="parquet"
    )
}}

SELECT
    id,
    title,
    price::FLOAT AS price,
    user_id,
    profilename AS profile_name,
    "review/helpfulness" AS review_helpfulness,
    "review/score"::SMALLINT AS review_score,
    "review/summary" AS review_summary,
    "review/text" AS review_text,
    ingest_time,
    TO_TIMESTAMP("review/time") AS review_time
FROM {{ ref("brz_books_rating") }}
WHERE id IS NOT NULL
AND title IS NOT NULL
