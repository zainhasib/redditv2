class Post {
  String id;
  String title;
  String imageUrl;
  bool network;
  int imageHeight;
  bool likes;
  String subreddit;
  int ups;
  int downs;
  double createdUtc;
  bool isVideo;
  int upvotes;

  Post(id, title, imageUrl, network, imageHeight, likes, subreddit, ups, downs,
      createdUtc, isVideo, upvotes) {
    this.id = id;
    this.title = title;
    this.imageUrl = imageUrl;
    this.network = network;
    this.imageHeight = imageHeight;
    this.likes = likes;
    this.subreddit = subreddit;
    this.ups = ups;
    this.downs = downs;
    this.createdUtc = createdUtc;
    this.isVideo = isVideo;
    this.upvotes = upvotes;
  }
}
