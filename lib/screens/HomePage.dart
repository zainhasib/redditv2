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
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: DropdownButton<String>(
                          style: TextStyle(color: Colors.white),
                          items:
                              <String>['Hot', 'Top', 'New'].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                      Expanded(
                        child: PostList(
                          type: 'best',
                          limit: '20',
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  child: PostList(
                    type: 'top',
                    limit: '20',
                  ),
                ),
              ],
            )
          : _selectedIndex == 1
              ? Favorite()
              : NotificationListener(
                  child: ListView.builder(
                    itemCount: 200,
                    itemBuilder: (ctxt, index) {
                      return Text('Idiot goluu : $index');
                    },
                  ),
                  onNotification: (t) {
                    if (t is ScrollEndNotification) {
                      print(t);
                    }
                    return false;
                  },
                ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
    );
  }
}
