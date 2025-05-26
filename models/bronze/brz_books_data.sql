{{
    config(
        materialized="external",
        location="datalake/bronze/books_data.parquet",
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
