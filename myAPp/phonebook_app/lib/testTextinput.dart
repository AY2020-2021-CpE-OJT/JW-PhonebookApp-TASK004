import 'package:flutter/material.dart';

class testText extends StatefulWidget {

  @override
  _testTextState createState() => _testTextState();
}

class _testTextState extends State<testText> {

  @override
  Widget build(BuildContext context) {
    var stringListReturnedFromApiCall = ["first", "second", "third", "fourth", "..."];
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String,TextEditingController> textEditingControllers = {};
    var textFields = <TextField>[];
    stringListReturnedFromApiCall.forEach((str) {
      var textEditingController = new TextEditingController(text: str);
      textEditingControllers.putIfAbsent(str, ()=>textEditingController);
      return textFields.add( TextField(controller: textEditingController));
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: SingleChildScrollView(
            child: new Column(
                children:[
                  Column(children:  textFields),
                  RaisedButton(
                      child: Text("Print Values"),
                      onPressed: (){
                        stringListReturnedFromApiCall.forEach((str){
                          print(textEditingControllers[str]!.text);
                        });
                      })
                ]
            )));
  }
}