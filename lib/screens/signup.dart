import 'dart:convert';

import 'package:blog_post_app/NetworkHandler.dart';
import 'package:blog_post_app/screens/homePage.dart';
import 'package:blog_post_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool visibile = true;
  final _globalKey = GlobalKey<FormState>();
  final _usernamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  String errorText = "";
  bool validate = false;
  bool circular = false;
  NetworkHandler networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.yellow],
                  begin: const FractionalOffset(0.0, 3.0),
                  end: const FractionalOffset(0.0, 2.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.repeated)),
          child: Center(
            child: Form(
              key: _globalKey,
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "SignUp With Email",
                    textAlign: TextAlign.center,
                    style: kHeaderTextStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  usernameformField("Username", ""),
                  emailformField(
                    "Email",
                    "",
                  ),
                  passwordformField(
                      "Password", "Password must be more than 7 characters"),
                  MaterialButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      setState(() {
                        circular = true;
                      });
                      await checkUser();
                      if (_globalKey.currentState!.validate() && validate) {
                        Map<String, String> data = {
                          "username": _usernamecontroller.text,
                          "email": _emailcontroller.text,
                          "password": _passwordcontroller.text
                        };
                        print(data);
                        var response = await networkHandler.post(
                            "/api/v1/users/register", data);
                        Map<String, dynamic> output =
                            json.decode(response.body);
                        print(output['data']['user']['token']);
                        await storage.write(
                            key: "token",
                            value: output['data']['user']['token']);
                        setState(() {
                          validate = true;
                          circular = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      } else {
                        setState(() {
                          circular = false;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: circular
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Submit",
                              textAlign: TextAlign.center,
                              style: kDefaultTextStyle,
                            ),
                    ),
                  ),
                  Wrap(
                    children: [
                      Text(
                        "Already have an account? ",
                        style: kDefaultTextStyle,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (_usernamecontroller.text.length == 0) {
      // circular = false;
      validate = false;
      errorText = 'Username can\'t be empty';
    } else {
      var response = await networkHandler
          .get("/api/v1/users/checkUsername/${_usernamecontroller.text}");
      if (response[13] == 't') {
        setState(() {
          // circular = false;
          validate = false;
          errorText = "Username already taken";
        });
      } else {
        setState(() {
          validate = true;
        });
      }

      print("response: ${response[13]}");
    }
  }

  Widget usernameformField(String label, String helperText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: kDefaultTextStyle,
            ),
            TextFormField(
              controller: _usernamecontroller,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Username can't be empty";
                }
              },
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  helperText: helperText,
                  errorText: validate ? null : errorText,
                  helperStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2))),
            ),
          ],
        ),
      ),
    );
  }

  Widget emailformField(String label, String helperText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: kDefaultTextStyle,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) return "Email field can't be empty";
                if (!value.contains('@')) return "Invalid email";
              },
              controller: _emailcontroller,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  // errorText: _errorText,
                  helperText: helperText,
                  helperStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2))),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordformField(String label, String helperText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: kDefaultTextStyle,
            ),
            TextFormField(
              controller: _passwordcontroller,
              obscureText: visibile,
              validator: (value) {
                if (value!.isEmpty) return "Password field can't be empty";
                if (value.length <= 7)
                  return "Password must be more than 7 characters";
              },
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visibile = !visibile;
                        });
                      },
                      icon: Icon(
                        visibile ? Icons.visibility_off : Icons.remove_red_eye,
                        color: Colors.white,
                      )),
                  helperText: helperText,
                  helperStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2))),
            ),
          ],
        ),
      ),
    );
  }
}
