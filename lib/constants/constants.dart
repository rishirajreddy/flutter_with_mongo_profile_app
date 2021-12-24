import 'package:flutter/material.dart';

const kHeaderTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: Colors.white);

const kDefaultTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: Colors.white);

const kDefaultBlackTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: Colors.black);

const kHeaderBlackTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: Colors.black);

const kGradientBackground = LinearGradient(
    colors: [Colors.purple, Colors.yellow],
    begin: const FractionalOffset(0.0, 3.0),
    end: const FractionalOffset(0.0, 2.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.repeated);
