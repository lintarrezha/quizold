import 'package:flutter/material.dart';
import 'package:quizold/home.dart';

class ResultPage extends StatefulWidget {
  final int marks;

  ResultPage({Key? key, required this.marks}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState(marks);
}

class _ResultPageState extends State<ResultPage> {
  static const List<String> images = [
    "images/success.png",
    "images/good.png",
    "images/bad.png",
  ];

  static const String successMessage = "You Did Very Well..\nYou Scored ";
  static const String goodMessage = "You Can Do Better..\nYou Scored ";
  static const String badMessage = "You Should Try Hard..\nYou Scored ";

  late String message;
  late String image;

  _ResultPageState(int marks) {
    if (marks < 40) {
      image = images[2];
      message = badMessage + "$marks";
    } else if (marks < 60) {
      image = images[1];
      message = goodMessage + "$marks";
    } else {
      image = images[0];
      message = successMessage + "$marks";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Material(
              elevation: 10.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage(
                              image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      child: Center(
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Quando",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  // Menggunakan OutlinedButton
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    side: BorderSide(width: 3.0, color: Colors.indigo),
                    splashFactory: InkRipple.splashFactory,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
