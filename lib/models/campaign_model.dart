// To parse this JSON data, do
//
//     final campaigns = campaignsFromJson(jsonString);

import 'dart:convert';

List<Campaign> campaignsFromJson(String str) =>
    List<Campaign>.from(json.decode(str).map((x) => Campaign.fromJson(x)));

String campaignsToJson(List<Campaign> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Campaign {
  int? id;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic>? assignedTo;
  bool isManuallyCompleted;

  Campaign({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.assignedTo,
    required this.isManuallyCompleted,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    startDate:
        json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    assignedTo:
        json["assignedTo"] == null
            ? []
            : List<dynamic>.from(json["assignedTo"]!.map((x) => x)),
    isManuallyCompleted: json["isManuallyCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "assignedTo":
        assignedTo == null ? [] : List<dynamic>.from(assignedTo!.map((x) => x)),
    "isManuallyCompleted": isManuallyCompleted,
  };
}
