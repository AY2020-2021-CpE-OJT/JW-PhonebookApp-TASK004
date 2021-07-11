import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phonebook_app/DataFromAPI.dart';

import 'UpdateScreen.dart';

class ContactData {
  final String lastName;
  final String firstName;
  final List<String> phoneNumbers;

  ContactData(this.lastName, this.firstName, this.phoneNumbers);
}

Future<SpecificContact> fetchSpecificContact(String id) async {
  final response = await http.get(Uri.parse('https://jwa-phonebook-api.herokuapp.com/contacts/get/' + id));
  print('Status [Success]: Got the ID [$id]');
  if (response.statusCode == 200) {
    print('Status [Success]: Specific Data Appended');
    return SpecificContact.fromJson(json.decode(response.body));
  } else {
    throw Exception('Status [Failed]: Cannot load Contact');
  }
}

class SpecificContact {
  SpecificContact({
    required this.phoneNumbers,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.v,
  });

  List<String> phoneNumbers;
  String id;
  String firstName;
  String lastName;
  int v;

  factory SpecificContact.fromJson(Map<String, dynamic> json) => SpecificContact(
        phoneNumbers: List<String>.from(json["phone_numbers"].map((x) => x)),
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        v: json["__v"],
      );
}

class UpdateContact extends StatefulWidget {
  final String specificID;

  const UpdateContact({Key? key, required this.specificID}) : super(key: key);

  @override
  _UpdateContactState createState() => _UpdateContactState(specificID);
}

class _UpdateContactState extends State<UpdateContact> {
  String specificID;

  _UpdateContactState(this.specificID);

  late Future<SpecificContact> futureSpecificContact;

  int checkAdd = 0, listNumber = 1, _count = 1;
  String val = '';
  RegExp digitValidator = RegExp("[0-9]+");
  bool defaultVal = true;
  bool isANumber = true;
  String fname = '', lname = '';

  var fnameController = TextEditingController();
  var lnameController = TextEditingController();

  List<TextEditingController> pnumControllers = <TextEditingController>[TextEditingController()];

  final FocusNode fnameFocus = FocusNode();
  final FocusNode lnameFocus = FocusNode();

  List<SpecificContact> contactsAppend = <SpecificContact>[];
  List<ContactData> contactsAppendSave = <ContactData>[];

  void saveContact() {
    List<String> pnums = <String>[];
    for (int i = 0; i < _count; i++) {
      pnums.add(pnumControllers[i].text);
    }
    List<String> reversedpnums = pnums.reversed.toList();
    setState(() {
      contactsAppendSave.insert(0, ContactData(lnameController.text, fnameController.text, reversedpnums));
    });
    print('Status Append Contacts [Success]');
  }

  @override
  void initState() {
    super.initState();
    _count = 1;
    futureSpecificContact = fetchSpecificContact(specificID);
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    for (int i = 0; i < _count; i++) {
      pnumControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Update Contact", style: TextStyle(color: Color(0xFF5B3415))),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  checkAdd = 0;
                  listNumber = 1;
                  _count = 1;
                  defaultVal = true;
                  fnameController.clear();
                  lnameController.clear();
                  pnumControllers.clear();
                  pnumControllers = <TextEditingController>[TextEditingController()];
                });
              },
            )
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<SpecificContact>(
              future: futureSpecificContact,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String? name1 = Text(snapshot.data!.firstName.toString()).data;
                  String? name2 = Text(snapshot.data!.lastName.toString()).data;
                  List<String> listPhonenums = <String>[];
                  for (int i = 0; i < snapshot.data!.phoneNumbers.length; i++) {
                    listPhonenums.add(snapshot.data!.phoneNumbers[i]);
                  }
                  List<String> reverseNumbers = listPhonenums.reversed.toList();
                  return namesForm(name1!, name2!, reverseNumbers, context);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B3415))));
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text("Are you sure?",
              style: TextStyle(
                color: Color(0xFF5B3415),
                fontWeight: FontWeight.bold,
              )),
          content: const Text("Go back to home and no changes will be made"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("CANCEL", style: TextStyle(color: Colors.redAccent))),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => DataFromAPI()), (_) => false);
              },
              child: const Text("CONFIRM", style: TextStyle(color: Color(0xFFFCC13A))),
            ),
          ],
        );
      },
    );
    return new Future.value(true);
  }

  namesForm(String contentFname, String contentLname, List<String> listPhonenums, context) {

    if (_count == 1) {
      fnameController = TextEditingController(text: contentFname);
      lnameController = TextEditingController(text: contentLname);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SizedBox(
        //padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Name: " + contentFname + " " + contentLname,
                style: TextStyle(color: Color(0xFF5B3415), fontWeight: FontWeight.bold, fontSize: 25)),
            SizedBox(
              height: 20,
            ),
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
                //errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                labelText: 'First name',
                suffixIcon: IconButton(
                  onPressed: fnameController.clear,
                  icon: Icon(Icons.cancel),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                labelText: 'Last Name',
                suffixIcon: IconButton(
                  onPressed: lnameController.clear,
                  icon: Icon(Icons.cancel),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Contact Number/s: $listNumber", style: TextStyle(color: Color(0xFF5B3415))),
            SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: _count,
                  itemBuilder: (context, index) {
                    return _row(index, listPhonenums, context);
                  }),
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: const Text("Confirm",
                          style: TextStyle(
                            color: Color(0xFF5B3415),
                            fontWeight: FontWeight.bold,
                          )),
                      content: const Text("Confirm changes?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("CANCEL", style: TextStyle(color: Colors.redAccent))),
                        TextButton(
                          onPressed: () {
                            saveContact();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                          todo: contactsAppendSave,
                                          specificID: specificID,
                                        )),
                                (_) => false);
                          },
                          child: const Text("CONFIRM", style: TextStyle(color: Color(0xFFFCC13A))),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.save),
              label: Text("Save Changes"),
              foregroundColor: Color(0xFFFCC13A),
              backgroundColor: Color(0xFF5B3415),
            ),
          ],
        ),
      ),
    );
  }
  _row(int key, List<String> listPhonenums, context) {

    if (_count >= 1 && _count <= listPhonenums.length && _count != key) {
      if (defaultVal == true) {
        pnumControllers[key] = TextEditingController(text: listPhonenums[key]);
        if (key == listPhonenums.length-1) {
          defaultVal = false;
        }
      }
    } else {
      defaultVal = false;
    }

    return new Row(
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
              disabledBorder: InputBorder.none,
              errorText: isANumber ? null : "Please enter a number",
              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              labelText: 'Phone number',
              suffixIcon: IconButton(
                onPressed: pnumControllers[key].clear,
                icon: Icon(Icons.cancel),
              ),
            ),
          ),
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

  void setValidator(valid) {
    setState(() {
      isANumber = valid;
    });
  }

  Widget _addRemoveButton(bool isTrue, int index) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (isTrue) {
          setState(() {
            _count++;
            checkAdd++;
            listNumber++;
            pnumControllers.insert(0, TextEditingController());
          });
        } else {
          setState(() {
            _count--;
            checkAdd--;
            listNumber--;
            pnumControllers.removeAt(index);
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: (isTrue) ? Color(0xFFFCC13A) : Colors.redAccent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          (isTrue) ? Icons.add : Icons.remove,
          color: Colors.white70,
        ),
      ),
    );
  }
}

_fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

