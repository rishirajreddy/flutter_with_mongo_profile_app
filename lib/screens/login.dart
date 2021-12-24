import 'dart:convert';

import 'package:blog_post_app/NetworkHandler.dart';
import 'package:blog_post_app/screens/homePage.dart';
import 'package:blog_post_app/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:blog_post_app/constants/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visibile = true;
  final _globalKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernamecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  String errorText = "";
  bool validate = false;
  bool circular = false;
  NetworkHandler networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                Text(
                  "Let's Login",
                  textAlign: TextAlign.center,
                  style: kHeaderTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                // usernameformField("Username", ""),
                usernameformField("Username", ""),

                passwordformField(
                    "Password", "Password must be more than 7 characters"),

                MaterialButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () async {
                    checkUser();
                    setState(() {
                      circular = true;
                    });
                    Map<String, String> data = {
                      "username": _usernamecontroller.text,
                      "password": _passwordcontroller.text
                    };
                    print(data);
                    var response =
                        await networkHandler.login("/api/v1/users/login", data);

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      print(output['token']);
                      await storage.write(key: "token", value: output['token']);
                      setState(() {
                        validate = true;
                        circular = false;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                    } else {
                      setState(() {
                        circular = false;
                      });
                      _displaySnackBar(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: circular
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: kDefaultTextStyle,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
                  child: Divider(
                    height: 30,
                    color: Colors.white54,
                    thickness: 3,
                  ),
                ),
                Wrap(
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: kDefaultTextStyle,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "SignUp",
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
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Email or Password is Invalid'));
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  // Widget usernameformField(String label, String helperText) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
  //     child: Container(
  //       child: Wrap(
  //         alignment: WrapAlignment.center,
  //         children: [
  //           Text(
  //             label,
  //             textAlign: TextAlign.center,
  //             style: kDefaultTextStyle,
  //           ),
  //           TextFormField(
  //             controller: _usernamecontroller,
  //             validator: (value) {
  //               if (value!.isEmpty) {
  //                 return "Username can't be empty";
  //               }
  //             },
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold),
  //             decoration: InputDecoration(
  //                 helperText: helperText,
  //                 errorText: validate ? null : errorText,
  //                 helperStyle: TextStyle(fontSize: 15, color: Colors.grey),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.white, width: 3),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.white, width: 2))),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  checkUser() {
    var username = _usernamecontroller.text;
    var password = _passwordcontroller.text;

    if (username.isEmpty || password.isEmpty) {
      validate = false;
      errorText = "This field is required";
    } else {
      errorText = "";
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
              cursorColor: Colors.white,
              controller: _usernamecontroller,
              validator: (value) {
                if (value!.isEmpty) return "Username field can't be empty";
              },
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                helperText: helperText,
                errorText: validate ? null : errorText,
                helperStyle: TextStyle(fontSize: 15, color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
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
              cursorColor: Colors.white,
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
                  errorText: validate ? null : errorText,
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
