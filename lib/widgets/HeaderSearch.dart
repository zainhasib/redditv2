import 'package:flutter/material.dart';
import 'package:redditv2/screens/SearchPage.dart';

class HeaderSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HeaderSearchState();
  }
}

class _HeaderSearchState extends State<HeaderSearch> {
  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _controller,
        onSubmitted: (str) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctxt) => SearchPage(
                  searchTerm: str,
                ),
              ));
        },
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
            suffixIcon: IconButton(
              icon: Icon(
                Icons.cancel,
                size: 16,
                color: Color(0xFF555555),
              ),
              onPressed: () {
                _controller.clear();
              },
            )),
      ),
    );
  }
}
