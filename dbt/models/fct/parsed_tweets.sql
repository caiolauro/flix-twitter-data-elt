{{
    config(
    materialized = 'incremental',
    on_schema_change = 'fail'
    )
}}
-- Changes in the data source schema [X]
WITH raw_tweets AS (
    SELECT
        raw_tweet['id_str']::varchar as tweet_id,
        raw_tweet['created_at']::timestamp as created_at,
        raw_tweet['entities']['hashtags']::array as hashtags,
        raw_tweet['retweeted']::boolean as is_retweet,
        raw_tweet['text']::varchar as tweet_text,
        raw_tweet['user']['id_str']::varchar as user_id,
        raw_tweet['user']['followers_count']::integer as user_followers_count,
        raw_tweet['user']['location']::varchar as user_location
    FROM
        {{ source('flix', 'raw_tweets') }}
)
SELECT
tweet_id,
created_at,
hashtags,
is_retweet,
tweet_text,
user_id,
user_followers_count,
user_location
FROM
    raw_tweets

{% if is_incremental() %}
  WHERE created_at > (select max(created_at) from {{ this }})
{% endif %}