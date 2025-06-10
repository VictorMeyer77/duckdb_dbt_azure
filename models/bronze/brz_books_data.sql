{{
    config(
        materialized="external",
        location="abfs://bronze@{{ env_var('STORAGE_ACCOUNT_NAME') }}.blob.core.windows.net/books/books_data.parquet",
        format="parquet"
    )
}}

SELECT
    Title,
    description,
    authors,
    image,
    previewLink,
    publisher,
    publishedDate,
    infoLink,
    categories,
    ratingsCount,
    CURRENT_TIMESTAMP AS ingest_time
FROM {{ source("raw", "books_data") }}
