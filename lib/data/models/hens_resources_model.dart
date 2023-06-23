import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class HensResourcesModel {
  final String createdBy;
  final Timestamp creationDatetime;
  final bool deleted;
  final Timestamp expenseDatetime;
  final int hensNumber;
  final int shedA;
  final int shedB;
  final double totalPrice;
  final String? documentId;

  HensResourcesModel(
    this.createdBy,
    this.creationDatetime,
    this.deleted,
    this.expenseDatetime,
    this.hensNumber,
    this.shedA,
    this.shedB,
    this.totalPrice,
    this.documentId,
  );

  factory HensResourcesModel.fromJson(String str, String? docId) =>
      HensResourcesModel.fromMap(jsonDecode(str), docId);

  String toJson() => jsonEncode(toMap());

  factory HensResourcesModel.fromMap(Map<String, dynamic> json, String? docId) {
    return HensResourcesModel(
      json['created_by'],
      json['creation_datetime'],
      json['deleted'],
      json['expense_datetime'],
      json['hens_number'],
      json['shed_a'],
      json['shed_b'],
      json['total_price'],
      docId,
    );
  }

  Map<String, Object?> toMap() => {
        'created_by': createdBy,
        'creation_datetime': creationDatetime,
        'deleted': deleted,
        'expense_datetime': expenseDatetime,
        'hens_number': hensNumber,
        'shed_a': shedA,
        'shed_b': shedB,
        'total_price': totalPrice
      };
}
