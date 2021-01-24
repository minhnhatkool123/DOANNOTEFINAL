import 'package:flutter/material.dart';

List<Color> colors = [
  Color(0xFFFFFFFF),
  Color(0xffF28B83),
  Color(0xFFFCBC05),
  Color(0xFFFFF476),
  Color(0xFFCBFF90),
  Color(0xFFA7FEEA),
  Color(0xFFE6C9A9),
  Color(0xA0A0A0A0),
  Color(0xFFFF7DDD),
  Color(0xFF836FFF)
  //Color(0xFFCAF0F8)
];

class ColorPick extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  ColorPick({this.onTap, this.selectedIndex});
  @override
  _ColorPickState createState() => _ColorPickState();
}

class _ColorPickState extends State<ColorPick> {
  int selected;
  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      selected = widget.selectedIndex;
    }
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selected = index;
              });
              print('ben color');
              widget.onTap(index);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: 50,
              height: 50,
              child: Container(
                child: Center(
                  child: selected == index ? Icon(Icons.done) : Container(),
                ),
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
