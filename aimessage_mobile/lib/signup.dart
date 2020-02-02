import 'package:aimessage_mobile/auth.dart';
import 'package:aimessage_mobile/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUp extends StatelessWidget {
  final BaseAuth auth;

  SignUp(this.auth);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _firstName = TextEditingController();
    TextEditingController _lastName = TextEditingController();
    TextEditingController _email = TextEditingController();
    TextEditingController _phoneNumber = TextEditingController();
    TextEditingController _password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Create Account"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width:10.0),
                Container(child: TextFormField(
                  controller: _firstName,
                  decoration: InputDecoration(
                    hintText: "First Name"
                  ),
                ), width: screenWidth*0.3)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width:10.0),
                Container(child: TextFormField(
                  controller: _lastName,
                  decoration: InputDecoration(
                    hintText: "Last Name"
                  ),
                ), width: screenWidth*0.3)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width:10.0),
                Container(child: TextFormField(
                  controller: _phoneNumber,
                  decoration: InputDecoration(
                    hintText: "Phone Number"
                  ),
                ), width: screenWidth*0.3)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width:10.0),
                Container(child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: "Email"
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
            RaisedButton(
              child: Text("Sign Up"),
              onPressed: () async {
                try {
                  // print(_email.text.replaceFirst(".", "dot"));
                  // print(_password.text);
                  var userId = await auth.signUp(_email.text, _password.text);
                  print(userId);

                  FirebaseDatabase.instance.reference().child(_email.text.replaceFirst(".", "dot")).child('info').
                    set({
                      'firstName': _firstName.text,
                      'lastName': _lastName.text,
                      'phone': _phoneNumber.text,
                    }).then((onValue) {
                      print("added");
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => HomePage(auth))
                      );
                    });
                  // Firestore.instance.collection('users').add(
                  //   {
                  //     "email": _email.text,
                  //     "firstName": _firstName.text,
                  //     "lastName": _lastName.text,
                  //     "phoneNum": _phoneNumber.text,
                  //   }
                  // ).then((onValue){
                  //   print("added");
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (BuildContext context) => HomePage(userId))
                  //   );
                  // });
                } catch(e) {
                  print(e.message);
                  
                }
              },)
          ],),),
    );
  }
}