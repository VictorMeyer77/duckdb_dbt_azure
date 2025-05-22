{{
    config(
        materialized="external",
        location="datalake/bronze/books_data.parquet",
        format="parquet"
    )
}}

SELECT
    title,
    description,
    authors,
    image,
    previewlink,
    publisher,
    publisheddate,
    infolink,
    categories,
    ratingscount,
    CURRENT_TIMESTAMP AS ingest_time
FROM {{ source("raw", "books_data") }}
