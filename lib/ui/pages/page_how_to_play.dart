import 'package:flutter/material.dart';
import 'package:Reversi/resources/constants.dart';

class HowToPlay extends StatelessWidget {
  final String title;

  HowToPlay({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _getText(Res.target_game_title, 24),
              _getText(Res.target_game_text, 18),
              _getText(Res.game_step_title, 24),
              _getText(Res.game_step_text, 18),
              _getText(Res.end_game_title, 24),
              _getText(Res.end_game_text, 18),
            ],
          ),
        ),
      ),
    );
  }

  _getText(String text, double fontSize) {
    return Text(text,
        style: TextStyle(fontSize: fontSize), textAlign: TextAlign.justify);
  }
}
