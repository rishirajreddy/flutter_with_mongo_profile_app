// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('ABCD'),
//           ),
//           body: SafeArea(
//             child: Column(children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       NewContainer(
//                         colour: Colors.red,
//                         textcontainercolor: Colors.yellow,
//                         title: Text(
//                           "SPORTS",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: Colors.blue, fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                       NewContainer(
//                         colour: Colors.green,
//                         textcontainercolor: Colors.blue,
//                         title: Text(
//                           "HISTORY",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                       NewContainer(
//                         colour: Colors.yellow,
//                         textcontainercolor: Colors.blue,
//                         title: Text(
//                           "SCIENCE",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                       NewContainer(
//                         colour: Colors.blue,
//                         textcontainercolor: Colors.blue,
//                         title: Text(
//                           "MOVIES",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                       NewContainer(
//                         colour: Colors.pink,
//                         textcontainercolor: Colors.blue,
//                         title: Text(
//                           "SPORTS",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     NewContainer2(
//                       colour: Colors.red,
//                       textcontainercolor: Colors.yellow,
//                       title: Text(
//                         "SPORTS",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.blue, fontWeight: FontWeight.w900),
//                       ),
//                     ),
//                     NewContainer2(
//                       colour: Colors.green,
//                       textcontainercolor: Colors.blue,
//                       title: Text(
//                         "HISTORY",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w900),
//                       ),
//                     ),
//                     NewContainer2(
//                       colour: Colors.yellow,
//                       textcontainercolor: Colors.blue,
//                       title: Text(
//                         "SCIENCE",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w900),
//                       ),
//                     ),
//                     NewContainer2(
//                       colour: Colors.blue,
//                       textcontainercolor: Colors.blue,
//                       title: Text(
//                         "MOVIES",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w900),
//                       ),
//                     ),
//                     NewContainer2(
//                       colour: Colors.pink,
//                       textcontainercolor: Colors.blue,
//                       title: Text(
//                         "SPORTS",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w900),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]),
//           )),
//     );
//   }
// }

// class NewContainer extends StatelessWidget {
//   NewContainer(
//       {required this.colour,
//       required this.title,
//       required this.textcontainercolor});
//   final Color colour;
//   final Text title;
//   final Color textcontainercolor;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(25),
//         child: Stack(alignment: Alignment.bottomCenter, children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             decoration: BoxDecoration(
//               // borderRadius: BorderRadius.all(Radius.circular(30)),
//               image: DecorationImage(
//                   image: AssetImage("assets/images/engineer-1.png")),
//               color: colour,
//             ),
//             // child: title,
//             height: 150,
//             width: 100,
//           ),
//           Container(
//               padding: EdgeInsets.symmetric(vertical: 6),
//               color: textcontainercolor,
//               width: 100,
//               height: 30,
//               child: title),
//         ]),
//       ),
//     );
//   }
// }

// class NewContainer2 extends StatelessWidget {
//   NewContainer2(
//       {required this.colour,
//       required this.title,
//       required this.textcontainercolor});
//   final Color colour;
//   final Text title;
//   final Color textcontainercolor;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(25),
//         child: Stack(alignment: Alignment.centerLeft, children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             decoration: BoxDecoration(
//               // borderRadius: BorderRadius.all(Radius.circular(30)),
//               image: DecorationImage(
//                   image: AssetImage("assets/images/engineer-1.png")),
//               color: colour,
//             ),
//             // child: title,
//             height: 180,
//             width: 130,
//           ),
//           Positioned.fill(
//               top: 90,
//               left: 10,
//               child: LayoutBuilder(builder: (context, constraint) {
//                 double maxWidth = constraint.biggest.width;
//                 double fontSize = 20.0;
//                 return new Text(
//                   "WWF Quiz",
//                   maxLines: 2,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: fontSize),
//                 );
//               })),
//           Positioned.fill(
//             top: 70,
//             child: Divider(
//               height: 20,
//               thickness: 5,
//               indent: 10,
//               endIndent: 10,
//               color: Colors.yellowAccent,
//             ),
//           ),
//           Positioned.fill(
//               top: 140,
//               left: 10,
//               child: Text("8.9/10",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20))),
//         ]),
//       ),
//     );
//   }
// }
