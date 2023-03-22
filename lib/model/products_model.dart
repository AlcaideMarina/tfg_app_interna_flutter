import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {

  final String constantName;
  final String createdBy;
  final Timestamp creationDatetime;
  final String modifiedBy;
  final Timestamp modificationDatetime;
  final Map<String, double> values;

  ProductsModel(
    this.constantName, 
    this.createdBy, 
    this.creationDatetime, 
    this.modifiedBy, 
    this.modificationDatetime, 
    this.values
  );

  factory ProductsModel.fromJson(String str) => ProductsModel.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory ProductsModel.fromMap(Map<String, dynamic> json) { 
    
    Map<String, double> valuesMap = {};
    (json['values'] as Map<String, dynamic>).forEach((key, value) {
      try {
        valuesMap[key] = value.toDouble();
      } catch (e) {
        valuesMap[key] = 0.0;
        developer.log('Error - ProductsModel - ProductsModel.fromMap(): ' + e.toString());
      }
    },);

    return ProductsModel(
      json['constant_name'],
      json['created_by'],
      json['creation_datetime'],
      json['modified_by'],
      json['modification_datetime'],
      valuesMap,
    );
  }

  Map<String, dynamic> toMap() => {
    'constat_name': constantName,
    'created_by': createdBy,
    'creation_datetime': creationDatetime,
    'modified_by': modifiedBy,
    'modification_datetime': modificationDatetime,
    'values': values,
  };

}