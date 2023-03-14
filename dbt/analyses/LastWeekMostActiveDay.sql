-- Most Active day during last week - Assuming Last Week based on data in tweets.json

select distinct 
    dayofweek(tweet_created_at) as day_of_week, count(*)
from 
    {{ source('flix', 'raw_tweets_cleansed') }}
where 
    date_trunc(week, tweet_created_at) = '2022-05-30 00:00:00.000'
group by dayOfWeek