import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'CheckScreen.dart';

class ContactData {
  final String lastName;
  final String firstName;
  final List<String> phoneNumbers;

  ContactData(this.lastName, this.firstName, this.phoneNumbers);
}

class CreateNewContact extends StatefulWidget {
  @override
  _CreateNewContactState createState() => _CreateNewContactState();
}

class _CreateNewContactState extends State<CreateNewContact> {
  int key = 0, checkAdd = 0, listNumber = 1, _count = 1;
  String val = '';
  RegExp digitValidator = RegExp("[0-9]+");

  bool isANumber = true;
  String fname = '', lname = '';

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  List<TextEditingController> pnumControllers = <TextEditingController>[
    TextEditingController()
  ];

  final FocusNode fnameFocus = FocusNode();
  final FocusNode lnameFocus = FocusNode();

  List<ContactData> contactsAppend = <ContactData>[];

  void saveContact() {
    List<String> pnums = <String>[];
    for (int i = 0; i < _count; i++) {
      pnums.add(pnumControllers[i].text);
    }
    List<String> reversedpnums = pnums.reversed.toList();
    setState(() {
      contactsAppend.insert(0, ContactData(lnameController.text, fnameController.text, reversedpnums));
    });
    print('Status Append Contacts [Success]');
  }

  @override
  void initState() {
    super.initState();
    _count = 1;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New", style: TextStyle(color: Color(0xFF5B3415))),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                key = 0;
                checkAdd = 0;
                listNumber = 1;
                _count = 1;
                fnameController.clear();
                lnameController.clear();
                pnumControllers.clear();
                pnumControllers = <TextEditingController>[
                  TextEditingController()
                ];
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
                  //errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  labelText: 'First name',

                  suffixIcon: IconButton(
                    onPressed: fnameController.clear,
                    icon: Icon(Icons.cancel),
                  ),
                ),
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
                  //errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  labelText: 'Last Name',
                  suffixIcon: IconButton(
                    onPressed: lnameController.clear,
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Contact Number/s: $listNumber",
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
              //Text(_result),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
                content: const Text("Confirm creating this contact"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("CANCEL",
                          style: TextStyle(color: Colors.redAccent))),
                  TextButton(
                    onPressed: () {
                      saveContact();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CheckScreen(todo: contactsAppend)),
                          (_) => false);
                    },
                    child: const Text("CONFIRM",
                        style: TextStyle(color: Color(0xFFFCC13A))),
                  ),
                ],
              );
            },
          );
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
              // errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorText: isANumber ? null : "Please enter a number",
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
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

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

