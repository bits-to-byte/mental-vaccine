import 'package:twitter_api/twitter_api.dart';
import 'dart:convert';

// Creating the twitterApi Object with the secret and public keys
// These keys are generated from the twitter developer page
// Dont share the keys with anyone
final _twitterOauth = new twitterApi(
    consumerKey: env.consumer_key,
    consumerSecret: env.consumer_secret,
    token: env.token,
    tokenSecret: env.token_secret
);

// Make the request to twitter
Future twitterRequest = _twitterOauth.getTwitterRequest(
  // Http Method
  "GET",
  // Endpoint you are trying to reach
  "statuses/user_timeline.json",
  // The options for the request
  options: {
    "user_id": "19025957",
    "screen_name": "TTCnotices",
    "count": "20",
    "trim_user": "true",
    "tweet_mode": "extended", // Used to prevent truncating tweets
  },
);
