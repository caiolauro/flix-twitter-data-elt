import logging

# set the logging level
logging.basicConfig(level=logging.INFO)

# create a logger object
logger = logging.getLogger(__name__)

# create a handler
handler = logging.FileHandler('/home/clauro/personal_projects/FlixDataEngineering/logs/tweet_parser.log')
handler.setLevel(logging.INFO)

# create a formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

