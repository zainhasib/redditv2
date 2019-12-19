import 'package:flutter/material.dart';
import 'package:redditv2/utils/FetchToken.dart';
import 'package:redditv2/widgets/Comment.dart';
import 'package:redditv2/widgets/Post.dart';
import '../models/Post.dart' as PostModel;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post}) : super(key: key);
  final PostModel.Post post;
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  var accessToken;
  var comments = <String>[];
  var loaded = false;

  Future<dynamic> fetchData() async {
    var url = 'https://oauth.reddit.com/r/' +
        widget.post.subreddit +
        '/comments/' +
        widget.post.id +
        '?raw_json=1';
    print(url);
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    var response = await http.get(url, headers: headers);
    return response;
  }

  void parseData(http.Response res) {}

  @override
  void initState() {
    super.initState();
    fetchToken().then((res) {
      accessToken = json.decode(res.body)['access_token'];
      fetchData().then((res) {
        setState(() {
          loaded = true;
        });
        var com = json.decode(res.body)[1];
        List<dynamic> chain = com['data']['children'];
        chain.forEach((v) {
          var comment = v['data'];
          setState(() {
            if (comment['body'] != null)
              comments.add(comment['body']);
            else
              comments.add('Empty');
          });
        });
      }).catchError((e) {
        print(e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            Post(
              post: widget.post,
            ),
            Column(
              children: [
                Container(
                  color: Colors.black26,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    'Comments',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                Column(
                  children: !loaded
                      ? [
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: CircularProgressIndicator(),
                          )
                        ]
                      : comments
                          .map(
                            (comment) => Comment(
                              text: comment,
                            ),
                          )
                          .toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
