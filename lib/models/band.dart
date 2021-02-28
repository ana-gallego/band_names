import 'package:flutter/cupertino.dart';

class Band {
  String id;
  String name;
  int votes;

  Band({@required this.id, @required this.name, @required this.votes});

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
      id: obj['id'] ?? '', name: obj['name'] ?? '', votes: obj['votes'] ?? 0);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['votes'] = this.votes;
    return data;
  }
}
