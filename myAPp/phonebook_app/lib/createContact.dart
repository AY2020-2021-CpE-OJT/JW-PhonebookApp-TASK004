import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contactModel.dart';

class ContactModel {
  final String lastName;
  final String firstName;
  final List<String> phoneNumbers;

  ContactModel(this.lastName, this.firstName, this.phoneNumbers);
}

class CreateNewContact extends StatefulWidget {
  @override
  _CreateNewContactState createState() => _CreateNewContactState();
}

class _CreateNewContactState extends State<CreateNewContact> {
  int key = 0, checkAdd = 0;
  String val = '';

  String _result = '';
  RegExp digitValidator = RegExp("[0-9]+");

  bool isANumber = true;
  String fname = '', lname = '';
  List<Map<String, dynamic>> _values = [];

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  List<TextEditingController> pnumControllers = <TextEditingController>[
    TextEditingController()
  ];

  final FocusNode fnameFocus = FocusNode();
  final FocusNode lnameFocus = FocusNode();

  List<ContactModel> contactsAppend = <ContactModel>[];

  int _count = 1;

  void saveContact() {
    List<String> pnums = <String>[];
    for (int i = 0; i < _count; i++) {
      pnums.add(pnumControllers[i].text);
    }
    setState(() {
      contactsAppend.insert(
          0, ContactModel(lnameController.text, fnameController.text, pnums));
    });
  }

  @override
  void initState() {
    super.initState();
    _count = 1;
    _result = '';
    _values = [];
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New", style: TextStyle(color: Color(0xFF5B3415))),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: fnameController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                focusNode: fnameFocus,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, fnameFocus, lnameFocus);
                },
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
                    labelText: 'First name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: lnameController,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                focusNode: lnameFocus,
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
                    labelText: 'Last Name'),
              ),
              SizedBox(height: 20),
              Text("Contact Number/s",
                  style: TextStyle(color: Color(0xFF5B3415))),
              SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: _count,
                    itemBuilder: (context, index) {
                      return _row(index, context);
                    }),
              ),
              SizedBox(
                height: 10.0,
              ),
              //Text(_result),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          saveContact();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckScreen(todo: contactsAppend)));
        },
        icon: Icon(Icons.save),
        label: Text("Save"),
        foregroundColor: Color(0xFFFCC13A),
        backgroundColor: Color(0xFF5B3415),
      ),
    );
  }

  _row(int key, context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: TextFormField(
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            controller: pnumControllers[key],
            textCapitalization: TextCapitalization.sentences,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
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
                labelText: 'Phone number #$key'),
            onChanged: (val) {
              if (val.isEmpty || digitValidator.hasMatch(val)) {
                _onUpdate(key, val);
                setValidator(true);
              } else {
                setValidator(false);
              }
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: 24,
            height: 24,
            child: _addRemoveButton(key == checkAdd, key),
          ),
        ),
      ],
    );
  }

  _onUpdate(int key, String val) {
    //key = 0;
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

  Widget _addRemoveButton(bool add, int index) {
    return GestureDetector(
      child: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (add) {
            setState(() {
              _count++;
              checkAdd++;
              pnumControllers.insert(0, TextEditingController());
            });
          } else {
            setState(() {
              _count--;
              checkAdd--;
              pnumControllers.removeAt(index);
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: (add) ? Color(0xFFFCC13A) : Colors.redAccent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            (add) ? Icons.add : Icons.remove,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

class CheckScreen extends StatelessWidget {
  final List<ContactModel> todo;

  const CheckScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: todo.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  '${todo[index].firstName} ${todo[index].lastName} ${todo[index].phoneNumbers}'),
            );
          },
        ),
      ),
    );
  }
}
