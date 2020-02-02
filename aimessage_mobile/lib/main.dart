import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'signup.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Map<int, Color> color =
  {
  50:Color.fromRGBO(17,214,214, .1),
  100:Color.fromRGBO(17,214,214, .2),
  200:Color.fromRGBO(17,214,214, .3),
  300:Color.fromRGBO(17,214,214, .4),
  400:Color.fromRGBO(17,214,214, .5),
  500:Color.fromRGBO(17,214,214, .6),
  600:Color.fromRGBO(17,214,214, .7),
  700:Color.fromRGBO(17,214,214, .8),
  800:Color.fromRGBO(17,214,214, .9),
  900:Color.fromRGBO(17,214,214, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ai Message',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff11d6d6,color),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white
          )
        )
      ),
      home: MyHomePage(title: 'Ai Message', auth: new Auth()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth}) : super(key: key);

  final String title;
  final BaseAuth auth;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var errorMessage = "";
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.message,
              size: 100.0,
              color: Theme.of(context).primaryColor
            ),
            Text("Welcome to Ai Message!"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width:10.0),
                Container(child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ), width: screenWidth*0.3)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width:10.0),
                Container(child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password"
                  ),
                ), width: screenWidth*0.3)
              ],
            ),
            Text(errorMessage),
            RaisedButton(
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: Text("Log In"),
              onPressed: () async {
                // print(_email.text);
                // print(_password.text);
                try {
                  var userId = await widget.auth.signIn(_email.text, _password.text);
                  print(userId);
                  setState(() {
                    errorMessage = "";
                  });
                  Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePage(widget.auth))
                );
                }
                catch (e) {
                  setState(() {
                    errorMessage = "Invalid email/password.";
                  });
                }
              },),
            RaisedButton(
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: Text("Sign Up"),
              onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUp(widget.auth))
                  );
              },)
          ],
        ),
      ),
    );
  }
}
