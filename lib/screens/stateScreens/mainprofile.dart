import 'package:blog_post_app/NetworkHandler.dart';
import 'package:blog_post_app/constants/constants.dart';
import 'package:blog_post_app/models/profilemodel.dart';
import 'package:blog_post_app/screens/blogs/showblogs.dart';
import 'package:blog_post_app/screens/homePage.dart';
import 'package:blog_post_app/screens/profiles/demo.dart';
import 'package:blog_post_app/screens/profiles/updatePofile.dart';
import 'package:blog_post_app/screens/stateScreens/createprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profilemodel = ProfileModel('', '', '', '');
  bool circular = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/api/v1/profile/getProfile");
    setState(() {
      profilemodel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
    print(profilemodel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: circular
                ? CircularProgressIndicator(
                    // color: Colors.white,
                    strokeWidth: 6.0,
                  )
                : ListView(
                    children: [
                      IconButton(
                          alignment: Alignment.topLeft,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          icon: Icon(Icons.arrow_back)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              NetworkHandler().getImage(profilemodel.username),
                        ),
                      ),
                      headers(),
                      otherDetails("Profession", profilemodel.profession),
                      otherDetails("Bio", profilemodel.bio),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 110.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateProfile()));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                gradient: kGradientBackground,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(
                              child: Wrap(
                                  textDirection: TextDirection.rtl,
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.mode_edit_outline,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Edit Profile",
                                      style: kDefaultTextStyle,
                                    ),
                                    Blogs(url: "/api/v1/posts/getPosts")
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ], //data.username
                  ),
          ),
        ),
      ),
    );
  }

  Widget headers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Center(
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundImage: NetworkHandler().getImage(profileModel.username),
          //   ),
          // ),
          Text(
            profilemodel.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(profilemodel.name)
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
