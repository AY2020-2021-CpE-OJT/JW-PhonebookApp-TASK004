import 'package:flutter/material.dart';
import 'package:phonebook_app/DataFromAPI.dart';

import 'createContact.dart';

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
              selectionHandleColor: Color(0xFFFCC13A),
              selectionColor: Color(0xABFFD36B)),
        ),
        debugShowCheckedModeBanner: false,
        //
        home: DataFromAPI(),
        routes: <String, WidgetBuilder>{
          '/screen1': (BuildContext context) => new DataFromAPI(),
          '/screen2': (BuildContext context) => new CreateNewContact(),
        });
  }
}
