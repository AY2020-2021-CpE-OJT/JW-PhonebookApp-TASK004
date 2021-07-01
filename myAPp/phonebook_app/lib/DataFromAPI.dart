import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class DataFromAPI extends StatefulWidget {

  @override
  _DataFromAPIState createState() => new _DataFromAPIState();

}

class _DataFromAPIState extends State<DataFromAPI> {

  final String apiUrl = "https://jwa-phonebook-api.herokuapp.com/contacts";
  List<dynamic> _users = [];

    void fetchUsers() async {
      var result = await http.get(apiUrl);
      setState(() {
        _users = jsonDecode(result.body);
      });
    }
  String _name(dynamic user) {
    return user['first_name'] + " " + user['last_name'];
  }
  //List<String> _phone = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(
            "Contacts",
            style: TextStyle(
                color: Color(0xFF5B3415))),
        leading: Image.asset(
          'assets/icon/pb-logo-fg.png',
          height:80.0,
          width: 80.0,
        ),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            builder: (context, snapshot)  {
              // RESULTS
              return _users.length != 0
                  ? RefreshIndicator(
                child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                title: Text(_name(_users[index])),
                                //subtitle: Text(_phonenum(_users[index]))
                            )
                          ],
                        ),
                      );
                    }),
                onRefresh: _getData,
              )
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF5B3415)
                    )
                  )
              );
            },
            future: _getData(),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add,),
        foregroundColor: Color(0xFFFCC13A),
        backgroundColor: Color(0xFF5B3415),
      ),
    );
  }
  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }
}