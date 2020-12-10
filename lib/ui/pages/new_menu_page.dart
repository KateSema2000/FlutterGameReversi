import 'package:flutter/material.dart';
import 'game_field_page.dart';
import 'package:Reversi/ui/pages/test.dart';
import 'package:Reversi/ui/pages/page_how_to_play.dart';
import 'package:Reversi/ui/pages/statistics_page.dart';
import 'package:Reversi/resources/constants.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _nextTitle;

  void _navigatorToGamePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => GamePage(title: _nextTitle)));
  }

  void _navigatorToHowToPlayPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => HowToPlay(title: _nextTitle)));
  }

  void _navigatorStatisticsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Statistics(title: _nextTitle)));
  }

  void _navigatorToFilePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(Res.welcomeText, style: TextStyle(fontSize: 24)),
            _buildMenuButton(Res.onePlayerButton, _navigatorToGamePage),
            _buildMenuButton(Res.twoPlayerButton, _navigatorToGamePage),
            _buildMenuButton(Res.howToPlayButton, _navigatorToHowToPlayPage),
            _buildMenuButton(Res.statisticButton, _navigatorStatisticsPage),
            //_buildMenuButton("Файл данных", _navigatorToFilePage),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      String text, void Function(BuildContext context) navToGamePage) {
    return RaisedButton(
      onPressed: () {
        _nextTitle = text;
        navToGamePage(context);
      },
      color: Res.mainButtonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        child: Center(child: Text(text, style: TextStyle(fontSize: 24))),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height / 6,
      ),
    );
  }
}
