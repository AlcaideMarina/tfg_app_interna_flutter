import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MonitoringCompanySituationModel {

  final int brokenEggs;
  final String? createdBy;
  final Timestamp? creationDatetime;
  final Map<String, int> hens;
  final Map<String, int> lEggs;
  final Map<String, int> mEggs;
  final Map<String, int> sEggs;
  final Timestamp situationDatetime;
  final Map<String, int> xlEggs;
  final String? documentId;

  MonitoringCompanySituationModel(
    this.brokenEggs, 
    this.createdBy, 
    this.creationDatetime, 
    this.hens, 
    this.lEggs, 
    this.mEggs, 
    this.sEggs, 
    this.situationDatetime, 
    this.xlEggs, 
    this.documentId
  );

  factory MonitoringCompanySituationModel.fromJson(String str, String? docId) =>
      MonitoringCompanySituationModel.fromMap(jsonDecode(str), docId);

  String toJson() => jsonEncode(toMap());

  factory MonitoringCompanySituationModel.fromMap(Map<String, dynamic> json, String? docId) {
    return MonitoringCompanySituationModel(
        json['broken_eggs'],
        json['created_by'],
        json['creation_datetime'],
        json['hens'],
        json['l_eggs'],
        json['m_eggs'],
        json['s_eggs'],
        json['situation_datetime'],
        json['xl_eggs'],
        docId);
  }

  Map<String, dynamic> toMap() => {
    'broken_eggs': brokenEggs,
    'created_by': createdBy,
    'creation_datetime': creationDatetime,
    'hens': hens,
    'l_eggs': lEggs,
    'm_eggs': mEggs,
    's_eggs': sEggs,
    'situation_datetime': situationDatetime,
    'xl_eggs': xlEggs
  };

}
