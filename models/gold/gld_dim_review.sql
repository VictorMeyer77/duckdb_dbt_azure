{{
    config(
        materialized="external",
        location="abfs://gold@devduckdbtazsto.blob.core.windows.net/books/dim_review.parquet",
        format="parquet"
    )
}}

SELECT
    id,
    review_helpfulness AS helpfulness,
    review_score AS score,
    review_summary,
    review_text
FROM {{ ref("svr_books_rating") }}
