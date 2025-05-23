{{
    config(
        materialized="external",
        location="datalake/gold/dim_publisher.parquet",
        format="parquet"
    )
}}

SELECT
    name,
    ROW_NUMBER() OVER () AS id
FROM
    (
        SELECT DISTINCT TRIM(publisher) AS name
        FROM {{ ref("svr_books_data") }}
        UNION
        SELECT 'unknown' AS name
    )
