import 'dart:ui';
import 'package:flutter/material.dart';

class Res {
  Res._();

  // Главное меню
  static const String gameName = 'Реверси';
  static const String menuTitle = 'Главное меню';
  static const Color mainButtonColor = Colors.greenAccent;
  static const Color mainThemeColor = Colors.blue;
  static const String welcomeText  = 'Приветствую в Реверси!';
  static const String onePlayerButton = 'Одиночная игра';
  static const String twoPlayerButton = 'Играть с другом';
  static const String howToPlayButton = 'Как играть';
  static const String statisticButton = 'Статистика';

  // Игра
  static const int field_size = 8;
  static const String player1 = 'Черный';
  static const String player2 = 'Красный';
  static const Color player1Color = Colors.black54;
  static const Color player2Color = Colors.red;
  static const Color borderLightColor = Colors.green;
  static const Color emptyCellColor = Colors.white10;
  static const Color borderColor = Colors.grey;
  static const Color textColor = Colors.white;
  // строка счета
  static const iconReGame = Icons.autorenew;
  static const iconPlayer= Icons.account_circle_rounded;
  static const iconBot = Icons.adb_rounded;
  static const Color playerOnIconColor = Colors.indigoAccent;
  static const Color playerOffIconColo = Colors.black;
  // подсказки
  static const String newGame = 'новая игра';
  static const String loadData = 'загружено';
  static const String endGame = 'Конец игры!';
  static const String newGameButton = 'Начать новую игру';
  static const String notStep = 'не имеет ходов!';
  static const String mustStep = ' должен походить!';
  // конец игры
  static const String tieGame = 'игра галстук!';
  static const String tieGameDialog = 'Игра галстук! счет ';
  static const String winPlayer = ' победил';
  static const String winPlayerDialog = ' победил со счетом ';
  // обработка данных
  static const String dateFormat = 'MM/dd hh:mm:ss';
  static const String pathToDataFile = '/data_file_reversi.txt';
  static const String noFileInDirectory = 'Нет файла или невозможно его считать.';

  // Статистика
  static const String wins = 'Победы';
  static const String ties = 'Игра галстук';
  static const String beating = 'Потери';
  static const String player1statistic = ' черные: ';
  static const String player2statistic = ' красные: ';

  // Правила игры
  static const String target_game_title = 'Цель игры';
  static const String target_game_text =
      '  Принципы классической игры очень простые: Окружая фишки оппонента своими, захватывайте их, переворачивая его фишки и получая фишки своего цвета. Игрок с наибольшим количеством фишексвоего цвета на доске побеждает в игре.';
  static const String game_step_title = 'Ход игры';
  static const String game_step_text =
      '  Две черные и две красны фишки помещены вцентр игрового поля так, как показано на рисунке. Начинают черные, игрок ходит одной из фишек по игровому полю. \n  Вы должны перемещать каждую фишку по игровому полю так, чтобы она прилегал как минимум кодной фишке противника. Окруженные фишки – это те фишки, к которым по прямойлинии по вертикали, горизонтали или диагонали прилегает фишка противника.\n  Когда одна из фишек окружена двумя фишками противника, то фишка первого игрока переворачивается и становится фишкой второго.\n  Если вы поместили свои фишки настолько удачно, что они окружают фишки противника более чемв одном направлении сразу, вы можете перевернуть все эти фишки сразу, превратив их в фишкисвоего цвета.\n  Если игрок не в состоянии переместить фишки согласно правилам, он пропускает ход, и ходпереход к его противнику.';
  static const String end_game_title = 'Конец игры';
  static const String end_game_text =
      '  Игра заканчивается, когда на доске оказываются все 64 фишки или, когда ни один из игроков неможет сделать ход так, чтобы прилегать к фишке соперника.\n  Побеждает игрок с наибольшим количеством фишек своего цвета. В случае равного количества фишек, побеждает игрок, начавший игру вторым.';
}

class Tag {
  Tag._();

  static const BOARD = ["<board>", "</board>"]; // доска
  static const LINE = ["<line>", "</line>"]; // строка
  static const SELL = ["<sell>", "</sell>"]; // ячейка
  static const SCORE = ["<score>", "</score>"];
  static const BLACK = ["<black>", "</black>"];
  static const RED = ["<red>", "</red>"];
  static const GAME = ["<game>", "</game>"];
  static const VICTORY = ["<victory>", "</victory>"];
  static const BEATING = ["<beating>", "</beating>"];
  static const TIE = ["<tie>", "</tie>"];
  static const TIME = ["<time>", "</time>"];

  static deXML(String str, List<String> tag) {
    // взять содержимое из хмл строки
    if (str.indexOf(tag[0]) < 0) return "";
    return str.substring(
        str.indexOf(tag[0]) + tag[0].length, str.indexOf(tag[1]));
  }

  static enXML(List<String> tag, String str) {
    // завернуть строку в хмл
    return tag[0] + str + tag[1];
  }

  static deXMLArray(String str, List<String> tag) {
    // вытянуть из хмл много одинаковых содержимых тегов
    String finalStr = str;
    List<String> tagArray = [];
    while (!(finalStr.indexOf(tag[0]) < 0)) {
      tagArray.add(deXML(finalStr, tag));
      finalStr = finalStr.replaceFirst(tag[0] + tagArray.last + tag[1], "");
    }
    if (tagArray.isEmpty) return new List<String>();
    var array = List<String>(tagArray.lastIndexOf(tagArray.last) + 1);
    for (int i = 0; i < array.length; i++) array[i] = tagArray[i];
    return array;
  }
}
