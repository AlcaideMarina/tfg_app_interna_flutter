import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class JobPositionModel {

  final String constantName;
  final String createdBy;
  final Timestamp creationDatetime;
  final String modifiedBy;
  final Timestamp modificationDatetime;
  final Map<int, String> values;

  JobPositionModel(
    this.constantName, 
    this.createdBy, 
    this.creationDatetime, 
    this.modifiedBy, 
    this.modificationDatetime, 
    this.values
  );

  factory JobPositionModel.fromJson(String str) => JobPositionModel.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory JobPositionModel.fromMap(Map<String, dynamic> json) { 
    
    Map<int, String> valuesMap = {};
    (json['values'] as Map<String, dynamic>).forEach((key, value) {
      int k = int.tryParse(key) ?? -1;
      valuesMap[k] = value;
    },);

    return JobPositionModel(
      json['constant_name'],
      json['created_by'],
      json['creation_datetime'],
      json['modified_by'],
      json['modification_datetime'],
      valuesMap,
    );
  }

  Map<String, dynamic> toMap() {
    // TODO: Investigar - ¿se puede hacer sin esta transformación?
    Map<String, dynamic> valuesMap = {};
    values.forEach((key, value) {
      valuesMap[key.toString()] = value;
    });
    return {
      'constat_name': constantName,
      'created_by': createdBy,
      'creation_datetime': creationDatetime,
      'modified_by': modifiedBy,
      'modification_datetime': modificationDatetime,
      'values': valuesMap,
    };
  }

}
