// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:blog_post_app/constants/constants.dart';
import 'package:blog_post_app/screens/homePage.dart';
import 'package:blog_post_app/screens/stateScreens/mainprofile.dart';
import 'package:flutter/material.dart';
import 'package:blog_post_app/NetworkHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _globalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  final _bioController = TextEditingController();
  final NetworkHandler networkHandler = new NetworkHandler();
  bool circular = false;

  // PickedFile _imageFile = new PickedFile();
  PickedFile? _imageFile = null;
  final ImagePicker _picker = ImagePicker();
  late File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.yellow],
                  begin: const FractionalOffset(0.0, 3.0),
                  end: const FractionalOffset(0.0, 2.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.repeated)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Form(
              key: _globalKey,
              child: ListView(
                children: [
                  imageProfile(),
                  SizedBox(
                    height: 20,
                  ),
                  textfield(
                      "Name",
                      "Enter name",
                      Icon(Icons.person, color: Colors.white),
                      _nameController,
                      1),
                  textfield(
                      "Profession",
                      "Enter your profession",
                      Icon(Icons.work, color: Colors.white),
                      _professionController,
                      1),
                  textfield(
                      "About",
                      "Enter your bio",
                      Icon(Icons.note_sharp, color: Colors.white),
                      _bioController,
                      4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: MaterialButton(
                      color: Colors.green,
                      hoverColor: Colors.purpleAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      onPressed: () async {
                        setState(() {
                          circular = true;
                        });
                        if (_globalKey.currentState!.validate()) {
                          Map<String, String> data = {
                            "name": _nameController.text,
                            "profession": _professionController.text,
                            "bio": _bioController.text
                          };
                          var response = await networkHandler.post1(
                              "/api/v1/profile/addProfile", data);

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            if (_imageFile != null) {
                              var imageResponse =
                                  await networkHandler.patchImage(
                                      "/api/v1/profile/addImage",
                                      _imageFile!.path);
                              if (imageResponse.statusCode == 200) {
                                setState(() {
                                  circular = false;
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              } else {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Network Connection Error! Please try again later!!'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          }
                          setState(() {
                            circular = false;
                          });
                          // Navigator.pop(context);
                          print("Validated");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: circular
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Submit",
                                style: kHeaderTextStyle,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  _openCamera(context);
                },
                label: Text("Camera"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  _openGallery(context);
                },
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: _imageFile == null
                ? AssetImage('assets/images/profile.png')
                : FileImage(
                    File(_imageFile!.path),
                  ) as ImageProvider,
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: ((builder) => bottomSheet()));
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.purple,
                  size: 30,
                ),
              ))
        ],
      ),
    );
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  Widget textfield(String label, String helper, Icon icon,
      TextEditingController controller, int lines) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        height: 80,
        child: TextFormField(
          controller: controller,
          maxLines: lines,
          cursorColor: Colors.white,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field cannot be empty";
            }
          },
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: icon,
              label: Text(
                label,
                style: TextStyle(
                  color: Colors.grey[50],
                ),
              ),
              helperText: helper,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
        ),
      ),
    );
  }
}
