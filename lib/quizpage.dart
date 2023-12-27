import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizold/home.dart';
import 'package:quizold/resultpage.dart';

class GetJson extends StatelessWidget {
  final String langName;

  GetJson(this.langName);

  late String assetToLoad;

  void setAsset() {
    if (langName == "Kerajaan Majapahit") {
      assetToLoad = "assets/majapahit.json";
    } else if (langName == "Masa Prasejarah") {
      assetToLoad = "assets/masaprasejarah.json";
    } else if (langName == "Perang Dunia 2") {
      assetToLoad = "assets/perangdunia2.json";
    } else if (langName == "Proklamasi Kemerdekaan") {
      assetToLoad = "assets/proklamasikemerdekaan.json";
    } else {
      assetToLoad = "assets/penjajahanindonesia.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setAsset();
    return FutureBuilder<String>(
      future:
          DefaultAssetBundle.of(context).loadString(assetToLoad, cache: false),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List mydata = json.decode(snapshot.data!);
          return QuizPage(mydata: mydata);
        } else {
          return Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        }
      },
    );
  }
}

class QuizPage extends StatefulWidget {
  final List mydata;

  QuizPage({Key? key, required this.mydata}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState(mydata);
}

class _QuizPageState extends State<QuizPage> {
  final List mydata;
  late Color colortoshow;
  late Color right;
  late Color wrong;
  late int marks;
  late int i;
  late bool disableAnswer;
  late int j;
  late int timer;
  late String showtimer;
  late List<int> randomArray;
  late Map<String, Color> btnColor;
  late bool cancelTimer;

  _QuizPageState(this.mydata);

  @override
  void initState() {
    super.initState();
    right = Colors.green;
    wrong = Colors.red;
    marks = 0;
    i = 1;
    j = 1;
    timer = 20;
    showtimer = "20";
    randomArray = [];
    btnColor = {
      "a": Colors.white,
      "b": Colors.white,
      "c": Colors.white,
      "d": Colors.white,
    };
    disableAnswer = false;
    cancelTimer = false;
    startTimer();
    genRandomArray();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
      /*
      print("Pertanyaan: ${mydata[0][i.toString()]}");
      print("Opsi: ${mydata[1][i.toString()]}");
      */
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextQuestion();
        } else if (cancelTimer) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  void genRandomArray() {
    var distinctIds = <int>[];
    var rand = Random();
    for (int i = 0;;) {
      distinctIds.add(rand.nextInt(20));
      randomArray = distinctIds.toSet().toList();
      if (randomArray.length < 20) {
        continue;
      } else {
        break;
      }
    }
    print(randomArray);
  }

  void nextQuestion() {
    cancelTimer = false;
    timer = 20;
    setState(() {
      if (j < 10) {
        i = randomArray[j];
        j++;
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultPage(marks: marks),
          ),
        );
      }
      // Pemeriksaan keberadaan data sebelum mengakses
      if (mydata.length > 0 &&
          mydata[0][i.toString()] != null &&
          mydata[1][i.toString()] != null) {
        btnColor["a"] = Colors.white;
        btnColor["b"] = Colors.white;
        btnColor["c"] = Colors.white;
        btnColor["d"] = Colors.white;
        disableAnswer = false;
      } else {
        // Langsung ke pertanyaan berikutnya jika data tidak lengkap
        nextQuestion();
        return;
      }
    });
    startTimer();
  }

  void checkAnswer(String k) {
    if (mydata?[2]?[i.toString()] == mydata?[1]?[i.toString()]?[k]) {
      marks = marks + 10;
      colortoshow = right;
    } else {
      colortoshow = wrong;
    }
    setState(() {
      btnColor[k] = colortoshow;
      cancelTimer = true;
      disableAnswer = true;
    });
    Timer(Duration(seconds: 2), nextQuestion);
  }

  Widget choiceButton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkAnswer(k),
        child: Text(
          mydata?[1]?[i.toString()]?[k] ?? "", // Pemeriksaan null
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btnColor[k],
        splashColor: Colors.white,
        highlightColor: Colors.white,
        minWidth: 200.0,
        height: 45.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
    );
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Quizstar"),
                content: Text("You Can't Go Back At This Stage."),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Perhatikan ini
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text('Ok'),
                  )
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  mydata?[0]?[i.toString()] ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: AbsorbPointer(
                absorbing: disableAnswer,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      choiceButton('a'),
                      choiceButton('b'),
                      choiceButton('c'),
                      choiceButton('d'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
