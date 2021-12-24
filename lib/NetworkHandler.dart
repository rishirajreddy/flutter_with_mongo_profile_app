import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = "https://blogpost-node-mongo.herokuapp.com";
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

//Getting data
  Future get(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    var response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }

    log.i(response.body);
    log.i(response.statusCode);
  }

//Login and signup handler
  Future<dynamic> post(String url, Map<String, String> body) async {
    url = formater(url);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return response;
    }
    log.d(response.body);
    log.d(response.statusCode);
  }

//Posting profile and blog handler
  Future<dynamic> post1(String url, var body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);

    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return response;
    }
    log.d(response.body);
    log.d(response.statusCode);
  }

//Updating profile handler
  Future<dynamic> patch(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);

    var response = await http.patch(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return response;
    }
    log.d(response.body);
    log.d(response.statusCode);
  }

//Login handler
  Future<http.Response> login(String url, Map<String, String> body) async {
    url = formater(url);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    return response;
  }

  Future<http.Response> postProfileData(
      String url, Map<String, String> body) async {
    url = formater(url);
    String? token = await storage.read(key: "token");

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(body));
    return response;
  }

  //Updating image in profile
  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formater(url);
    String? token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    });
    var response = request.send();
    return response;
  }

  String formater(String url) {
    return baseurl + url;
  }

  NetworkImage getImage(String imagename) {
    String url = formater("/uploads//$imagename.jpg");
    return NetworkImage(url);
  }
}
