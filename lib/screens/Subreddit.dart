import 'package:flutter/material.dart';
import 'package:redditv2/widgets/PostList.dart';

class Subreddit extends StatefulWidget {
  Subreddit({Key key, this.subreddit}) : super(key: key);
  final subreddit;
  @override
  State<StatefulWidget> createState() {
    return _Subreddit();
  }
}

class _Subreddit extends State<Subreddit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'r/' + widget.subreddit,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
          color: Colors.black,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PostList(
              type: 'r/' + widget.subreddit + '/best',
              limit: '20',
            ),
          )),
    );
  }
}

// PostList(
//                       type: 'r/' + widget.subreddit + '/best',
//                       limit: '20',
//                     ),
