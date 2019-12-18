import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:redditv2/screens/PostDetail.dart';
import 'package:redditv2/widgets/Favorites.dart';
import '../widgets/Post.dart';
import '../models/Post.dart' as PostModel;
import '../widgets/Drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var title = "Home";
  var posts = <PostModel.Post>[];
  var popularPosts = <PostModel.Post>[];
  var accessToken;
  var loaded = false;
  int _selectedIndex = 0;

  Future fetchToken() async {
    var url =
        'https://www.reddit.com/api/v1/access_token?grant_type=refresh_token&refresh_token=10667572874-C_BHgHe98oTlUc4O4qKZoyCYFSY';
    Map<String, String> headers = {
      'Authorization': 'Basic M0g2RzY2Qm1ZRmFfOHc6'
    };
    var response = await http.post(url, headers: headers);
    return response;
  }

  Future fetchData() async {
    var url = 'https://oauth.reddit.com/best?limit=20&raw_json=1';
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    var response = await http.get(url, headers: headers);
    return response;
  }

  Future fetchDataPopular() async {
    var url = 'https://oauth.reddit.com/r/onepiece/best?limit=20&raw_json=1';
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    var response = await http.get(url, headers: headers);
    return response;
  }

  void fetchCompleteData() {
    setState(() {
      loaded = false;
    });
    posts.clear();
    fetchToken().then((v) {
      Map<String, dynamic> tokens = json.decode(v.body);
      accessToken = tokens['access_token'];
      fetchData().then((value) {
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
                  ),
                );
              } else if (f['data']['preview']['images'][0]['variants']['gif'] !=
                  null) {
                posts.add(
                  PostModel.Post(
                    postData['id'],
                    postData['title'],
                    postData['preview']['images'][0]['variants']['gif']
                        ['resolutions'][2]['url'],
                    true,
                    postData['preview']['images'][0]['resolutions'][2]
                        ['height'],
                    postData['likes'],
                    postData['subreddit'],
                    postData['ups'],
                    postData['downs'],
                    postData['created_utc'],
                    postData['is_video'],
                  ),
                );
              } else {
                posts.add(PostModel.Post(
                  postData['id'],
                  postData['title'],
                  postData['preview']['images'][0]['resolutions'][2]['url'],
                  true,
                  postData['preview']['images'][0]['resolutions'][2]['height'],
                  postData['likes'],
                  postData['subreddit'],
                  postData['ups'],
                  postData['downs'],
                  postData['created_utc'],
                  postData['is_video'],
                ));
              }
            } else {
              posts.add(
                PostModel.Post(
                  postData['id'],
                  postData['title'],
                  'assets/post3.png',
                  false,
                  0,
                  postData['likes'],
                  postData['subreddit'],
                  postData['ups'],
                  postData['downs'],
                  postData['created_utc'],
                  postData['is_video'],
                ),
              );
            }
          });
        });
      }).catchError((e) {
        posts.add(PostModel.Post('4', e.toString(), 'assets/post.jpg', false,
            100, false, 'Debug', 12, 12, 0, false));
      });
    }).catchError((e) {
      posts.add(PostModel.Post('5', e.toString(), 'assets/post.jpg', false, 0,
          false, 'Debug', 12, 12, 0, false));
    });
  }

  @override
  void initState() {
    super.initState();
    this.fetchCompleteData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black87,
        bottom: _selectedIndex == 0
            ? TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: 'Home',
                  ),
                  Tab(
                    text: 'Popular',
                  ),
                ],
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size.zero,
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(
          color: Colors.red,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
        ),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.present_to_all,
            ),
            title: Text('All'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
            ),
            title: Text('Profile'),
          ),
        ],
      ),
      floatingActionButton: (_selectedIndex == 0)
          ? FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                this.fetchCompleteData();
              },
            )
          : Container(),
      body: _selectedIndex == 0
          ? TabBarView(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: !loaded
                            ? [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: (MediaQuery.of(context).size.height /
                                            2) -
                                        100,
                                  ),
                                  child: CircularProgressIndicator(),
                                )
                              ]
                            : posts
                                .map((post) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctxt) =>
                                                  PostDetail(post: post),
                                            ));
                                      },
                                      child: Post(
                                        post: post,
                                      ),
                                    ))
                                .toList(),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            posts.map((post) => Post(post: post)).toList(),
                      )
                    ],
                  ),
                ),
              ],
            )
          : (_selectedIndex == 1 ? Favorite() : Container()),
      drawer: Drawer(
        child: MyDrawer(),
      ),
    );
  }
}
