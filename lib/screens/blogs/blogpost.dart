import 'dart:convert';
import 'dart:io';

import 'package:blog_post_app/NetworkHandler.dart';
import 'package:blog_post_app/constants/constants.dart';
import 'package:blog_post_app/customwidgets/overlaycard.dart';
import 'package:blog_post_app/models/postmodel.dart';
import 'package:blog_post_app/models/profilemodel.dart';
import 'package:blog_post_app/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BlogPost extends StatefulWidget {
  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _bodyController = new TextEditingController();
  bool circular = false;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile = null;
  ProfileModel profileModel = new ProfileModel("", "", "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(gradient: kGradientBackground),
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          size: 35,
                          color: Colors.purple,
                        ))),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) =>
                            OverlayCard(_imageFile!, _titleController.text)));
                  },
                  child: Text(
                    "Preview",
                    style: kDefaultTextStyle,
                  ),
                )
              ]),
              SizedBox(
                height: 40,
              ),
              imageProfile(),
              textField("Post Title", "Enter post title", 1, _titleController),
              textField("Post Body", "Enter post body", 4, _bodyController),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    if (_imageFile != null &&
                        _globalKey.currentState!.validate()) {
                      PostModel postModel = PostModel(
                          "", _titleController.text, _bodyController.text,"");
                      var response = await networkHandler.post1(
                          "/api/v1/posts/add", postModel.toJson());
                      print(response.body);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        if (_imageFile != null) {
                          String id = json.decode(response.body)["data"];
                          print(id);
                          var imageResponse = await networkHandler.patchImage(
                              "/api/v1/posts/coverImage/$id", _imageFile!.path);
                          if (imageResponse.statusCode == 200) {
                            setState(() {
                              circular = false;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          }
                          print(response.statusCode);
                        }
                      }
                    } else {
                      final snackBar = SnackBar(
                          content: Text(
                              'Network Connection Error! Please try again later!!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Post",
                              style: kHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/images/profile.png")
                : FileImage(
                    File(_imageFile!.path),
                  ) as ImageProvider,
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  _galleryImage(context);
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

  void _galleryImage(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
    // Navigator.pop(context);
  }

  Widget textField(String title, String helperText, int lines,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        // height: 80,
        child: TextFormField(
          cursorColor: Colors.white,
          maxLines: lines,
          validator: (value) {
            if (value!.isEmpty) {
              // validate = false;
              circular = false;
              return "This Field can't be left empty";
            } else {
              // validate = true;
              return null;
            }
          },
          // readOnly: readOnly,
          controller: controller,
          // maxLines: lines,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(title,
                  style: TextStyle(fontSize: 20, color: Colors.white60)),
              helperText: helperText,
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
