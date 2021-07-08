import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'createContact.dart';

class CheckScreen extends StatelessWidget {
  final List<ContactData> todo;

  const CheckScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> strHold = <String>[];
    Future<http.Response> createAlbum(String fname, String lname, List pnums) {
      return http.post(
        Uri.parse('https://jwa-phonebook-api.herokuapp.com/contacts/new'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone_numbers': pnums,
          'first_name': fname,
          'last_name': lname,
        }),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Successful')),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: todo.length,
            itemBuilder: (context, index) {
              createAlbum(todo[index].firstName, todo[index].lastName,
                  todo[index].phoneNumbers);
              return Container(
                child: Column(
                  children: <Widget>[
                    Text('\nSuccessfully Created',
                        style: TextStyle(
                            color: Color(0xFF5B3415),
                            fontWeight: FontWeight.bold,
                            fontSize: 40)),
                    Text(
                        '\n\nFirst Name: ${todo[index].firstName} \n\nLast Name: ${todo[index].lastName} \n\nContact/s:',
                        style:
                        TextStyle(color: Color(0xFF5B3415), fontSize: 24)),
                    for (var strHold in todo[index].phoneNumbers)
                      Text('\n' + strHold,
                          style: TextStyle(
                              color: Color(0xFF5B3415), fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        child: new Text(
                          "Done",
                          style: new TextStyle(
                              fontSize: 20.0, color: Color(0xFFFCC13A)),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/screen1', (_) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF5B3415),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.all(20)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
