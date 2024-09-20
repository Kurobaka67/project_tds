import 'dart:convert';

List<RequestModel> requestModelFromJson(String str) =>
    List<RequestModel>.from(json.decode(str).map((x) => RequestModel.fromJson(x)));

String requestModelToJson(List<RequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestModel {
  RequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.person,
    required this.response,
  });

  int id;
  String title;
  String description;
  String person;
  List response;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    person: json["person"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "person": person,
    "response": response,
  };
}
