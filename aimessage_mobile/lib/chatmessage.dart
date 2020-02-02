import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String name;
  final Color color;
  final CrossAxisAlignment alignment;
  final TextAlign textAlignment;

// constructor to get text from textfield
  ChatMessage({this.text, this.name, this.color, this.alignment, this.textAlignment});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Card(
        color: color,
        child: Container(
          padding: EdgeInsets.only(left: 10.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
              crossAxisAlignment: alignment,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: alignment,
                  children: <Widget>[
                    // new Text(name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      width: screenWidth * 0.9,
                      child: new Text(text, maxLines: 30, textAlign: textAlignment,),
                    )
                  ],
                )
              ],
            )));
  }
}
