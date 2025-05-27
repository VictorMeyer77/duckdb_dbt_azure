{{
    config(
        materialized="external",
        location="abfs://gold@devduckdbtazsto.blob.core.windows.net/books/dim_book_author.parquet",
        format="parquet"
    )
}}

WITH flatten_book AS (
    SELECT DISTINCT
        id,
        TRIM(
            REGEXP_REPLACE(UNNEST(COALESCE(authors, ['unknown'])), '"', '', 'g')
        )
            AS author
    FROM {{ ref("svr_books_data") }}
)

SELECT
    book.id AS book_id,
    author.id AS author_id
FROM flatten_book AS book
LEFT JOIN {{ ref("gld_dim_author") }} AS author
    ON book.author = author.author_name
