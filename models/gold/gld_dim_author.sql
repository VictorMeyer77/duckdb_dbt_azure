{{
    config(
        materialized="external",
        location="datalake/gold/dim_author.parquet",
        format="parquet"
    )
}}

SELECT
    author_name,
    ROW_NUMBER() OVER () AS id
FROM
    (
        SELECT DISTINCT
            TRIM(REGEXP_REPLACE(UNNEST(authors), '"', '', 'g')) AS author_name
        FROM {{ ref("svr_books_data") }}
        UNION
        SELECT 'unknown' AS author_name
    )
