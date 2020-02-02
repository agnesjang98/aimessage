import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100.0,),
            Text("Test")
          ]
        ),
      );
  }
}