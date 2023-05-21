import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  // TODO: Igual hay que mirar que el DOCUMENT_ID sea nulable, porque incialmente no va a vernir en el map - o se
  //      añade en el map antes de pasarlo a esta clase o se deja como nulable y se añade después
  final int id;
  final String company;
  final String direction;
  final String city;
  final String province;
  final int postalCode;
  final String cif;
  final String email;
  final List<Map<String, int>> phone;
  final bool hasAccount;
  final String? user;
  final String? createdBy;
  final String? uid;
  final bool deleted;
  String? documentId;   // TODO: Investigar - ¿nulable?

  ClientModel(
      this.cif,
      this.city,
      this.company,
      this.createdBy,
      this.deleted,
      this.direction,
      this.email,
      this.hasAccount,
      this.id,
      this.phone,
      this.postalCode,
      this.province,
      this.uid,
      this.user,
      this.documentId);

  factory ClientModel.fromJson(String str, String? docId) =>
      ClientModel.fromMap(jsonDecode(str), docId);

  String toJson() => jsonEncode(toMap());

  factory ClientModel.fromMap(Map<String, dynamic> json, String? docId) {
    List<Map<String, int>> phoneMap = [];
    (json['phone'] as List<dynamic>).forEach((element) {
      try {
        (element as Map<String, dynamic>).forEach((key, value) {
          phoneMap.add({key: element[key]});
        });
      } catch (e) {
        phoneMap.add({'no-info': 0});
        developer.log('Error - ClientModel - ClientModel.fromMap() - phones: ' +
            e.toString());
      }
    });

    // TODO: Investigar - ¿Deberíamos meter documentId?
    return ClientModel(
        json['cif'],
        json['city'],
        json['company'],
        json['created_by'],
        json['deleted'],
        json['direction'],
        json['email'],
        json['has_account'],
        json['id'],
        phoneMap,
        json['postal_code'],
        json['province'],
        json['uid'],
        json['user'],
        docId);
  }

  Map<String, dynamic> toMap() => {
        'cif': cif,
        'city': city,
        'created_by': createdBy,
        'company': company,
        'deleted': deleted,
        'direction': direction,
        'email': email,
        'has_account': hasAccount,
        'id': id,
        'phone': phone,
        'postal_code': postalCode,
        'province': province,
        'uid': uid,
        'user': user,
      };
}
