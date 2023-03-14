with 
tweet_length_avg as (
 select distinct user_id
    , avg(length(tweet_text)) as tweet_average_length
    from 
    {{ref("parsed_tweets")}}
    group by user_id
)

select distinct twt.user_id
    , first_value(user_location) over (partition by twt.user_id order by created_at desc) as user_location
    , first_value(user_followers_count) over (partition by twt.user_id order by created_at desc) as user_followers_count
    , tweet_average_length
    
from 
    {{ref("parsed_tweets")}} twt
    
join tweet_length_avg on twt.user_id = tweet_length_avg.user_id