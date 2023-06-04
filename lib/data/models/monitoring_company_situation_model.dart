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
    Map<String, int> hens = {};
    (json['hens'] as Map<String, dynamic>).forEach((key, value) => hens[key] = value as int);
    Map<String, int> xlEggs = {};
    (json['xl_eggs'] as Map<String, dynamic>).forEach((key, value) => xlEggs[key] = value as int);
    Map<String, int> lEggs = {};
    (json['l_eggs'] as Map<String, dynamic>).forEach((key, value) => lEggs[key] = value as int);
    Map<String, int> mEggs = {};
    (json['m_eggs'] as Map<String, dynamic>).forEach((key, value) => mEggs[key] = value as int);
    Map<String, int> sEggs = {};
    (json['s_eggs'] as Map<String, dynamic>).forEach((key, value) => sEggs[key] = value as int);
    return MonitoringCompanySituationModel(
        json['broken_eggs'],
        json['created_by'],
        json['creation_datetime'],
        hens,
        lEggs,
        mEggs,
        sEggs,
        json['situation_datetime'],
        xlEggs,
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
