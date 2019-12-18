import 'package:flutter/material.dart';
import 'package:redditv2/models/Post.dart' as PostModel;
import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  const Post({Key key, this.post}) : super(key: key);
  final PostModel.Post post;
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool upvoted = false;
  bool downvoted = false;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.post.imageUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.likes != null) {
      if (widget.post.likes)
        upvoted = true;
      else
        downvoted = true;
    } else {
      upvoted = false;
      downvoted = false;
    }
    var image = Image.asset(widget.post.imageUrl);
    var date = DateTime.now().difference(
        new DateTime.fromMillisecondsSinceEpoch(
            widget.post.createdUtc.toInt() * 1000));
    int diff;
    String diffUnit;
    if (date.inDays > 365) {
      diff = (date.inDays ~/ 365).toInt();
      diffUnit = ' y';
    } else if (date.inDays > 30) {
      diff = date.inDays ~/ 30;
      diffUnit = ' m';
    } else if (date.inHours > 24) {
      diff = date.inHours ~/ 24;
      diffUnit = ' h';
    } else {
      diff = date.inHours;
      diffUnit = ' h';
    }
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      color: Color(0xFF202020),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'r/' + widget.post.subreddit + ' . ' + diff.toString() + diffUnit,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            padding: EdgeInsets.only(top: 12, bottom: 4, left: 18, right: 8),
          ),
          Container(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              widget.post.title,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            padding: EdgeInsets.only(top: 4, bottom: 8, left: 14, right: 8),
          ),
          widget.post.isVideo
              ? _controller.value.initialized
                  ? Column(
                      children: <Widget>[
                        Container(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        Container(
                          child: Container(
                            child: Center(
                              child: FlatButton(
                                color: Colors.transparent,
                                splashColor: Colors.red,
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      _controller.play();
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(
                      height: widget.post.imageHeight.toDouble(),
                    )
              : Container(
                  height: widget.post.imageHeight > 0
                      ? widget.post.imageHeight.toDouble()
                      : image.height,
                  child: widget.post.network
                      ? Image.network(
                          widget.post.imageUrl,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        )
                      : image,
                ),
          Container(
            alignment: AlignmentDirectional.topStart,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_upward,
                          color: upvoted ? Colors.red : Colors.grey),
                      splashColor: Colors.orange,
                      onPressed: () {
                        setState(() {
                          upvoted = !upvoted;
                          if (upvoted) downvoted = false;
                        });
                      },
                    ),
                    Text(
                      widget.post.ups > 1000
                          ? (widget.post.ups / 1000).toString() + 'K'
                          : widget.post.ups.toString(),
                      style:
                          TextStyle(color: upvoted ? Colors.red : Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_downward,
                          color: downvoted ? Colors.blue : Colors.grey),
                      onPressed: () {
                        setState(() {
                          downvoted = !downvoted;
                          if (downvoted) upvoted = false;
                        });
                      },
                    ),
                    Text(
                      widget.post.downs.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
