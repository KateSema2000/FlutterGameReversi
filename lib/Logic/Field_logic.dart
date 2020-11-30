//import "package:flutter/material.dart";

final int size = 8;
int actionPlayer = 2;


class Field {
  var map = List<List>(size);
  var funmap = List<List>(size);
  var score = [0, 0];

  Field() {
    for (int y = 0; y < size; y++) {
      map[y] = List<int>(size);
      funmap[y] = List<int>(size);
      for (int x = 0; x < size; x++) {
        map[y][x] = 0;
        funmap[y][x] = 0;
      }
    }
    map[3][3] = 2;
    map[4][3] = 1;
    map[3][4] = 1;
    map[4][4] = 2;
    FindStep(actionPlayer);
  }

  // ignore: non_constant_identifier_names
  List get_score() {
    score[0] = 0;
    score[1] = 1;
    for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++) {
        if (map[y][x] == 1) score[0] += 1;
        if (map[y][x] == 2) score[1] += 1;
      }
    return score;
  }

  // ignore: non_constant_identifier_names
  void FindStep(int player) {
    for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++) funmap[y][x] = 0;
    for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++)
        if (map[y][x] == player) {
          CheckStep(y, x, 0, -1, player, 1);
          CheckStep(y, x, 1, -1, player, 1);
          CheckStep(y, x, 1, 0, player, 1);
          CheckStep(y, x, 1, 1, player, 1);
          CheckStep(y, x, 0, 1, player, 1);
          CheckStep(y, x, -1, 1, player, 1);
          CheckStep(y, x, -1, 0, player, 1);
          CheckStep(y, x, -1, -1, player, 1);
        }
  }

  // ignore: non_constant_identifier_names
  CheckStep(int y, int x, int py, int px, int player, int k) {
    int xj = x + k * px;
    int yi = y + k * py;
    if (yi < 0 || yi >= size || xj < 0 || xj >= size) return null;
    if (map[yi][xj] != 0 && map[yi][xj] != player)
      CheckStep(y, x, py, px, player, k + 1);
    if (map[yi][xj] == 0 && k >= 2) funmap[yi][xj] += k - 1;
  }

  // ignore: non_constant_identifier_names
  AllStep(int y, int x, int player) {
    Step(y, x, 0, -1, player, 1);
    Step(y, x, 1, -1, player, 1);
    Step(y, x, 1, 0, player, 1);
    Step(y, x, 1, 1, player, 1);
    Step(y, x, 0, 1, player, 1);
    Step(y, x, -1, 1, player, 1);
    Step(y, x, -1, 0, player, 1);
    Step(y, x, -1, -1, player, 1);
  }

  // ignore: non_constant_identifier_names
  Step(int y, int x, int py, int px, int player, int k) {
    int yi = y + k * py;
    int xj = x + k * px;
    if (yi < 0 || yi >= size || xj < 0 || xj >= size) return null;
    if (map[yi][xj] != 0 && map[yi][xj] != player)
      Step(y, x, py, px, player, k + 1);
    if (map[yi][xj] == player)
      for (int a = 1; a < k; a++) {
        yi = y + a * py;
        xj = x + a * px;
        map[yi][xj] = player;
      }
  }

  // ignore: non_constant_identifier_names
  void ChangePlayer() {
    actionPlayer = (1 - (actionPlayer - 1)) + 1;
    FindStep(actionPlayer);
  }

  // ignore: non_constant_identifier_names
  void Click(int y, int x) {
    print('Клик по [$y, $x], фишек =${funmap[y][x]}');
    if (funmap[y][x] > 0) {
      map[y][x] = actionPlayer;
      AllStep(y, x, actionPlayer);
      ChangePlayer();
      if (!IsStep()) ChangePlayer();
    }
  }

  // ignore: non_constant_identifier_names
  bool IsStep() {
    for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++) if (funmap[y][x] > 0) return true;
    return false;
  }

  // ignore: non_constant_identifier_names
  BotStep() {
    int max = 0, xmax = 0, ymax = 0;
    if (funmap[0][0] > 0) {
      Click(0, 0);
      return;
    }
    if (funmap[size - 1][0] > 0) {
      Click(size - 1, 0);
      return;
    }
    if (funmap[0][size - 1] > 0) {
      Click(0, size - 1);
      return;
    }
    if (funmap[size - 1][size - 1] > 0) {
      Click(size - 1, size - 1);
      return;
    }
    for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++) {
        if (x == 0 ||
            y == 0 ||
            x == size - 1 ||
            y == size - 1) if (funmap[y][x] > 0) {
          Click(y, x);
          return;
        }
        if (funmap[y][x] > size) {
          max = funmap[y][x];
          xmax = y;
          ymax = x;
        }
      }
    if (max > 0) Click(ymax, xmax);
  }
}
