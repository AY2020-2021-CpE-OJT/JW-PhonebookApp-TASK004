import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contactModel.dart';

class createNewContact extends StatefulWidget {
  @override
  _createNewContactState createState() => _createNewContactState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _createNewContactState extends State<createNewContact> {
  int _count = 1, key = 0;
  String val = '';
  String _result = '';
  RegExp digitValidator = RegExp("[0-9]+");
  bool isANumber = true;
  String fname = '', lname = '';
  List<Map<String, dynamic>> _values = [];

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  @override
  void initStat() {
    super.initState();
    _count = 1;
    _result = '';
    _values = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New", style: TextStyle(color: Color(0xFF5B3415))),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              setState(() {
                _count++;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                _count = 1;
                _result = '';
              });
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: fnameController,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF5B3415),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFCC13A),
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'First name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: lnameController,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF5B3415),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFCC13A),
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'Last Name'),
            ),
            SizedBox(height: 20),
            Text("Contact Number/s",
                style: TextStyle(color: Color(0xFF5B3415))),
            SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                  itemCount: _count,
                  itemBuilder: (context, index) {
                    return _row(index);
                  }),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(_result),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.save),
        label: Text("Save"),
        foregroundColor: Color(0xFFFCC13A),
        backgroundColor: Color(0xFF5B3415),
      ),
    );
  }

  _row( key) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            maxLength: 8,
            keyboardType: TextInputType.phone,
            decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF5B3415),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFCC13A),
                  ),
                ),
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorText: isANumber ? null : "Please enter a number",
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Number $key'),
            onChanged: (val) {
              //_onUpdate(key, val);
              if (val.isEmpty || digitValidator.hasMatch(val)) {
                _onUpdate(key, val);
                setValidator(true);
              } else {
                setValidator(false);
              }
            },
          ),
        ),
      ],
    );
  }

  _onUpdate(int key, String val) {
    key = 0;
    int foundKey = -1;
    for (var map in _values) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }
    Map<String, dynamic> json = {
      'id': key,
      'phone_numbers': [val]
    };

    _values.add(json);

    setState(() {
      _result = _prettyPrint(_values);
    });
  }

  String _prettyPrint(jsonObject) {
    var encoder = JsonEncoder.withIndent('    ');
    return encoder.convert(jsonObject);
  }

  void setValidator(valid) {
    setState(() {
      isANumber = valid;
    });
  }
}
