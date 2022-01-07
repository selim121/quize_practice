import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quize());

class Quize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: QuizPage(),
        )),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}
String animation = 'idle';
class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];

  Icon iconCorrect = Icon(Icons.check, color: Colors.green);
  Icon iconWrong = Icon(Icons.close, color: Colors.red);

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();
    setState(() {
      if (correctAnswer == true) {
        scoreKeeper.add(iconCorrect);
        animation = 'success';
      } else {
        scoreKeeper.add(iconWrong);
        animation = 'fail';
      }
      quizBrain.nextQuestion();
    });

    if (quizBrain.isFinished()) {
      int right = scoreKeeper.where((e) => e == iconCorrect).length - 1;
      int wrong = scoreKeeper.where((e) => e == iconWrong).length;
      Alert(
        context: context,
        type: AlertType.success,
        title: "Your Result",
        desc: 'Right = $right and Wrong = $wrong',
        buttons: [
          DialogButton(
            child: Text(
              'Start again!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 130,
          )
        ],
      ).show();
      quizBrain.reset();
      scoreKeeper = [];
      animation = 'idle';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)))),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 3,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)))),
              child: Text(
                'False',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 3,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: scoreKeeper,
        ),
      ],
    );
  }
}
