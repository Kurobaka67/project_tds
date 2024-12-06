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
    required this.userId,
  });

  int id;
  String title;
  String description;
  int userId;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "user_id": userId,
  };
}
