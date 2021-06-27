import 'package:covid_help/quiz.dart';
import 'package:covid_help/result.dart';
import 'package:flutter/material.dart';

class Survey extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SurveyState();
  }
}

class _SurveyState extends State<Survey> {
  final _questions = const [
    {
      'questionText': 'Q1. How are you feeling? (out of 5)',
      'answers': [
        {'text': '1', 'score': 1},
        {'text': '2', 'score': 2},
        {'text': '3', 'score': 3},
        {'text': '4', 'score': 4},
        {'text': '5', 'score': 5},
      ],
    },
    {
      'questionText': 'Q2. Are you up for a fun activity today',
      'answers': [
        {'text': '1', 'score': 1},
        {'text': '2', 'score': 2},
        {'text': '3', 'score': 3},
        {'text': '4', 'score': 4},
        {'text': '5', 'score': 5},
      ],
    },
    {
      'questionText': 'Q3. Is everyone fine in your family?',
      'answers': [
        {'text': '1', 'score': 1},
        {'text': '2', 'score': 2},
        {'text': '3', 'score': 3},
        {'text': '4', 'score': 4},
        {'text': '5', 'score': 5},
      ],
    },
    {
      'questionText': ' Q4. How is your work from home?',
      'answers': [
        {'text': '1', 'score': 1},
        {'text': '2', 'score': 2},
        {'text': '3', 'score': 3},
        {'text': '4', 'score': 4},
        {'text': '5', 'score': 5},
      ],
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      print('We have more questions!');
    } else {
      print('No more questions!');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Answer some questions'),
        ),
    body: WillPopScope( //WillPopScope will replace the default
    //"Mobile Back Button" and "Appbar Back button" action
    onWillPop: (){
    //on Back button press, you can use WillPopScope for another purpose also.
    Navigator.pop(context, "Backbutton data"); //return data along with pop
    return new Future(() => false); //onWillPop is Future<bool> so return false
    },
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: _questionIndex < _questions.length
              ? Quiz(
            answerQuestion: _answerQuestion,
            questionIndex: _questionIndex,
            questions: _questions,
          ) //Quiz
              : Result(_totalScore, _resetQuiz),
        ), //Paddi
    ),// ng
      ), //Scaffold
      debugShowCheckedModeBanner: false,
    ); //MaterialApp
  }
}