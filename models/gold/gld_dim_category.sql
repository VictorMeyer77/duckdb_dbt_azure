{{
    config(
        materialized="external",
        location="datalake/gold/dim_category.parquet",
        format="parquet"
    )
}}

SELECT
    category_name,
    ROW_NUMBER() OVER () AS id
FROM
    (
        SELECT DISTINCT
            TRIM(REGEXP_REPLACE(UNNEST(categories), '"', '', 'g'))
                AS category_name
        FROM {{ ref("svr_books_data") }}
        UNION
        SELECT 'unknown' AS category_name
    )
