import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:redditv2/screens/PostDetail.dart';
import 'package:redditv2/utils/FetchToken.dart';
import 'package:redditv2/widgets/Post.dart';
import '../models/Post.dart' as PostModel;
import 'dart:convert';

class PostList extends StatefulWidget {
  PostList({Key key, this.type, this.limit}) : super(key: key);
  final type;
  final limit;
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  var accessToken;
  var loaded = false;
  var posts = <PostModel.Post>[];
  ScrollController _scrollController = ScrollController();
  bool requestGoingOn = false;

  Future fetchData(String type, String limit, String after) async {
    var url = 'https://oauth.reddit.com/' +
        type +
        '?limit=' +
        limit +
        '&after=' +
        after +
        '&raw_json=1';
    print(url);
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    var response = await http.get(url, headers: headers);
    return response;
  }

  void fetchCompleteData(String after) {
    setState(() {
      requestGoingOn = true;
    });
    fetchToken().then((v) {
      Map<String, dynamic> tokens = json.decode(v.body);
      accessToken = tokens['access_token'];
      fetchData(widget.type, widget.limit, after).then((value) {
        setState(() {
          requestGoingOn = false;
        });
        List<dynamic> data = json.decode(value.body)['data']['children'];
        setState(() {
          loaded = true;
          data.forEach((f) {
            var postData = f['data'];
            if (f['data']['preview'] != null) {
              if (f['data']['is_video']) {
                posts.add(
                  PostModel.Post(
                    postData['id'],
                    postData['title'],
                    postData['secure_media']['reddit_video']['fallback_url'],
                    true,
                    postData['secure_media']['reddit_video']['height'],
                    postData['likes'],
                    postData['subreddit'],
                    postData['ups'],
                    postData['downs'],
                    postData['created_utc'],
                    postData['is_video'],
                    0,
                  ),
                );
              } else if (f['data']['preview']['images'][0]['variants']['gif'] !=
                  null) {
                var img = '';
                var imgH;
                try {
                  imgH = postData['preview']['images'][0]['resolutions'][2]
                      ['height'];
                } catch (e) {
                  imgH = 0;
                }
                try {
                  img = postData['preview']['images'][0]['variants']['gif']
                      ['resolutions'][2]['url'];
                } catch (e) {
                  img = 'no-image';
                }
                posts.add(
                  PostModel.Post(
                    postData['id'],
                    postData['title'],
                    img,
                    true,
                    imgH,
                    postData['likes'],
                    postData['subreddit'],
                    postData['ups'],
                    postData['downs'],
                    postData['created_utc'],
                    postData['is_video'],
                    0,
                  ),
                );
              } else {
                var img = '';
                var imgH;
                try {
                  imgH = postData['preview']['images'][0]['resolutions'][2]
                      ['height'];
                } catch (e) {
                  imgH = 0;
                }
                try {
                  img =
                      postData['preview']['images'][0]['resolutions'][2]['url'];
                } catch (e) {
                  img = 'no-image';
                }
                posts.add(PostModel.Post(
                  postData['id'],
                  postData['title'],
                  img,
                  true,
                  imgH,
                  postData['likes'],
                  postData['subreddit'],
                  postData['ups'],
                  postData['downs'],
                  postData['created_utc'],
                  postData['is_video'],
                  0,
                ));
              }
            } else {
              posts.add(
                PostModel.Post(
                  postData['id'],
                  postData['title'],
                  'no-image',
                  false,
                  0,
                  postData['likes'],
                  postData['subreddit'],
                  postData['ups'],
                  postData['downs'],
                  postData['created_utc'],
                  postData['is_video'],
                  0,
                ),
              );
            }
          });
        });
      }).catchError((e) {
        print(e);
        setState(() {
          requestGoingOn = false;
        });
      });
    }).catchError((e) {
      print(e);
      setState(() {
        requestGoingOn = false;
      });
    });
  }

  void _scrollListener() {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 500) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchCompleteData('');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!requestGoingOn)
          this.fetchCompleteData('t3_' + posts[posts.length - 1].id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: !loaded
                ? [
                    Padding(
                      padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height / 2) - 100,
                        left: 20,
                        right: 20,
                      ),
                      child: CircularProgressIndicator(),
                    )
                  ]
                : [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // Show your info
                        if (index < posts.length) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) =>
                                        PostDetail(post: posts[index]),
                                  ));
                            },
                            child: Post(
                              post: posts[index],
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                      itemCount: posts.length + 1,
                    ),
                  ],
          )
        ],
      ),
    );
  }
}

// posts
//                 .map((post) => GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (ctxt) => PostDetail(post: post),
//                             ));
//                       },
//                       child: Post(
//                         post: post,
//                       ),
//                     ))
//                 .toList(),
