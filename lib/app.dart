import 'package:flutter/material.dart';
import 'Screens/google_map.dart';

class Location_with_map extends StatelessWidget {
  const Location_with_map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}
