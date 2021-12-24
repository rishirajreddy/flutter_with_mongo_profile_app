import 'package:blog_post_app/NetworkHandler.dart';
import 'package:blog_post_app/customwidgets/blogcard.dart';
import 'package:blog_post_app/models/postmodel.dart';
import 'package:blog_post_app/models/supermodel.dart';
import 'package:blog_post_app/screens/blogs/blog.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  Blogs({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel([]);
  List<PostModel> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
            children: data
                .map((item) => Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => Blog(
                                          addBlogModel: item,
                                          networkHandler: networkHandler,
                                        )));
                          },
                          child: BlogCard(
                            item,
                            networkHandler,
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ))
                .toList(),
          )
        : Center(
            child: Text("We don't have any Blog Yet"),
          );
  }
}