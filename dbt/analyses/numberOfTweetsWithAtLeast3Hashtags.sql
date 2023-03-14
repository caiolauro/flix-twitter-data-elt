-- Total number of tweets with at least 3 hashtags
    SELECT count(distinct tweet_id)
    FROM
        {{ source('flix', 'raw_tweets_cleansed') }}
    where array_size(tweet_hasthags) >= 3