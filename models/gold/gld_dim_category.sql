{{
    config(
        materialized="external",
        location="abfs://gold@devduckdbtazsto.blob.core.windows.net/books/dim_category.parquet",
        format="parquet"
    )
}}

SELECT
    ROW_NUMBER() OVER () AS id,
    category_name
FROM
    (
        SELECT DISTINCT
            TRIM(REGEXP_REPLACE(UNNEST(categories), '"', '', 'g'))
                AS category_name
        FROM {{ ref("svr_books_data") }}
    )
UNION
SELECT -1 AS id, 'unknown' AS category_name
