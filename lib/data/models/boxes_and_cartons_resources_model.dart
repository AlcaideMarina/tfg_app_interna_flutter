import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BoxesAndCartonsResourcesModel {
  final String createdBy;
  final Timestamp creationDatetime;
  final bool deleted;
  final Timestamp expenseDatetime;
  final Map<String, dynamic> order;
  final double totalPrice;
  final String? documentId;

  BoxesAndCartonsResourcesModel(
      this.createdBy,
      this.creationDatetime,
      this.deleted,
      this.expenseDatetime,
      this.order,
      this.totalPrice,
      this.documentId);

  factory BoxesAndCartonsResourcesModel.fromJson(String str, String? docId) =>
      BoxesAndCartonsResourcesModel.fromMap(jsonDecode(str), docId);

  String toJson() => jsonEncode(toMap());

  factory BoxesAndCartonsResourcesModel.fromMap(
      Map<String, dynamic> json, String? docId) {
    Map<String, int> orderFromJson = {};
    for (var key in (json['order'] as Map<String, dynamic>).keys) {
      int? value = json['order'][key] is int ? json['order'][key] : null;
      if (value != null) orderFromJson[key] = value;
    }

    return BoxesAndCartonsResourcesModel(
      json['created_by'],
      json['creation_datetime'],
      json['deleted'],
      json['expense_datetime'],
      orderFromJson,
      json['total_price'],
      docId,
    );
  }

  Map<String, Object?> toMap() => {
        'created_by': createdBy,
        'creation_datetime': creationDatetime,
        'deleted': deleted,
        'expense_datetime': expenseDatetime,
        'order': order,
        'total_price': totalPrice
      };
}
