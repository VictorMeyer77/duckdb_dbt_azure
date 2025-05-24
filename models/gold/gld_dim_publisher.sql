{{
    config(
        materialized="external",
        location="datalake/gold/dim_publisher.parquet",
        format="parquet"
    )
}}

SELECT
    ROW_NUMBER() OVER () AS id,
    publisher_name
FROM
    (
        SELECT DISTINCT TRIM(publisher) AS publisher_name
        FROM {{ ref("svr_books_data") }}
    )
UNION
SELECT -1 AS id, 'unknown' AS publisher_name
