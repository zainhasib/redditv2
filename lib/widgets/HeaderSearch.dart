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
      child: TextField(
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          filled: true,
          contentPadding:
              new EdgeInsets.symmetric(vertical: -3.0, horizontal: 0.0),
          fillColor: Colors.black87,
        ),
      ),
    );
  }
}
