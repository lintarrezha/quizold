import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizold/quizpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> images = [
    "images/majapahit.png",
    "images/prasejarah.png",
    "images/perangdunia2.png",
    "images/proklamasikemerdekaan.png",
    "images/penjajah.png",
  ];

  List<String> des = [
    "Sebuah kerajaan maritim dan perdagangan yang berpengaruh di Nusantara pada abad ke-14 dan 15. Majapahit dikenal karena kejayaan ekonomi, militer, dan budayanya.",
    "Periode sejarah sebelum penulisan sejarah, di mana manusia hidup sebagai pemburu-pengumpul, menggunakan alat batu, dan mengembangkan kepercayaan terhadap alam.",
    "Mengulas peristiwa global dari tahun 1939 hingga 1945, penyebab, peran pemimpin, dampak teknologi perang, dan tragedi Holocaust.",
    "Fokus pada peristiwa bersejarah pada 17 Agustus 1945, termasuk tokoh-tokoh, teks proklamasi, peran Bung Tomo, dan reaksi internasional.",
    "Membahas masa penjajahan di Indonesia, termasuk kedatangan bangsa Eropa, dampaknya, perlawanan nasional, dan akhirnya, proses dekolonisasi.",
  ];

  Widget customcard(String langname, String image, String des) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GetJson(langname),
          ));
        },
        child: Material(
          color: Colors.grey,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      // changing from 200 to 150 as to look better
                      height: 150.0,
                      width: 150.0,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            image,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    langname,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Quando",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    des,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: "Alike"),
                    maxLines: 5,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Quizold",
          style: TextStyle(
            fontFamily: "Quando",
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          customcard("Kerajaan Majapahit", images[0], des[0]),
          customcard("Masa Prasejarah", images[1], des[1]),
          customcard("Perang Dunia 2", images[2], des[2]),
          customcard("Proklamasi Kemerdekaan", images[3], des[3]),
          customcard("Penjajahan di Indonesia", images[4], des[4]),
        ],
      ),
    );
  }
}
