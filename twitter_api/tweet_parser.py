import json
from datetime import datetime
import pandas as pd
import duckdb
import boto3
from logger import logger


def read_raw_json_file(raw_json_file_path: str) -> str:
    with open(raw_json_file_path, "r") as file:
        text: str = file.read()
        logger.info(f"File read: {raw_json_file_path}")
    return text


def json_text_to_dict(text):
    return json.loads(text)


def extract_hashtags_from_raw_dict(hashtag_iterable: list[dict]) -> list[str]: return [
    iterable['text'] for iterable in hashtag_iterable]


def extract_created_at_from_cleansed_dict(
    cleansed_dict: dict) -> str: return cleansed_dict['tweet_created_at']


def parse_raw_tweets(raw_tweets_list: list[dict]) -> list[dict]:
    """
    Returns a cleansed list of dictionary containing data used for 
    further analysis.

    Parameters:
      raw_tweets_list (list): list of dictionaries, each representing raw tweet data. 

    Returns:
      cleansed_tweets_list(list): list of dictionaries, each representing cleansed tweet data.
    """
    cleansed_tweets_list = []
    cleansed_tweets_dictionary = {}
    if len(raw_tweets_list) == 0:
        logger.warn("Query retrieved no tweets.")
        return []
    else:
        logger.info(f"Starting iteration over {len(raw_tweets_list)} tweets.")
    for raw_tweet in raw_tweets_list:

        # Extract specific variables from raw tweet dictionary
        tweet_id: str = raw_tweet['id_str']
        tweet_created_at_str = raw_tweet['created_at']
        tweet_created_at: datetime = datetime.strptime(
            tweet_created_at_str, '%a %b %d %H:%M:%S %z %Y')
        is_retweet: bool = raw_tweet['retweeted']
        tweet_text: str = raw_tweet['text']
        tweet_hasthags: list = extract_hashtags_from_raw_dict(
            raw_tweet['entities']['hashtags'])
        user_id: str = raw_tweet['user']['id_str']
        user_followers_count: int = raw_tweet['user']['followers_count']
        user_location: str = raw_tweet['user']['location']

        # Populate Dictionary
        cleansed_tweets_dictionary['user_id'] = user_id
        cleansed_tweets_dictionary['tweet_id'] = tweet_id
        cleansed_tweets_dictionary['tweet_created_at'] = tweet_created_at
        cleansed_tweets_dictionary['is_retweet'] = is_retweet
        cleansed_tweets_dictionary['tweet_text'] = tweet_text
        cleansed_tweets_dictionary['tweet_hasthags'] = tweet_hasthags
        cleansed_tweets_dictionary['user_followers_count'] = user_followers_count
        cleansed_tweets_dictionary['user_location'] = user_location

        cleansed_tweets_list.append(cleansed_tweets_dictionary)
        cleansed_tweets_dictionary = {}

    cleansed_tweets_list = sorted(
        cleansed_tweets_list, key=extract_created_at_from_cleansed_dict, reverse=True)
    logger.info(f"Total tweets parsed: {len(cleansed_tweets_list)}")
    return cleansed_tweets_list


def transform_dict_to_dataframe(data: list[dict]) -> pd.DataFrame:
    return pd.DataFrame(data)


if __name__ == '__main__':
    text = read_raw_json_file(
        "/home/clauro/personal_projects/FlixDataEngineering/data/tweets.json")
    RAW_TWEETS_DICT = json_text_to_dict(text)
    cleansed_tweets_list = parse_raw_tweets(
        RAW_TWEETS_DICT)
    df = transform_dict_to_dataframe(cleansed_tweets_list)
