{{
    config(
        materialized="external",
        location="abfs://gold@devduckdbtazsto.blob.core.windows.net/books/dim_author.parquet",
        format="parquet"
    )
}}

SELECT
    ROW_NUMBER() OVER () AS id,
    author_name
FROM
    (
        SELECT DISTINCT
            TRIM(REGEXP_REPLACE(UNNEST(authors), '"', '', 'g')) AS author_name
        FROM {{ ref("svr_books_data") }}
    )
UNION
SELECT -1 AS id, 'unknown' AS author_name
