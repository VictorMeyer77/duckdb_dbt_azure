{{
    config(
        materialized="external",
        location="abfs://silver@{{ env_var('STORAGE_ACCOUNT_NAME') }}.blob.core.windows.net/books/books_data.parquet",
        format="parquet"
    )
}}

SELECT DISTINCT
    Title AS title,
    description,
    image,
    previewLink AS preview_link,
    publisher,
    infoLink AS info_link,
    ratingsCount AS ratings_count,
    ingest_time,
    HASH(Title) AS id,
    STR_SPLIT_REGEX(REGEXP_REPLACE(authors, '(\[|\]|'')', '', 'g'), ', ')
        AS authors,
    LEFT(publishedDate, 4) AS published_date,
    STR_SPLIT_REGEX(REGEXP_REPLACE(categories, '(\[|\]|'')', '', 'g'), ', ')
        AS categories
FROM {{ ref("brz_books_data") }}
WHERE title IS NOT NULL
