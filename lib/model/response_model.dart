import 'dart:convert';

List<ResponseModel> responseModelFromJson(String str) =>
    List<ResponseModel>.from(json.decode(str).map((x) => ResponseModel.fromJson(x)));

String responseModelToJson(List<ResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseModel {
  ResponseModel({
    required this.id,
    required this.userId,
    required this.requestId,
    required this.description,
  });

  int id;
  int userId;
  int requestId;
  String description;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    id: json["id"],
    userId: json["user_id"],
    requestId: json["request_id"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "request_id": requestId,
    "description": description,
  };
}
