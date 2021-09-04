import 'package:flutter/cupertino.dart';

class CountryModel {
  String id;
  String name;
  List<dynamic> cities;
  CountryModel({
    // @required this.id,
    @required this.name,
    @required this.cities,
  });

  CountryModel.fromJson(Map map) {
    this.id = map['id'];
    this.name = map['name'];
    this.cities = map['cities'];
  }
}
