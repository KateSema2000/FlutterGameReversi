import 'package:Lines/Logic/Place.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
final int length_list = 64;

// ignore: camel_case_types
class Field_game extends StatefulWidget {
  @override
  _Field_gameState createState() => _Field_gameState();
}

// ignore: camel_case_types
class _Field_gameState extends State<Field_game> {
  var map = List<Widget>(length_list);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < length_list; i++) {
      int x = i % 8;
      int y = i ~/ 8;
      Image img = Image.asset('assets/chips/chip_2.png');
      Place place = Place(x: x, y: y, img: img);
      map[i] = PlaceTile(place);
    }
    return GridView.count(
      crossAxisCount: 8,
      children: map,
    );
  }
}

// ignore: must_be_immutable
class PlaceTile extends StatefulWidget {
  Place _place;

  PlaceTile(Place place) {
    _place = Place(x: place.x, y: place.y, img: place.img);
  }

  @override
  _PlaceTileState createState() => _PlaceTileState();
}

class _PlaceTileState extends State<PlaceTile> {
  void _tapOnField() {
    setState(() {
      widget._place.img = Image.asset('assets/chips/chip_21.png');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget._place.img,
      onTap: () => {
        print("y=" +
            widget._place.y.toString() +
            " x=" +
            widget._place.x.toString()),
        _tapOnField()
      },
    );
  }
}
