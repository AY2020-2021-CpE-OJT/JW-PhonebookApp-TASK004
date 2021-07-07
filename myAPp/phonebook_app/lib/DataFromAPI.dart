import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'createContact.dart';

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => new _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  final String apiUrlget = "https://jwa-phonebook-api.herokuapp.com/contacts";
  final String apiUrldelete =
      "https://jwa-phonebook-api.herokuapp.com/contacts/delete";
  List<dynamic> _users = [];

  void fetchContacts() async {
    var result = await http.get(Uri.parse(apiUrlget));
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

  Future<http.Response> deleteContact(String id) {
    print("Status Deleted [" + id + "]");
    return http.delete(Uri.parse(
        'https://jwa-phonebook-api.herokuapp.com/contacts/delete/' + id));
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
                        padding: EdgeInsets.all(12.0),
                        itemCount: count = _users.length,
                        itemBuilder: (BuildContext context, int index) {
                          //dynamic item = _users[index].toString();
                          return Dismissible(
                            key: Key(_users[index].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.0),

                              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.delete_forever,
                                        color: Colors.white70),
                                    Text("Delete", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.white70))
                                  ]
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onDismissed: (direction) {
                              String id = _users[index]['_id'].toString();
                              String userDeleted =
                                  _users[index]['first_name'].toString();
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
                                    content: const Text(
                                        "Are you sure you wish to delete this contact?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("DELETE",
                                              style: TextStyle(
                                                  color: Colors.redAccent))),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("CANCEL",
                                            style: TextStyle(
                                                color: Color(0xFFFCC13A))),
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
                                    tileColor: index % 2 == 0
                                        ? Color(0x80FCC13A)
                                        : Color(0x40FFB500),
                                    title: Text(_name(_users[index]),
                                        style: TextStyle(
                                          color: Color(0xFF5B3415),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    subtitle: Text(_phonenum(_users[index])),
                                    onLongPress: () {},
                                    onTap: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          Padding(
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
    fetchContacts();
  }

  Future<void> _getData() async {
    setState(() {
      fetchContacts();
    });
  }
}
