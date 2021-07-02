import 'package:flutter/material.dart';
import 'package:phonebook_app/testDynamic.dart';
import 'package:phonebook_app/testTextinput.dart';
import 'DataFromAPI.dart';
import 'createContact.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(primaryColor: Color(0xFFFCC13A)),
      debugShowCheckedModeBanner: false,
      //
      home: DataFromAPI(),
    );
  }
}
