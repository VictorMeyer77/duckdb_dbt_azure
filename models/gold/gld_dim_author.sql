{{
    config(
        materialized="external",
        location="datalake/gold/dim_author.parquet",
        format="parquet"
    )
}}

SELECT
    name,
    ROW_NUMBER() OVER () AS id
FROM
    (
        SELECT DISTINCT TRIM(REGEXP_REPLACE(UNNEST(authors), '"', '', 'g')) AS name
        FROM {{ ref("svr_books_data") }}
        UNION
        SELECT 'unknown' AS name
    )
