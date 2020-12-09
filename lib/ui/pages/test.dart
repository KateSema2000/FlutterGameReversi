import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _directory;
  var _file;
  String fileText = '';

  @override
  void initState() {
    super.initState();
    _openDirectory();
  }

  _openDirectory() async {
    try {
      _directory = await getApplicationDocumentsDirectory();
      _file = File('${_directory.path}/data_file_reversi.txt');
      String text = await _file.readAsString();
      setState(() {
        fileText = text;
      });
    } catch (e) {
      print("Нет файла или невозможно его считать.");
      final _file = File('${_directory.path}/data_file_reversi.txt');
      await _file.writeAsString(fileText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('dfbvfdbdfb')),
      body: Text('$fileText'),
    );
  }
}
