import 'package:flutter/material.dart';
import 'package:sportson/resources/StyleResources.dart';

class MainTitle extends StatelessWidget {

  var text;
  MainTitle({this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Implement the stroke
        Text(
          text,
          style: TextStyle(
            fontSize: 49.0,
            fontFamily: 'TekoSemibold',
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = StyleResources.GreenColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 49.0,
              color: StyleResources.WhiteColor,
              fontFamily: 'TekoSemibold'
          ),
        ),
      ],
    );
  }
}
