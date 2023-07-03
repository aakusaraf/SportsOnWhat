import 'package:flutter/material.dart';

import '../resources/StyleResources.dart';

class UnorderedList extends StatelessWidget {
  UnorderedList(this.texts,{this.color});
  final List<String> texts;
  Color color;


  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text,color));
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text,this.color);
  final String text;Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• ",style: TextStyle(
          fontSize: 12.0,
          fontFamily: 'PoppinsRegular',
          color:color,
        )),
        Expanded(
          child: Text(text,style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PoppinsRegular',
            color: color,
          ),),
        ),
      ],
    );
  }
}