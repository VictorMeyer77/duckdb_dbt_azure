{{
    config(
        materialized="external",
        location="datalake/gold/dim_publisher.parquet",
        format="parquet"
    )
}}

SELECT
    publisher_name,
    ROW_NUMBER() OVER () AS id
FROM
    (
        SELECT DISTINCT TRIM(publisher) AS publisher_name
        FROM {{ ref("svr_books_data") }}
        UNION
        SELECT 'unknown' AS publisher_name
    )
