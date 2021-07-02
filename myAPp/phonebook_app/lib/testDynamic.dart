import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contactModel.dart';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _testState extends State<test> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  ContactModel? _contactModel;
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final phonenumController = TextEditingController();

  postData() async {
    try {
      var response = await http.post(
          Uri.parse("https://jwa-phonebook-api.herokuapp.com/contacts/new"),
          body: {
            "first_name": "Test",
            "last_name": "Amigo",
            "phone_numbers": "123"
          });
      print(response.body);
    } catch (e) {
      print (e);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fnameController.dispose();
    lnameController.dispose();
    phonenumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New", style: TextStyle(color: Color(0xFF5B3415))),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: fnameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'First name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: lnameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Last name'),
              ),
              SizedBox(height: 20),
              Text("Contact Number/s",
                  style: TextStyle(color: Color(0xFF5B3415))),
              SizedBox(height: 20),
              TextField(
                controller: phonenumController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Number'),
              ),
              ElevatedButton(onPressed: () {}, child: Text('Add')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          String firstname = fnameController.text;
          String lastname = lnameController.text;
          String phonenum = phonenumController.text;

          //ContactModel? data = await createData(firstname, lastname, phonenum);
          //_contactModel = data;

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(lnameController.text +
                    fnameController.text +
                    phonenumController.text),
              );
            },
          );postData();
        },
        icon: Icon(Icons.save),
        label: Text("Save"),
        foregroundColor: Color(0xFFFCC13A),
        backgroundColor: Color(0xFF5B3415),
      ),
    );
  }
}
