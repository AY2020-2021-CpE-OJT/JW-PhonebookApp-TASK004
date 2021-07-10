import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phonebook_app/updateContact.dart';
import 'dart:convert';
import 'createContact.dart';

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => new _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  final String apiUrlget = "https://jwa-phonebook-api.herokuapp.com/contacts";

  List<dynamic> _users = [];

  void fetchContacts() async {
    var result = await http.get(Uri.parse(apiUrlget));
    setState(() {
      _users = jsonDecode(result.body);
    });
    print("Status Code [" + result.statusCode.toString() + "]: All Data Fetched");
  }

  String _name(dynamic user) {
    return user['first_name'] + " " + user['last_name'];
  }

  String _phonenum(dynamic user) {
    return "First Number: " + user['phone_numbers'][0];
  }

  Future<http.Response> deleteContact(String id) {
    print("Status [Deleted]: [" + id + "]");
    return http.delete(Uri.parse('https://jwa-phonebook-api.herokuapp.com/contacts/delete/' + id));
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
            return _users.length != 0
                ? RefreshIndicator(
                    child: ListView.builder(
                        padding: EdgeInsets.all(12.0),
                        itemCount: _users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(_users[index].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                                Icon(Icons.delete_forever, color: Colors.white70),
                                Text("Delete",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white70))
                              ]),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onDismissed: (direction) {
                              String id = _users[index]['_id'].toString();
                              String userDeleted = _users[index]['first_name'].toString();
                              deleteContact(id);
                              setState(() {
                                _users.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$userDeleted dismissed'),
                                ),
                              );
                            },
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm",
                                        style: TextStyle(
                                          color: Color(0xFF5B3415),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    content: const Text("Are you sure you wish to delete this contact?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text("DELETE", style: TextStyle(color: Colors.redAccent))),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("CANCEL", style: TextStyle(color: Color(0xFFFCC13A))),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    tileColor: index % 2 == 0 ? Color(0x80FCC13A) : Color(0x40FFB500),
                                    title: Text(
                                      _name(_users[index]),
                                      style: TextStyle(
                                        color: Color(0xFF5B3415),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(_phonenum(_users[index])),
                                    onTap: () {
                                      List<int> listNumbers = [];
                                      for (int i = 0; i < _users[index]['phone_numbers'].length; i++) {
                                        listNumbers.add(i + 1);
                                      }
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: AlertDialog(
                                                  title: Text(
                                                    _name(_users[index]),
                                                    style: TextStyle(
                                                        color: Color(0xFF5B3415),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24),
                                                  ),
                                                  content: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("Contact Number/s",
                                                              style: TextStyle(
                                                                  color: Color(0xFF5B3415),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20)),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => UpdateContact(
                                                                          specificID: _users[index]['_id'].toString())),
                                                                  (_) => false);
                                                            },
                                                            child: const Text(
                                                              'EDIT',
                                                              style: TextStyle(
                                                                color: Color(0xFFFCC13A),
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: List.generate(
                                                            listNumbers.length,
                                                            (iter) {
                                                              return Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'Phone #' +
                                                                        listNumbers[iter].toString() +
                                                                        ':\t\t' +
                                                                        _users[index]['phone_numbers'][iter].toString(),
                                                                    style: TextStyle(
                                                                        color: Color(0xFF5B3415), fontSize: 14),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  contentPadding: EdgeInsets.fromLTRB(24, 12, 0, 0),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          color: Color(0xFFFCC13A),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  actionsPadding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    onRefresh: _getData,
                  )
                : Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B3415))));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewContact()));
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
    fetchContacts();
  }

  Future<void> _getData() async {
    setState(() {
      fetchContacts();
    });
  }
}
