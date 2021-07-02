// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
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

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    phoneNumbers: List<String>.from(json["phone_numbers"].map((x) => x)),
    id: json["_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "phone_numbers": List<dynamic>.from(phoneNumbers.map((x) => x)),
    "_id": id,
    "first_name": firstName,
    "last_name": lastName,
    "__v": v,
  };
}
