{{
    config(
        materialized="external",
        location="datalake/bronze/books_rating.parquet",
        format="parquet"
    )
}}

SELECT
    Id,
    Title,
    Price,
    User_id,
    profileName,
    "review/helpfulness",
    "review/score",
    "review/time",
    "review/summary",
    "review/text",
    CURRENT_TIMESTAMP AS ingest_time
FROM {{ source("raw", "books_rating") }}
