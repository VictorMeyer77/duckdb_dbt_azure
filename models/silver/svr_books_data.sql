{{
    config(
        materialized="external",
        location="datalake/silver/books_data.parquet",
        format="parquet"
    )
}}

SELECT
    title,
    description,
    image,
    previewlink AS preview_link,
    publisher,
    infolink AS info_link,
    ratingscount AS ratings_count,
    ingest_time,
    STR_SPLIT_REGEX(REGEXP_REPLACE(authors, '(\[|\]|'')', '', 'g'), ', ')
        AS authors,
    LEFT(publisheddate, 4) AS published_date,
    STR_SPLIT_REGEX(REGEXP_REPLACE(categories, '(\[|\]|'')', '', 'g'), ', ')
        AS categories
FROM {{ ref("brz_books_data") }}
WHERE title IS NOT NULL
