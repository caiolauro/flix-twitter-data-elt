import tweepy

# Set up access credentials
consumer_key = 'your-consumer-key' 
consumer_secret = 'your-consumer-secret'
access_token = 'your-access-token'
access_secret = 'your-access-secret'

# Authenticate to the Twitter API
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)

# Create an API object
api = tweepy.API(auth)

# Get data from the Twitter API
data = api.search(q='#yourhashtag', count=100)