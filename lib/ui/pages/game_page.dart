import 'package:Lines/ui/views/game_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:image/image.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Играть с ботом', textAlign: TextAlign.center),
          ),
          body: Center(
            child: Field_game(),
          )),
    );
  }
}


