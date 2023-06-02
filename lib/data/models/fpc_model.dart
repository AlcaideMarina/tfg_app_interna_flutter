import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FPCModel {

  final int acceptedEggs;
  final Timestamp bestBeforeDatetime;
  final String createdBy;
  final Timestamp creationDatetime;
  final bool deleted;
  final Timestamp issueDatetime;
  final Timestamp layingDatetime;
  final int lot;
  final Timestamp packingDatetime;
  final int rejectedEggs;
  final String? documentId;

  FPCModel(
    this.acceptedEggs, 
    this.bestBeforeDatetime, 
    this.createdBy, 
    this.creationDatetime, 
    this.deleted, 
    this.issueDatetime, 
    this.layingDatetime, 
    this.lot, 
    this.packingDatetime, 
    this.rejectedEggs, 
    this.documentId
  );

  factory FPCModel.fromJson(String str, String? docId) =>
      FPCModel.fromMap(jsonDecode(str), docId);
      
  String toJson() => jsonEncode(toMap());

  factory FPCModel.fromMap(Map<String, dynamic> json, String? docId) {
    return FPCModel(
        json['accepted_eggs'],
        json['best_before_datetime'],
        json['created_by'],
        json['creation_datetime'],
        json['deleted'],
        json['issue_datetime'],
        json['laying_datetime'],
        json['lot'],
        json['packing_datetime'],
        json['rejected_eggs'],
        docId,
    );
  }

  Map<String, Object?> toMap() => {
    'accepted_eggs': acceptedEggs,
    'best_before_datetime': bestBeforeDatetime,
    'created_by': createdBy,
    'creation_datetime': creationDatetime,
    'deleted': deleted,
    'issue_datetime': issueDatetime,
    'laying_datetime': layingDatetime,
    'lot': lot,
    'packing_datetime': packingDatetime,
    'rejected_eggs': rejectedEggs
  };

}