import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Lines/resources/constants.dart';

const int field_size = Res.field_size;
const int B = 1;
const int R = -1;
const int EMPTY = 0;
const int INF = 2000000000; // infinity

const Color EmptyCellColor = Res.emptyCellColor;
const CellColors = {B: Res.player1Color, R: Res.player2Color};
const PlayerNames = {B: Res.player1, R: Res.player2};

class GamePage extends StatefulWidget {
  final String title;
  bool botMode;

  GamePage({this.title, this.botMode}) {
    botMode = title == Res.onePlayerButton ? true : false;
  }

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  List<List> _board;
  int _actualPlayer;
  var _score;
  String _info;

  var _directory;
  var _file;
  String fileText = '';
  String _listScore = '';

  @override
  void initState() {
    super.initState();
    _initialize();
    _openDirectory();
  }

  void _initialize() {
    _actualPlayer = B;
    _board =
        List.generate(field_size, (i) => List.generate(field_size, (j) => 0));
    int y = (field_size - 1) ~/ 2, x = (field_size + 1) ~/ 2;
    _board[y][y] = R;
    _board[y][x] = B;
    _board[x][y] = B;
    _board[x][x] = R;
    _score = {B: 2, R: 2};
    _info = Res.newGame;
    setState(() {});
  }

  _openDirectory() async {
    try {
      _directory = await getApplicationDocumentsDirectory();
      _file = File('${_directory.path}${Res.pathToDataFile}');
      String text = await _file.readAsString();
      //String file = _createNewDate(); _reWrite(file); // случай перезаписи файла
      setState(() {
        fileText = text;
        _openState();
        _info = Res.loadData;
      });
    } catch (e) {
      print(Res.noFileInDirectory);
      String file = _createNewDate();
      _reWrite(file);
    }
  }

  _openState() {
    String file = fileText;
    String map = Tag.deXML(file, Tag.BOARD);
    List<String> line = Tag.deXMLArray(map, Tag.LINE);
    for (int i = 0; i < field_size; i++) {
      List<String> sell = Tag.deXMLArray(line[i], Tag.SELL);
      for (int j = 0; j < field_size; j++) {
        _board[i][j] = int.parse(sell[j]);
      }
    }
    var score = Tag.deXML(file, Tag.SCORE);
    _score[B] = int.parse(Tag.deXML(score, Tag.BLACK));
    _score[R] = int.parse(Tag.deXML(score, Tag.RED));
    List<String> list = Tag.deXMLArray(fileText, Tag.GAME);
    for (int i = 0; i < list.length; i++)
      _listScore += Tag.enXML(Tag.GAME, list[i]);
  }

  _createDate() {
    String file = '', map = '', line = '';
    var _ = Duration(seconds: 2);
    for (int i = 0; i < field_size; i++) {
      line = '';
      for (int j = 0; j < field_size; j++)
        line += Tag.enXML(Tag.SELL, _board[i][j].toString());
      map += Tag.enXML(Tag.LINE, line);
    }
    file += Tag.enXML(Tag.BOARD, map);
    String score = Tag.enXML(Tag.BLACK, _score[B].toString()) +
        Tag.enXML(Tag.RED, _score[R].toString());
    file += Tag.enXML(Tag.SCORE, score);
    return file;
  }

  _createNewDate() {
    String file = '', map = '', line = '';
    int y = (field_size - 1) ~/ 2, x = (field_size + 1) ~/ 2;
    var _ = Duration(seconds: 2);
    for (int i = 0; i < field_size; i++) {
      line = '';
      for (int j = 0; j < field_size; j++)
        if (i == y && j == y || i == x && j == x)
          line += Tag.enXML(Tag.SELL, R.toString());
        else if (i == y && j == y + 1 || i == x && j == x - 1)
          line += Tag.enXML(Tag.SELL, B.toString());
        else
          line += Tag.enXML(Tag.SELL, 0.toString());
      map += Tag.enXML(Tag.LINE, line);
    }
    file += Tag.enXML(Tag.BOARD, map);
    String score =
        Tag.enXML(Tag.RED, 2.toString()) + Tag.enXML(Tag.BLACK, 2.toString());
    file += Tag.enXML(Tag.SCORE, score);
    return file;
  }

  _saveState() {
    String file = _createDate();
    file += _listScore;
    print(_listScore);
    _reWrite(file);
  }

  _addGameState() {
    String game = Tag.enXML(Tag.BLACK, _score[B].toString());
    game += Tag.enXML(Tag.RED, _score[R].toString());

    DateTime now = DateTime.now();
    var time = DateFormat(Res.dateFormat).format(now);
    game += Tag.enXML(Tag.TIME, time.toString());
    _listScore += Tag.enXML(Tag.GAME, game);
  }

  _reWrite(String text) async {
    await _file.writeAsString(text);
  }

  // страница
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterBuild(context));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          InkWell(
            child: Container(child: Icon(Res.iconReGame, size: 30), width: 55),
            onTap: () => {_initialize(), _saveState()},
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          //_showBackDialog();
          Navigator.pop(context);
          return false;
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: _buildScore(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildBoard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScore() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.75 - 2,
      height: width / 8,
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
          border: Border.all(color: Res.borderColor, width: 1),
          color: EmptyCellColor),
      child: Row(
        children: [
          Container(width: width / 8 - 1, child: _getIcons(B, width)),
          Container(
            width: width / 8 - 1,
            child: Container(
              width: width / 8 - 10,
              height: width / 8 - 10,
              child: Center(
                child: Text(_score[1].toString(),
                    style: TextStyle(color: Res.textColor)),
              ),
              decoration: BoxDecoration(
                color: CellColors[B],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: width / 8 + width / 8 - 1,
            child: Container(
              child: Center(child: Text('vs', style: TextStyle(fontSize: 20))),
            ),
          ),
          Container(
            width: width / 8 - 1,
            child: Container(
              width: width / 8 - 10,
              height: width / 8 - 10,
              child: Center(
                child: Text(_score[-1].toString(),
                    style: TextStyle(color: Res.textColor)),
              ),
              decoration:
                  BoxDecoration(color: CellColors[R], shape: BoxShape.circle),
            ),
          ),
          Container(
            width: width / 8 - 1,
            child: _getIcons(R, width),
          )
        ],
      ),
    );
  }

  // получить иконку игроков для строки со счетом
  _getIcons(int player, double width) {
    if (widget.botMode && player == R)
      return Icon(
        Res.iconBot,
        size: width / 8 - 2,
        color: _actualPlayer == R ? Res.playerOnIconColor : Res.playerOffIconColo,
      );
    else
      return Icon(
        Res.iconPlayer,
        size: width / 8 - 2,
        color: player == _actualPlayer ? Res.playerOnIconColor : Res.playerOffIconColo,
      );
  }

  // отработка таймера для хода бота
  void _afterBuild(BuildContext context) {
    if (widget.botMode) if (_actualPlayer == R)
      var _ = Timer(Duration(milliseconds: 500), () => _botMove());
  }

  // ход бота
  void _botMove() {
    Move m = _findBestMove(_actualPlayer, 3, -INF, INF, _actualPlayer);
    _update(m.x, m.y);
  }

  // доска
  List<Widget> _buildBoard() {
    List<Widget> L = List<Widget>();
    for (int i = 0; i < field_size; i++) {
      L.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildRow(i),
      ));
    }
    L.add(Container(
        margin: EdgeInsets.only(top: 20),
        child: Text(
          '$_info',
          style: TextStyle(fontSize: 18),
        )));
    return L;
  }

  // делает из шариков строчку
  List<Widget> _buildRow(int r) {
    List<Widget> L = List<Widget>();
    for (int i = 0; i < field_size; i++) {
      L.add(_buildCell(r, i));
    }
    return L;
  }

  // возвращает клетку с шариком или без
  Widget _buildCell(int r, int c) {
    return GestureDetector(
      onTap: () => _userMove(r, c),
      child: Container(
        width: MediaQuery.of(context).size.width / field_size - 2,
        height: MediaQuery.of(context).size.width / field_size - 2,
        margin: EdgeInsets.all(1),
        decoration:
            BoxDecoration(border: _getBorder(r, c), color: EmptyCellColor),
        child: _buildPeg(r, c),
      ),
    );
  }

  // бортики для клеток
  _getBorder(int r, int c) {
    if ((!widget.botMode && _isValid(r, c, _actualPlayer)) ||
        (widget.botMode && _actualPlayer == B && _isValid(r, c, B)))
      return Border.all(color: Res.borderLightColor, width: 2);
    return Border.all(color: Res.borderColor, width: 1);
  }

  // возвращает кружек(контейнер круглый) красного/черного цвета
  Widget _buildPeg(int r, int c) {
    if (_board[r][c] == EMPTY) return null;
    var color = CellColors[_board[r][c]];
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // функция отработки нажатия
  _userMove(int r, int c) {
    _update(r, c);
  }

  // конец раунда
  _showEndGameDialog({String text}) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(Res.endGame),
        content: new Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text(Res.newGameButton),
            onPressed: () {
              Navigator.of(context).pop();
              _initialize();
              _saveState();
            },
          )
        ],
      ),
    );
  }

  // ход, если это возможно
  void _update(int r, int c) {
    if (!_isValid(r, c, _actualPlayer)) return;

    setState(() {
      _move(r, c, _actualPlayer);
      var w = _winner(); // тот кто побеждает
      if (w == B ||
          w == R ||
          _score[B] + _score[R] == field_size * field_size) {
        // если игра кончилась
        String s = PlayerNames[w];
        if (w == 0) {
          _info = Res.tieGame;
          _showEndGameDialog(
              text: "${Res.tieGameDialog}${_score[w]}:${_score[-w]}");
        } else
          _info = "$s${Res.winPlayer}";
        _showEndGameDialog(
            text: "$s${Res.winPlayerDialog}${_score[w]}:${_score[-w]}");
        _addGameState();
        _saveState();
      } else if (!_hasValidMove(-_actualPlayer)) {
        // если у игрока нет ходов
        String current = PlayerNames[_actualPlayer];
        String opponent = PlayerNames[-_actualPlayer];
        _info = "$opponent${Res.notStep}\n$current${Res.mustStep}";
      } else {
        _actualPlayer = -_actualPlayer;
        _info = '';
      }
      _saveState();
    });
  }

  // находится ли в пределах доски
  bool _inRange(int x, int y) {
    return (x >= 0 && x < field_size && y >= 0 && y < field_size);
  }

  // проверка можно ли сюда походить
  bool _isValid(int x, int y, int player) {
    if (!_inRange(x, y)) return false;
    if (_board[x][y] != EMPTY) return false;

    for (int dx = -1; dx <= 1; dx++)
      for (int dy = -1; dy <= 1; dy++) {
        var opponent = false, self = false;
        for (int i = x + dx, j = y + dy; _inRange(i, j); i += dx, j += dy) {
          if (_board[i][j] == EMPTY) break;
          if (_board[i][j] == player) {
            self = true;
            break;
          } else
            opponent = true;
        }
        if (self && opponent) return true;
      }
    return false;
  }

  // могут ли игроки походить
  bool _hasValidMove(int player) {
    // один из игроков не исеет ходов
    if (_score[B] == 0 || _score[R] == 0) return false;
    // нет пустих клеток
    if (_score[B] + _score[R] == field_size * field_size) return false;

    for (int i = 0; i < field_size; i++)
      for (int j = 0; j < field_size; j++)
        if (_isValid(i, j, player)) return true;

    return false;
  }

  // кто то победил
  int _winner() {
    // если хотя бы у одного игрока есть ход игра продолжается
    if (!_hasValidMove(B) && !_hasValidMove(R))
      return (_score[B] > _score[R]
          ? B
          : _score[B] < _score[R]
              ? R
              : 0);
    return INF;
  }

  // после хода посчитать счет
  void _move(int x, int y, int player) {
    _board[x][y] = player;

    _score[player]++;
    for (int dx = -1; dx <= 1; dx++)
      for (int dy = -1; dy <= 1; dy++) {
        var opponent = false, self = false;
        int i = x + dx, j = y + dy;
        for (; _inRange(i, j); i += dx, j += dy) {
          if (_board[i][j] == EMPTY) break;
          if (_board[i][j] == player) {
            self = true;
            break;
          } else
            opponent = true;
        }
        if (self && opponent)
          for (int I = x + dx, J = y + dy; I != i || J != j; I += dx, J += dy) {
            _board[I][J] = player;
            _score[B] += player;
            _score[R] -= player;
          }
      }
  }

  // находит для бота лучший путь
  Move _findBestMove(
      int player, int depth, int alpha, int beta, int maxPlayer) {
    var w = _winner();
    if (w != INF) {
      var val = (w == 0
          ? 0
          : w == maxPlayer
              ? INF
              : -INF);
      return Move(score: val);
    }

    if (depth == 0) return Move(score: 0);

    var cut = false;
    var xx = -1, yy = -1;
    var tmpBoard, tmpCnt;
    var notMoved = true;

    for (int i = 0; i < field_size && !cut; i++)
      for (int j = 0; j < field_size && !cut; j++) {
        if (!_isValid(i, j, player)) continue;
        if (xx == -1) {
          xx = i;
          yy = j;
        }

        tmpBoard = [
          for (var L in _board) [...L]
        ];
        tmpCnt = Map.from(_score);

        _move(i, j, player);
        notMoved = false;
        var r = _findBestMove(-player, depth - 1, alpha, beta, maxPlayer);

        _board = [
          for (var L in tmpBoard) [...L]
        ];
        _score = Map.from(tmpCnt);

        if (player == maxPlayer) {
          if (r.score > alpha) {
            alpha = r.score;
            xx = i;
            yy = j;
          }
        } else {
          if (r.score < beta) beta = r.score;
        }

        if (beta <= alpha) cut = true;
      }

    if (notMoved) {
      tmpBoard = [
        for (var L in _board) [...L]
      ];
      tmpCnt = Map.from(_score);

      var r = _findBestMove(-player, depth - 1, alpha, beta, maxPlayer);

      _board = [
        for (var L in tmpBoard) [...L]
      ];
      _score = Map.from(tmpCnt);

      if (player == maxPlayer) {
        if (r.score > alpha) alpha = r.score;
      } else {
        if (r.score < beta) beta = r.score;
      }
    }

    if (player == maxPlayer) {
      return Move(score: alpha, x: xx, y: yy);
    }

    return Move(score: beta, x: xx, y: yy);
  }
}

class Move {
  int score;
  int x;
  int y;

  Move({this.score, this.x = -1, this.y = -1});
}
