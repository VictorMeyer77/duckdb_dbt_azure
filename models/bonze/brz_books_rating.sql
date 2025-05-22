{{
    config(
        materialized="external",
        location="datalake/bronze/books_rating.parquet",
        format="parquet"
    )
}}

SELECT
    id,
    title,
    price,
    user_id,
    profilename,
    "review/helpfulness",
    "review/score",
    "review/time",
    "review/summary",
    "review/text",
    CURRENT_TIMESTAMP AS ingest_time
FROM {{ source("raw", "books_rating") }}
