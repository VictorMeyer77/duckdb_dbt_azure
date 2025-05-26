{{
    config(
        materialized="external",
        location="datalake/gold/dim_book_category.parquet",
        format="parquet"
    )
}}

WITH flatten_book AS (
    SELECT DISTINCT
        id,
        TRIM(
            REGEXP_REPLACE(
                UNNEST(COALESCE(categories, ['unknown'])), '"', '', 'g'
            )
        )
            AS category
    FROM {{ ref("svr_books_data") }}
)

SELECT
    book.id AS book_id,
    category.id AS category_id
FROM flatten_book AS book
LEFT JOIN {{ ref("gld_dim_category") }} AS category
    ON book.category = category.category_name
