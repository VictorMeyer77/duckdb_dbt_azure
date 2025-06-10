{{
    config(
        materialized="external",
        location="abfs://bronze@{{ env_var('STORAGE_ACCOUNT_NAME') }}.blob.core.windows.net/books/books_rating.parquet",
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
