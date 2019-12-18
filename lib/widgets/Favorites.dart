import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  var accessToken;
  Map<String, String> list = {};
  List<Widget> subreddits = [];
  bool loaded = false;

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
    var url = 'https://oauth.reddit.com/subreddits/mine/subscriber';
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    var response = await http.get(url, headers: headers);
    return response;
  }

  @override
  void initState() {
    super.initState();
    this.fetchToken().then((d) {
      Map<String, dynamic> tokens = json.decode(d.body);
      accessToken = tokens['access_token'];
      this.fetchData().then((res) {
        List<dynamic> data = json.decode(res.body)['data']['children'];
        data.forEach((f) {
          setState(() {
            if (f['data']['icon_img'] != "")
              list.putIfAbsent(
                  f['data']['display_name'], () => f['data']['icon_img']);
            else if (f['data']['community_icon'] != "")
              list.putIfAbsent(
                  f['data']['display_name'], () => f['data']['community_icon']);
            else
              list.putIfAbsent(
                  f['data']['display_name'],
                  () =>
                      'https://cdn3.iconfinder.com/data/icons/2018-social-media-logotypes/1000/2018_social_media_popular_app_logo_reddit-512.png');
          });
        });
        loaded = true;
        print(list);
        setState(() {
          list.forEach(
            (k, v) => subreddits.add(
              InkWell(
                child: Container(
                  color: Color(0xFF222222),
                  width: MediaQuery.of(context).size.width,
                  alignment: AlignmentDirectional.topStart,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Image.network(v),
                      ),
                      Text(
                        k,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }).catchError((e) {});
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        children: <Widget>[
          Container(
              color: Colors.black,
              child: Column(
                children: loaded
                    ? subreddits
                    : [
                        Padding(
                          padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height / 2) - 100,
                          ),
                          child: CircularProgressIndicator(),
                        )
                      ],
              ))
        ],
      ),
    );
  }
}
