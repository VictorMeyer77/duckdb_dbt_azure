{{
    config(
        materialized="external",
        location="abfs://gold@{{ env_var('STORAGE_ACCOUNT_NAME') }}.blob.core.windows.net/books/dim_user.parquet",
        format="parquet"
    )
}}

SELECT
    COALESCE(user_id, 'unknown') AS id,
    COALESCE(profile_name, 'unknown') AS username
FROM
    (
        SELECT
            user_id,
            profile_name,
            ROW_NUMBER()
                OVER (
                    PARTITION BY user_id
                    ORDER BY review_time DESC
                )
                AS rank
        FROM {{ ref("svr_books_rating") }}
    )
WHERE rank = 1
