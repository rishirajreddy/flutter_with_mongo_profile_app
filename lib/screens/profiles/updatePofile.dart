import 'dart:io';

import 'package:blog_post_app/constants/constants.dart';
import 'package:blog_post_app/models/profilemodel.dart';
import 'package:blog_post_app/screens/homePage.dart';
import 'package:blog_post_app/screens/stateScreens/createprofile.dart';
import 'package:blog_post_app/screens/stateScreens/mainprofile.dart';
import 'package:flutter/material.dart';
import 'package:blog_post_app/NetworkHandler.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _globalKey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _professionController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();

  bool validate = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final NetworkHandler networkHandler = new NetworkHandler();
  bool circular = true;
  PickedFile? _imageFile = null;
  final ImagePicker _picker = ImagePicker();
  late File _image;
  ProfileModel profilemodel = ProfileModel('', '', '', '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    // _nameController = TextEditingController(text: profilemodel.name);
  }

  void fetchData() async {
    var response = await networkHandler.get("/api/v1/profile/getProfile");
    setState(() {
      profilemodel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
    _nameController.text = profilemodel.name;
    _usernameController.text = profilemodel.username;
    _professionController.text = profilemodel.profession;
    _bioController.text = profilemodel.bio;
  }

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
              child: circular
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 6,
                    ))
                  : ListView(
                      children: [
                        imageProfile(),
                        textfield(
                          // controller1.text,
                          "Username can't be changed",
                          Icon(
                            Icons.supervised_user_circle,
                            color: Colors.white,
                          ),
                          _usernameController,
                          1,
                          true,
                        ),
                        textfield(
                            // profilemodel.name,
                            "Enter name",
                            Icon(Icons.person, color: Colors.white),
                            _nameController,
                            1,
                            false),
                        textfield(
                            // profilemodel.profession,
                            "Enter your profession",
                            Icon(Icons.work, color: Colors.white),
                            _professionController,
                            1,
                            false),
                        textfield(
                            // profilemodel.bio,
                            "Enter your bio",
                            Icon(Icons.info, color: Colors.white),
                            _bioController,
                            4,
                            false),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: MaterialButton(
                            color: Colors.purple,
                            hoverColor: Colors.purpleAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                                var response = await networkHandler.patch(
                                    "/api/v1/profile/updateProfile", data);
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
                                final snackBar = SnackBar(
                                    content:
                                        Text('Profile Updated Successfully!'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainProfile()));
                                print("Validated");
                              } else {
                                setState(() {
                                  circular = false;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: circular
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Update",
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

  Widget textfield(String helper, Icon icon, TextEditingController controller,
      int lines, bool readOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        // height: 80,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              validate = false;
              circular = false;
              return "This Field can't be left empty";
            } else {
              validate = true;
              // circular = false;
            }
          },
          readOnly: readOnly,
          controller: controller,
          maxLines: lines,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: icon,
            helperText: helper,
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
                ? NetworkHandler().getImage(profilemodel.username)
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
}
