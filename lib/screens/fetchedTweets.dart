import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:twitter_api/twitter_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class TODOScreen extends StatefulWidget {
  final query;
  TODOScreen({Key key, this.query}) : super(key: key);

  @override
  _TODOScreenState createState() => _TODOScreenState();
}

class _TODOScreenState extends State<TODOScreen> {
  String tweet = "Hl";
  var tweets;
  bool done = false;
  var _url;

  final _twitterOauth = new twitterApi(
      consumerKey: env['consumer_key'],
      consumerSecret: env['consumer_secret'],
      token: env['access_key'],
      tokenSecret: env['access_secret']
  );

  _fetchTweets() async {
    print (widget.query);
    Future twitterRequest = _twitterOauth.getTwitterRequest(
      // Http Method
      "GET",
      // Endpoint you are trying to reach
      "search/tweets.json",
      // The options for the request
      options: {
        "q":widget.query,
        "count":"12",
      },
    );
    var res = await twitterRequest;
    setState(() {
      tweets = json.decode(res.body);
    });
    //tweet = tweets["statuses"][0]["text"];
    done = true;
  }

  @override
  void initState() {
    //done = false;
    super.initState();
    setState(() {
      _fetchTweets();
      //_tweetsF();
    });
  }
  @override
  Widget build(BuildContext context) {
    //_fetchTweets();
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetched Tweets"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        physics: ScrollPhysics(),
          child:Column(
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            shrinkWrap: true,
            itemCount: 12,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  background: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.delete),
                    ),
                  ),
                  key: ValueKey(index),
                  child: Card(
                    margin: const EdgeInsets.all(0.0),

                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.data_usage),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(widget.query),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(tweets != null ? tweets["statuses"][index]["text"]:"Loading...."),
                          Text(""),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
