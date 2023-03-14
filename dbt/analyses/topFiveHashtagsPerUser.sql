with users_hashtags as

(

select user_id, upper(value::string) as hashtag
from {{ source('flix', 'raw_tweets_cleansed') }} raw, lateral flatten(input => tweet_hasthags, outer => false)

),
pre as
(

select user_id, hashtag, count(hashtag) as times_used
from users_hashtags
group by user_id , hashtag 
order by user_id, times_used desc

)
select user_id, hashtag, RANK() OVER ( PARTITION BY user_id ORDER BY times_used DESC ) as rank, times_used 
from pre


;