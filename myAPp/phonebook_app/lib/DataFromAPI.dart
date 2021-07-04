import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'createContact.dart';

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => new _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  final String apiUrl = "https://jwa-phonebook-api.herokuapp.com/contacts";
  List<dynamic> _users = [];

  void fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    setState(() {
      _users = jsonDecode(result.body);
    });
    print("Status Code [" + result.statusCode.toString() + "]");
  }

  String _name(dynamic user) {
    return user['first_name'] + " " + user['last_name'];
  }

  String _phonenum(dynamic user) {
    return "First Number: " + user['phone_numbers'][0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contacts", style: TextStyle(color: Color(0xFF5B3415))),
        leading: Image.asset(
          'assets/icon/pb-logo-fg.png',
          height: 80.0,
          width: 80.0,
        ),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          builder: (context, snapshot) {
            int count = 0;

            return _users.length != 0
                ? RefreshIndicator(
                    child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: count = _users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(_name(_users[index]),
                                      style: TextStyle(
                                        color: Color(0xFF5B3415),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  subtitle: Text(_phonenum(_users[index])),
                                  //content: () => for (var item in _users[index]['phone_numbers'])Text(item),
                                  onTap: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Padding(
                                      padding: const EdgeInsets.all(48.0),
                                      child: AlertDialog(
                                        title: Text(_name(_users[index]),
                                            style: TextStyle(
                                                color: Color(0xFF5B3415),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24)),
                                        content: Text('Phone Number/s'),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(24, 12, 0, 0),
                                        actions: <Widget>[
                                          for (var item in _users[index]
                                              ['phone_numbers'])
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text('> $item'),
                                              ],
                                            ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK',
                                                style: TextStyle(
                                                  color: Color(0xFFFCC13A),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ],
                                        actionsPadding:
                                            EdgeInsets.fromLTRB(24, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    onRefresh: _getData,
                  )
                : Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF5B3415))));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateNewContact()));
        },
        child: Icon(
          Icons.add,
        ),
        foregroundColor: Color(0xFFFCC13A),
        backgroundColor: Color(0xFF5B3415),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }
}
