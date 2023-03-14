from tweet_parser import read_raw_json_file, json_text_to_dict, parse_raw_tweets, transform_dict_to_dataframe
from s3_writer import dataframe_to_s3, s3_client_init

json_file_path = '/home/clauro/personal_projects/FlixDataEngineering/data/tweets_4.json'

text = read_raw_json_file(json_file_path)

raw_tweets_dict = json_text_to_dict(text)

cleansed_tweets_list = parse_raw_tweets(raw_tweets_dict)

cleansed_tweets_df = transform_dict_to_dataframe(cleansed_tweets_list)

dataframe_to_s3(s3_client=s3_client_init(),
                input_datafame=cleansed_tweets_df, bucket_name='flixbus')
