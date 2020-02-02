import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chatmessage.dart';
import 'models.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String sender;
  final String receiver;
  final List<Message> messages;

  ChatScreen(this.sender, this.receiver, this.messages);
  
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  final TextEditingController _chatController = new TextEditingController();
  ScrollController _controller = ScrollController();
  String _now;
  Timer _everySecond;

  main() {

    // sets first value
    // defines a timer 
    _everySecond = Timer.periodic(Duration(seconds: 2), (Timer t) {
      FirebaseDatabase.instance.reference().child(widget.sender.replaceFirst(".", "dot")).
      child('contacts').child(widget.receiver.replaceFirst(".", "dot")).once().
      then((onValue) {
          DataSnapshot snapshot = onValue;
          int newLength = snapshot.value["messages"].length;
          if (newLength > widget.messages.length){
            setState(() {
              for (int i = widget.messages.length; i < newLength; i++){
                var msg = snapshot.value["messages"][i];
                widget.messages.add(Message(msg["sender"], msg["receiver"], msg["text"]));
              }
            });
          }
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (BuildContext context) => HomePage(auth))
          // );
        });
      // setState(() {
        
      // });
    });
  }

  void _handleSubmit(String text) {
    _chatController.clear();
    setState(() {
      // add to widget display on page
      widget.messages.add(Message(widget.sender, widget.receiver, text));
      // add to firebase
      FirebaseDatabase.instance.reference().child(widget.sender.replaceFirst(".", "dot")).child('contacts').
      child(widget.receiver.replaceFirst(".", "dot")).child('messages').child("${widget.messages.length - 1}").
        set({
          'sender': widget.sender,
          'receiver': widget.receiver,
          'text': text,
        }).then((onValue) {
        });
      FirebaseDatabase.instance.reference().child(widget.receiver.replaceFirst(".", "dot")).child('contacts').
      child(widget.sender.replaceFirst(".", "dot")).child('messages').child("${widget.messages.length - 1}").
        set({
          'sender': widget.sender,
          'receiver': widget.receiver,
          'text': text,
        }).then((onValue) {
        });

    });

}

  Widget _chatEnvironment (){
    return IconTheme(
      data: new IconThemeData(color: Theme.of(context).primaryColor),
          child: new Container(
        margin: const EdgeInsets.symmetric(horizontal:8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(hintText: "Start typing ..."),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                
                onPressed: ()=> _handleSubmit(_chatController.text),
                 
              ),
            )
          ],
        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    main();
    return new Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver.replaceFirst("dot", ".")),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      body: Column(
        children: <Widget>[
          new Flexible(
            child: ListView.builder(
              controller: _controller,
              padding: new EdgeInsets.all(8.0),
              itemBuilder: (_, int index) {
                var message = widget.messages[index].text;
                var name = widget.messages[index].sender.replaceFirst("dot", ".");
                // print("sender: ${widget.sender}");
                if (name == widget.sender.replaceFirst("dot", ".")){
                  return ChatMessage(text: message, name:name, color: Theme.of(context).primaryColor, alignment: CrossAxisAlignment.end,textAlignment: TextAlign.end);
                }
                else {
                  return ChatMessage(text: message, name:name, color: null, alignment: CrossAxisAlignment.start,textAlignment: TextAlign.left,);
                }
              },
              itemCount: widget.messages.length,
            ),
          ),
          new Divider(
            height: 1.0,
          ),
          new Container(decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _chatEnvironment(),),
          SizedBox(height:20.0)
        ],
      ));
  }
}