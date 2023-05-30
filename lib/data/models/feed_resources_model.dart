import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FeedResourcesModel {

  final String createdBy;
  final Timestamp creationDatetime;
  final bool deleted;
  final Timestamp expenseDatetime;
  final double kilos;
  final double totalPrice;
  final String? documentId;

  FeedResourcesModel(
    this.createdBy, 
    this.creationDatetime, 
    this.deleted, 
    this.expenseDatetime, 
    this.kilos, 
    this.totalPrice, 
    this.documentId
  );

  factory FeedResourcesModel.fromJson(String str, String? docId) =>
      FeedResourcesModel.fromMap(jsonDecode(str), docId);
      
  String toJson() => jsonEncode(toMap());

  factory FeedResourcesModel.fromMap(Map<String, dynamic> json, String? docId) {
    return FeedResourcesModel(
        json['created_by'],
        json['creation_datetime'],
        json['deleted'],
        json['expense_datetime'],
        json['kilos'],
        json['total_price'],
        docId,
    );
  }

  Map<String, Object?> toMap() => {
    'created_by': createdBy,
    'creation_datetime': creationDatetime,
    'deleted': deleted,
    'expense_datetime': expenseDatetime,
    'kilos': kilos,
    'total_price': totalPrice
  };


}