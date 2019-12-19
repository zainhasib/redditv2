import 'package:flutter/material.dart';
import 'package:redditv2/widgets/Favorites.dart';
import 'package:redditv2/widgets/HeaderSearch.dart';
import 'package:redditv2/widgets/PostList.dart';
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

  @override
  void initState() {
    super.initState();
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
        title: HeaderSearch(),
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
      body: _selectedIndex == 0
          ? TabBarView(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  child: PostList(
                    type: 'best',
                    limit: '20',
                    endpoint: '',
                  ),
                ),
                Container(
                  color: Colors.black,
                  child: PostList(
                    type: 'top',
                    limit: '20',
                    endpoint: '',
                  ),
                ),
              ],
            )
          : _selectedIndex == 1
              ? Favorite()
              : Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/profile.jpg'),
                    ),
                    Container(
                      color: Colors.black,
                      child: Text(
                        'Goluuuuu😜',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
    );
  }
}
