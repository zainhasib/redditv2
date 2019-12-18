import 'package:flutter/material.dart';

class HeaderOptions extends StatefulWidget {
  @override
  _HeaderOptionsState createState() => _HeaderOptionsState();
}

class _HeaderOptionsState extends State<HeaderOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.black54,
      width: MediaQuery.of(context).size.width,
    );
  }
}
