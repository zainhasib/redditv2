import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  Comment({Key key, this.text}) : super(key: key);
  final String text;

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF333333),
      alignment: AlignmentDirectional.topStart,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        widget.text.trim(),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
