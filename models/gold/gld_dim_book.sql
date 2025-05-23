{{
    config(
        materialized="external",
        location="datalake/gold/dim_book.parquet",
        format="parquet"
    )
}}

WITH flatten_book AS (
    SELECT DISTINCT
        title,
        description,
        image,
        preview_link,
        info_link,
        published_date,
        COALESCE(TRIM(publisher), 'unknown') AS publisher,
        TRIM(
            REGEXP_REPLACE(UNNEST(COALESCE(authors, ['unknown'])), '"', '', 'g')
        )
            AS author,
        TRIM(
            REGEXP_REPLACE(
                UNNEST(COALESCE(categories, ['unknown'])), '"', '', 'g'
            )
        )
            AS category
    FROM {{ ref("svr_books_data") }}
)

SELECT
    book.title,
    book.description,
    book.image,
    book.preview_link,
    book.info_link,
    book.published_date,
    publisher.id AS publisher_id,
    ROW_NUMBER() OVER () AS id,
    LIST(author.id) FILTER (author.id IS NOT NULL) AS author_id, -- noqa
    LIST(category.id) FILTER (category.id IS NOT NULL) AS category_id -- noqa
FROM flatten_book AS book
LEFT JOIN {{ ref("gld_dim_author") }} AS author
    ON book.author = author.author_name
LEFT JOIN {{ ref("gld_dim_category") }} AS category
    ON book.category = category.category_name
LEFT JOIN {{ ref("gld_dim_publisher") }} AS publisher
    ON book.publisher = publisher.publisher_name
GROUP BY
    book.title,
    book.description,
    book.image,
    book.preview_link,
    book.info_link,
    book.published_date,
    publisher.id,
