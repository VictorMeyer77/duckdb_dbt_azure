{{
    config(
        materialized="external",
        location="abfs://gold@devduckdbtazsto.blob.core.windows.net/books/fact_review.parquet",
        format="parquet"
    )
}}

SELECT
    rating.id,
    dim_user.id AS user_id,
    dim_book.id AS book_id,
    rating.review_time
FROM {{ ref("svr_books_rating") }} AS rating
LEFT JOIN {{ ref("gld_dim_book") }} AS dim_book
    ON rating.title = dim_book.title
LEFT JOIN {{ ref("gld_dim_user") }} AS dim_user
    ON COALESCE(rating.user_id, 'unknown') = dim_user.id
