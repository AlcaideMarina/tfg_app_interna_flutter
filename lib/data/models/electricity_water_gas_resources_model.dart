import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ElectricityWaterGasResourcesModel {

  final String createdBy;
  final Timestamp creationDatetime;
  final bool deleted;
  final Timestamp expenseDatetime;
  final String notes;
  final double totalPrice;
  final int type;
  final String? documentId;

  ElectricityWaterGasResourcesModel(
    this.createdBy, 
    this.creationDatetime, 
    this.deleted, 
    this.expenseDatetime, 
    this.notes, 
    this.totalPrice, 
    this.type,
    this.documentId, 
  );

  factory ElectricityWaterGasResourcesModel.fromJson(String str, String? docId) =>
      ElectricityWaterGasResourcesModel.fromMap(jsonDecode(str), docId);
      
  String toJson() => jsonEncode(toMap());

   factory ElectricityWaterGasResourcesModel.fromMap(Map<String, dynamic> json, String? docId) {
    return ElectricityWaterGasResourcesModel(
        json['created_by'],
        json['creation_datetime'],
        json['deleted'],
        json['expense_datetime'],
        json['notes'],
        json['total_price'],
        json['type'],
        docId,
    );
  }

  Map<String, Object?> toMap() => {
    'created_by': createdBy,
    'creation_datetime': creationDatetime,
    'deleted': deleted,
    'expense_datetime': expenseDatetime,
    'notes': notes,
    'total_price': totalPrice,
    'type': type,
  };

}
