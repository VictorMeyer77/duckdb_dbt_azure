{{
    config(
        materialized="external",
        location="datalake/gold/dim_review.parquet",
        format="parquet"
    )
}}

SELECT
    review_helpfulness AS helpfulness,
    review_score AS score,
    review_summary,
    review_text,
    HASH(CONCAT(title, review_text)) AS id
FROM {{ ref("svr_books_rating") }}
