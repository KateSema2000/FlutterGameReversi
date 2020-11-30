import 'package:flutter/material.dart';
import 'package:Lines/ui/pages/game_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text(widget.title),
      //),
      body: _buildbody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildbody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
*/
class _MyHomePageState extends State<MyHomePage> {
  void _navigatorToGamePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GamePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Реверси', textAlign: TextAlign.center),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuButton("Одиночная игра", _navigatorToGamePage),
              _buildMenuButton("Играть с другом", _navigatorToGamePage),
              _buildMenuButton("Опции", _navigatorToGamePage),
              _buildMenuButton("Как играть", _navigatorToGamePage),
              _buildMenuButton("Статистика", _navigatorToGamePage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      String text, void Function(BuildContext context) navigatorToGamePage) {
    return RaisedButton(
      onPressed: () {
        navigatorToGamePage(context);
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF0D47A1),
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
            ],
          ),
          border: new Border.all(color: Colors.black, width: 2.0),
          //borderRadius: new BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
        width: 300,
        child: Text(text,
            style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
      ),
    );
  }
}
