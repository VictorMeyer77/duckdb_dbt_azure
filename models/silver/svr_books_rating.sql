{{
    config(
        materialized="external",
        location="datalake/silver/books_rating.parquet",
        format="parquet"
    )
}}

WITH last_review AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                User_id,
                profileName,
                "review/helpfulness",
                "review/score",
                "review/summary",
                "review/text"
            ORDER BY "review/time" DESC
        ) AS rank
    FROM
        {{ ref("brz_books_rating") }}

)

SELECT
    Title AS title,
    price::FLOAT AS price,
    User_id AS user_id,
    profileName AS profile_name,
    "review/helpfulness" AS review_helpfulness,
    "review/score"::SMALLINT AS review_score,
    "review/summary" AS review_summary,
    "review/text" AS review_text,
    ingest_time,
    HASH(CONCAT(
        User_id,
        profileName,
        "review/helpfulness",
        "review/score",
        "review/summary",
        "review/text"
    )) AS id,
    TO_TIMESTAMP("review/time") AS review_time
FROM last_review
WHERE
    id IS NOT NULL
    AND title IS NOT NULL
    AND rank = 1
