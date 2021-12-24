import 'package:blog_post_app/NetworkHandler.dart';
import 'package:blog_post_app/constants/constants.dart';
import 'package:blog_post_app/screens/stateScreens/createprofile.dart';
import 'package:blog_post_app/screens/stateScreens/mainprofile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  NetworkHandler networkHandler = NetworkHandler();
  Widget page = Center(
    child: CircularProgressIndicator(
      strokeWidth: 5,
    ),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/api/v1/profile/checkProfile");

    if (response == true) {
      setState(() {
        page = MainProfile();
      });
    } else {
      setState(() {
        page = addprofileButton();
      });
    }
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: page,
      ),
    );
  }

  // Widget showProfile() {
  //   return Center(child: Text("Profile Data is Available"));
  // }

  Widget addprofileButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tap on this button to add your profile",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateProfile()));
            },
            child: Container(
              height: 80,
              width: 150,
              child: Center(
                child: Text(
                  "Add Profile",
                  style: kDefaultTextStyle,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      colors: [Colors.purple, Colors.yellow],
                      begin: const FractionalOffset(0.0, 3.0),
                      end: const FractionalOffset(0.0, 2.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.repeated)),
            ),
          )
        ],
      ),
    );
  }
}
