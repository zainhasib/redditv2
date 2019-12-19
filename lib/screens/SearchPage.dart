import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:redditv2/screens/Subreddit.dart';
import 'package:redditv2/utils/FetchToken.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.searchTerm}) : super(key: key);
  final searchTerm;
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  var accessToken;
  List<Widget> subreddits = [];
  bool loaded = false;

  Future searchSubreddit(String term, String options) async {
    var url = 'https://oauth.reddit.com/api/' + term + '?' + options;
    print(url);
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    var response = await http.post(url, headers: headers);
    return response;
  }

  @override
  void initState() {
    super.initState();
    fetchToken().then((v) {
      accessToken = json.decode(v.body)['access_token'];
      searchSubreddit('search_subreddits', 'query=' + widget.searchTerm)
          .then((res) {
        setState(() {
          loaded = true;
        });
        final List data = json.decode(res.body)['subreddits'];
        if (data != null) {
          if (data.length > 0) {
            setState(() {
              data.forEach((d) {
                subreddits.add(GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctxt) => Subreddit(
                            subreddit: d['name'],
                          ),
                        ));
                  },
                  child: Container(
                    color: Color(0xFF333333),
                    margin: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: d['icon_img'] != ''
                                        ? NetworkImage(d['icon_img'])
                                        : NetworkImage(
                                            'https://cdn3.iconfinder.com/data/icons/2018-social-media-logotypes/1000/2018_social_media_popular_app_logo_reddit-512.png'),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                                child: Container(),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'r/' + d['name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    d['subscriber_count'].toString() +
                                        ' subscribers',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
              });
            });
          }
        }
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search result'),
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: loaded
              ? subreddits.map((d) => d).toList()
              : [
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
