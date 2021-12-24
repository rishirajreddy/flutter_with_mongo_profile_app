import 'package:blog_post_app/screens/homePage.dart';
import 'package:blog_post_app/screens/stateScreens/createprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/welcomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = WelcomePage();
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }

  void checklogin() async {
    String? token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    } else {
      setState(() {
        currentPage = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
