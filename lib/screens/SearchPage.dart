import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  List<Widget> subreddits;

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
      searchSubreddit('search_reddit_names', 'query=' + widget.searchTerm)
          .then((res) {
        final List data = json.decode(res.body)['names'];
        if (data != null) {
          if (data.length > 0) {
            setState(() {
              data.forEach((d) {
                subreddits.add(
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(d),
                    ),
                  ),
                );
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
            children: subreddits.map((d) => d),
          )),
    );
  }
}
