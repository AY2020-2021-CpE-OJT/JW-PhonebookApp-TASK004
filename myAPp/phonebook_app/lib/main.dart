import 'package:flutter/material.dart';
import 'package:phonebook_app/createContact.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(
        primaryColor: Color(0xFFFCC13A),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Color(0xFFFCC13A),
            selectionHandleColor: Color(0xFFFCC13A)),
      ),
      debugShowCheckedModeBanner: false,
      //
      home: CreateNewContact(),
    );
  }
}
