import 'package:covid_help/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;

  Result(this.resultScore, this.resetHandler);

  //Remark Logic
  String get resultPhrase {
    String resultText;
    if (resultScore >= 12) {
      resultText = 'You are awesome and your mode looks good!';
      print(resultScore);
    } else if (resultScore < 12 && resultScore >= 8) {
      resultText = "Don\'t take tension and you will be ok";
      print(resultScore);
    } else if (resultScore < 8) {
      resultText = 'You need to work on this you are fine';
    } else {
      resultText = 'This is a poor score! you need to work hard';
      print(resultScore);
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseDatabase fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          Text(
            'Score ' '$resultScore',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          FlatButton(
            child: Text(
              'Take me Back',
            ), //Text
            textColor: Colors.blue,
            onPressed: () {
              DateTime now = new DateTime.now();
              DateTime date = new DateTime(now.year, now.month, now.day);
              ref.child("Score data").child("Score").set((resultScore).toString());
              ref.child("Score data").child("Date").set(date.toString());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          ), //FlatButton
        ], //<Widget>[]
      ), //Column
    ); //Center
  }
}