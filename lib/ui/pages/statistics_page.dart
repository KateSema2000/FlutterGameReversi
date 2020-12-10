import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Reversi/resources/constants.dart';

class Statistics extends StatefulWidget {
  final String title;

  Statistics({this.title});

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  var _directory;
  var _file;
  var _fileText = '';

  int _victories = 0;
  int _tie = 0;
  int _beating = 0;
  List<String> games;

  @override
  void initState() {
    super.initState();
    _openDirectory();
  }

  _clearStates() async {
    await _file.writeAsString(''); // случай перезаписи файла
    setState(() {});
  }

  _openDirectory() async {
    try {
      _directory = await getApplicationDocumentsDirectory();
      _file = File('${_directory.path}${Res.pathToDataFile}');
      _fileText = await _file.readAsString();
      games = Tag.deXMLArray(_fileText, Tag.GAME);
      setState(() {
        for (int i = 0; i < games.length; i++) {
          int black = int.parse(Tag.deXML(games[i], Tag.BLACK));
          int red = int.parse(Tag.deXML(games[i], Tag.RED));
          _victories += black > red ? 1 : 0;
          _tie += black == red ? 1 : 0;
          _beating += black < red ? 1 : 0;
        }
      });
    } catch (e) {
      print(Res.noFileInDirectory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          InkWell(
            child:
                Container(child: Icon(Res.iconDeleteDate, size: 30), width: 55),
            onTap: () => {_clearStates()},
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    Res.gameName,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Res.borderColor, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Res.wins, style: TextStyle(fontSize: 16)),
                          Text(Res.ties, style: TextStyle(fontSize: 16)),
                          Text(Res.beating, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$_victories', style: TextStyle(fontSize: 16)),
                          Text('$_tie', style: TextStyle(fontSize: 16)),
                          Text('$_beating', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildGameStates(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGameStates() {
    List<Widget> list = List<Widget>();
    if (games != null)
      for (int i = 0; i < games.length; i++) {
        list.add(Container(child: _buildStateLine(i)));
      }
    return list;
  }

  Widget _buildStateLine(int i) {
    String state = games[i];
    String text = Tag.deXML(state, Tag.TIME) +
        Res.player1statistic +
        Tag.deXML(state, Tag.BLACK) +
        Res.player2statistic +
        Tag.deXML(state, Tag.RED);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.all(1),
      decoration:
          BoxDecoration(border: Border.all(color: Res.borderColor, width: 1)),
      child: Center(child: Text(text, style: TextStyle(fontSize: 16))),
    );
  }
}
