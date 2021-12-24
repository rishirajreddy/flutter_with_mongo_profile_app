import 'package:blog_post_app/NetworkHandler.dart';
import 'package:blog_post_app/models/profilemodel.dart';
import 'package:blog_post_app/screens/blogs/blogpost.dart';
import 'package:blog_post_app/screens/stateScreens/home.dart';
import 'package:blog_post_app/screens/stateScreens/profile.dart';
import 'package:blog_post_app/screens/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = [Home(), ProfilePage()];
  List<String> titles = ['Post-A-Gram', 'Profile Page'];
  NetworkHandler networkHandler = NetworkHandler();
  final storage = FlutterSecureStorage();
  String username = "";
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  void checkProfile() async {
    var response = await networkHandler.get("/api/v1/profile/checkProfile");

    username = response['username'];
    if (response['status'] == true) {
      setState(() {
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response['username']),
        );
      });
    } else {
      setState(() {
        profilePhoto = Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      });
    }
    print(response);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "@$username",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text("All POsts"),
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.logout, color: Colors.black),
              onTap: logout,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(titles[currentPage]),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                size: 30,
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BlogPost()));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.yellow],
                  begin: const FractionalOffset(0.0, 3.0),
                  end: const FractionalOffset(0.0, 2.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.repeated)),
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        currentPage = 0;
                      });
                    },
                    icon: Icon(
                      Icons.home,
                      size: 35,
                      color: currentPage == 0 ? Colors.white : Colors.grey,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        currentPage = 1;
                      });
                    },
                    icon: Icon(Icons.person,
                        size: 35,
                        color: currentPage == 1 ? Colors.white : Colors.grey))
              ],
            ),
          ),
        ),
      ),
      body: pages[currentPage],
    );
  }

  void logout() async {
    // storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false);
  }
}
