// import 'dart:html';

import 'package:blog_post_app/screens/login.dart';
import 'package:blog_post_app/screens/signup.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purple, Colors.yellow],
                begin: const FractionalOffset(0.0, 3.0),
                end: const FractionalOffset(0.0, 2.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "[Post-A-Gram]",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 45,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Create Your Memories ",
              textAlign: TextAlign.center,
              style: kHeaderTextStyle,
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 35,
                      ),
                      Text(
                        "SignUp With Email",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      )
                    ]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Wrap(
              spacing: 7,
              children: [
                Text(
                  "Already have an account?",
                  style: kDefaultTextStyle,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("Login",
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
