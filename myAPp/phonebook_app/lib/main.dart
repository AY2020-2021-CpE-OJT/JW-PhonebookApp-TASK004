import 'package:flutter/material.dart';
import 'DataFromAPI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Contacts',
      theme: ThemeData(
          primaryColor: Color(0xFFFCC13A)),
      debugShowCheckedModeBanner: false,
      //
      home: DataFromAPI(),
    );
  }

}
