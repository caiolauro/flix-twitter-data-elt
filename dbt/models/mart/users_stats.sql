with 
raw_avg_tweet_lenght as (
 select distinct user_id
    , avg(length(tweet_text)) as user_tweet_average_length
    from 
    {{ source('flix', 'raw_tweets_cleansed') }}
    group by user_id
),

final_result as 
(
    select 
    distinct 
      raw_final.user_id
    , first_value(user_location) over (partition by raw_final.user_id order by tweet_created_at desc) as user_most_recent_location
    , first_value(user_followers_count) over (partition by raw_final.user_id order by tweet_created_at desc) as user_most_recent_followers_count
    , user_tweet_average_length
    
from 
    {{ source('flix', 'raw_tweets_cleansed') }} raw_final
    
join raw_avg_tweet_lenght on raw_final.user_id = raw_avg_tweet_lenght.user_id
)

select 
user_id,
nullif(nullif(user_most_recent_location,''),'null') as user_most_recent_location,
user_most_recent_followers_count,
user_tweet_average_length

from final_result