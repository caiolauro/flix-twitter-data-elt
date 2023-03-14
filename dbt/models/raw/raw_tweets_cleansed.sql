{{
config(
materialized = 'incremental'
)
}}

with 
parsed_tweets 
(is_retweet,
tweet_created_at,
tweet_hasthags,
tweet_id,
tweet_text,
user_followers_count,
user_id,
user_location,
raw_json
)
as 
(
select
 $1['is_retweet']::boolean as is_retweet 
,$1['tweet_created_at']::timestamp as tweet_created_at 
,$1['tweet_hasthags']::array as tweet_hasthags 
,$1['tweet_id']::varchar as tweet_id 
,$1['tweet_text']::varchar as tweet_text 
,$1['user_followers_count']::int as user_followers_count 
,$1['user_id']::varchar as user_id 
,$1['user_location']::varchar as user_location
,$1 as raw_json

from '@FLIX.RAW.FLIXBUS_STAGE/tweets/cleansed_tweets/'
(file_format=>flix.raw.PARQUET_FILE_FORMAT)
)
select 
distinct
is_retweet,
tweet_created_at,
tweet_hasthags,
tweet_id,
tweet_text,
user_followers_count,
user_id,
user_location,
raw_json
from parsed_tweets

{% if is_incremental() %}
WHERE tweet_created_at > (select max(tweet_created_at) from {{ this }})
{% endif %}