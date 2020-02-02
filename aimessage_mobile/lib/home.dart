import 'package:flutter/material.dart';
import 'widgets/drawer.dart';
import 'chatscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'models.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  HomePage(this.auth);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var friendNames = ["Gerald", "Geraldie", "Geralda", "Geraldo", "Geraldine"];
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Your Messages"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await _displayDialog(context);
              })
        ],
        leading: Icon(Icons.menu),
      ),
      drawer: MyDrawer(),
      body: FutureBuilder(
          future: fetchConversations(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Press button to start');
              case ConnectionState.waiting:
                return new Text('Loading....');
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else if (snapshot.data == null) {
                  return new Center(child: Text("No conversations yet!"),) ;
                }
                else
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print("snapshot:");
                        // print(snapshot.data);
                        // print("snapshot.data[index]");
                        // print(snapshot.data[index]);
                        String sender = snapshot.data[index].user1;
                        String contact = snapshot.data[index].user2;
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(contact),
                            onTap: () {
                              // open message screen
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatScreen(sender,
                                      contact, snapshot.data[index].messages)));
                            },
                          ),
                        );
                      });
            }
          }),
    );
  }

  TextEditingController _recipientEmail = TextEditingController();
  TextEditingController _newMessage = TextEditingController();

  _displayDialog(BuildContext context) async {
    var screenHeight = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Conversation'),
            content: Container(
              height: screenHeight*0.3,
              child: Center(
                  child: Column(children: <Widget>[
                TextField(
                  controller: _recipientEmail,
                  decoration: InputDecoration(hintText: "Recipient email"),
                ),
                Container(
                    child: new ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: screenHeight*0.3,
                        ),
                        child: new Scrollbar(
                            child: new SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                child: new TextField(
                                    maxLines: null,
                                    controller: _newMessage,
                                    decoration: InputDecoration(hintText: "Type your message here..."),
                                ),
                            ),
                        ),
                    ),
                )
              ])),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                child: Text("SEND"),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // make firebase database insertion for new conversation
      // FirebaseDatabase.instance.reference().child(widget.sender.replaceFirst(".", "dot")).child('contacts').
      // child(widget.receiver.replaceFirst(".", "dot")).child('messages').child("${widget.messages.length - 1}").
      //   set({
      //     'sender': widget.sender,
      //     'receiver': widget.receiver,
      //     'text': text,
      //   }).then((onValue) {
      //     print("added into firebase 1");
      //   });
      // FirebaseDatabase.instance.reference().child(widget.receiver.replaceFirst(".", "dot")).child('contacts').
      // child(widget.sender.replaceFirst(".", "dot")).child('messages').child("${widget.messages.length - 1}").
      //   set({
      //     'sender': widget.sender,
      //     'receiver': widget.receiver,
      //     'text': text,
      //   }).then((onValue) {
      //     print("added into firebase 2");
      //   });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
//fetch contacts
  Future<List<Conversation>> fetchConversations() async {
    List<Conversation> conversations;
    var currentUser = await widget.auth.getCurrentUser();
    email = currentUser.email.replaceFirst(".", "dot");
    DataSnapshot snapshot =
        await FirebaseDatabase.instance.reference().child(email).once();

    Map<dynamic, dynamic> values = snapshot.value;
    // each key is a contact (conversation)
    // each value contains the message list of that conversation
    values.forEach((key, values) {
      if (key == "contacts") {
        conversations = parseConversations(values);
      }
      // parseConversations(values["messages"]);
    });

    // User currentUser = User(userId, );
    // print("conversations:$conversations");

    return conversations;
  }

  List<Conversation> parseConversations(Map messageJSONList) {
    // print(messageJSONList);
    List<Conversation> conversations = [];
    messageJSONList.forEach((key, value) {
      // key is other person
      List<Message> messages = [];
      // print("value[messages]");
      // print(value["messages"]);
      
      


      if (value["messages"] is List) {
        // print("is list");
        for (var message in value["messages"]) {
          // print("msg:$message");
          if (message != null) {
            Message msg = Message(message["sender"], message["receiver"], message["text"]);
            messages.add(msg);
          }
        }
      } else {
        // print("not list");
        Map<dynamic, dynamic> map = value["messages"];
        map.forEach((key, value) {
          Message msg = Message(value["sender"], value["receiver"], value["text"]);
          messages.add(msg);
        });
        
        // var temp = value["messages"];
        // messages.add(Message(temp["sender"], temp["receiver"], temp["text"]));
      }

      Conversation convo = Conversation(email, key, messages);
      conversations.add(convo);
    });

    return conversations;
  }
}
