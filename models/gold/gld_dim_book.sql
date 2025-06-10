{{
    config(
        materialized="external",
        location="abfs://gold@{{ env_var('STORAGE_ACCOUNT_NAME') }}.blob.core.windows.net/books/dim_book.parquet",
        format="parquet"
    )
}}

SELECT
    book.id,
    book.title,
    book.description,
    book.image,
    book.preview_link,
    book.info_link,
    book.published_date,
    publisher.id AS publisher_id
FROM {{ ref("svr_books_data") }} AS book
LEFT JOIN {{ ref("gld_dim_publisher") }} AS publisher
    ON book.publisher = publisher.publisher_name
