show integrations;

desc integration "flixbus";
// STORAGE_AWS_IAM_USER_ARN	String	arn:aws:iam::875784680923:user/cvw40000-s
// STORAGE_AWS_ROLE_ARN	String	arn:aws:iam::190687746545:role/flix_snowflake_integration_role
// STORAGE_AWS_EXTERNAL_ID	String	YJ68275_SFCRole=2_xrJbiQD+CcYecOD0xOKma8OhPvM=

show stages;

ls @FLIXBUS_STAGE;


// READING STAGE

    //  JSON
    select $1,$1['created_at']::timestamp 
    from @FLIXBUS_STAGE/tweets/tweets.json
    (file_format=>FLIX_ELT_DESIGN.raw.JSON_FILE_FORMAT)
    limit 10;

    // PARQUET
    with 
    parsed_parquet as 
    (select
     $1['is_retweet']::boolean as is_retweet 
    ,$1['tweet_created_at']::timestamp as tweet_created_at 
    ,$1['tweet_hasthags']::array as tweet_hasthags 
    ,$1['tweet_id']::varchar as tweet_id 
    ,$1['tweet_text']::varchar as tweet_text 
    ,$1['user_followers_count']::int as user_followers_count 
    ,$1['user_id']::varchar as user_id 
    ,$1['user_location']::varchar as user_location
    ,$1 as raw_json
    
    from @FLIX_ELT_DESIGN.RAW.FLIXBUS_STAGE/tweets/cleansed_tweets/2023_03_13__10_14_23_314211/2023_03_13__10_14_23_314211__cleansed_tweets.parquet
    (file_format=>FLIX_ELT_DESIGN.raw.PARQUET_FILE_FORMAT)
    limit 10
    )
    select 
    is_retweet,
    tweet_created_at,
    array_size(tweet_hasthags),
    tweet_id,
    tweet_text,
    user_followers_count,
    user_id,
    user_location
    from parsed_parquet ;
    
    create table FLIX_ELT_DESIGN.raw.raw_tweets 
    (raw_tweet variant);


// WRITING INTO SNOWFLAKE

    // JSON Executions 0, 1, 2, 3
    copy into FLIX_ELT_DESIGN.raw.raw_tweets 
    from @FLIX_ELT_DESIGN.raw.FLIXBUS_STAGE/tweets
    file_format=FLIX_ELT_DESIGN.raw.JSON_FILE_FORMAT;

drop table FLIX_ELT_DESIGN.DEV.SRC_TWEETS;
select hashtags from FLIX_ELT_DESIGN.DEV.SRC_TWEETS twt limit 10;

select * from dev.users_overview
;

// Hashtags per User
SELECT 
        hashtags
    FROM
        FLIX_ELT_DESIGN.DEV.PARSED_TWEETS
limit 100;
    

// Most Active day during last week - Assuming Last Week based on data in tweets.json
select distinct 
dayofweek(created_at) as dayOfWeek, count(*)
--date_trunc(week, created_at)
from src_tweets
where date_trunc(week, created_at) = '2022-05-30 00:00:00.000'
group by dayOfWeek
;

// Total number of tweets with at least 3 hashtags
    SELECT count(distinct tweet_id)
    FROM
        FLIX_ELT_DESIGN.DEV.SRC_TWEETS
    where array_size(hashtags) >= 3
        
;

// Maximum number of tweets per user

    SELECT user_id,count(distinct tweet_id) as tweet_count
    FROM
        FLIX_ELT_DESIGN.DEV.SRC_TWEETS
    group by user_id
    order by tweet_count desc
;

select user_id, count(user_id) as count
from FLIX_ELT_DESIGN.DEV.SRC_TWEETS
group by user_id
having count > 1;
21217711
39577893
2269324464;
select user_location
from FLIX_ELT_DESIGN.DEV.SRC_TWEETS
where user_id = '21217711'
  ;

select ;

