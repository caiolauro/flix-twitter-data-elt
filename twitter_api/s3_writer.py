
from logger import logger
from io import StringIO, BytesIO # python3; python2: BytesIO 
from datetime import datetime
import boto3 

def s3_client_init():
    client = boto3.client('s3')
    return client

def dataframe_to_s3(s3_client, input_datafame, bucket_name, format='parquet'):
        logger.info(f"Writing {format} file.")
        current_timestamp = datetime.now().strftime('%Y_%m_%d__%H_%M_%S_%f')
        if format == 'parquet':
            out_buffer = BytesIO()
            input_datafame.to_parquet(out_buffer, index=False)

        elif format == 'csv':
            out_buffer = StringIO()
            input_datafame.to_parquet(out_buffer, index=False)
        file_path = f"tweets/cleansed_tweets/{current_timestamp}/{current_timestamp}__cleansed_tweets.parquet"
        s3_client.put_object(Bucket=bucket_name, Key=file_path, Body=out_buffer.getvalue())
        logger.info(f"Parquet file written at S3 location: {file_path}")