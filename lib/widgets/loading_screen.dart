import 'package:flutter/material.dart';

import '../resources/StyleResources.dart';

class loading_screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          color: StyleResources.GreenColor,
        ),
      ),
    );
  }
}
