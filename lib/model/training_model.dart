// To parse this JSON data, do
//
//     final listTraining = listTrainingFromJson(jsonString);

import 'dart:convert';

ListTraining listTrainingFromJson(String str) =>
    ListTraining.fromJson(json.decode(str));

String listTrainingToJson(ListTraining data) => json.encode(data.toJson());

class ListTraining {
  String? message;
  List<Datum>? data;

  ListTraining({this.message, this.data});

  factory ListTraining.fromJson(Map<String, dynamic> json) => ListTraining(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? title;

  Datum({this.id, this.title});

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
