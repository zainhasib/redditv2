import 'package:flutter/material.dart';

class HeaderSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HeaderSearchState();
  }
}

class _HeaderSearchState extends State<HeaderSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(top: 20, left: 0, right: 20, bottom: 30),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey,
        ),
      ),
    );
  }
}
