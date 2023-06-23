import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class InternalUserModel {
  final int id;
  final String bankAccount;
  final String city;
  final String createdBy;
  final bool deleted;
  final String direction;
  final String dni;
  final String email;
  final String name;
  final int phone;
  final int position;
  final int postalCode;
  final String province;
  final double? salary;
  final int ssNumber;
  final String surname;
  final String? uid;
  final String user;
  final String? documentId;

  InternalUserModel(
      this.bankAccount,
      this.city,
      this.createdBy,
      this.deleted,
      this.direction,
      this.dni,
      this.email,
      this.id,
      this.name,
      this.phone,
      this.position,
      this.postalCode,
      this.province,
      this.salary,
      this.ssNumber,
      this.surname,
      this.uid,
      this.user,
      this.documentId);

  factory InternalUserModel.fromJson(String str, String? docId) =>
      InternalUserModel.fromMap(jsonDecode(str), docId);

  String toJson() => jsonEncode(toMap());

  factory InternalUserModel.fromMap(Map<String, dynamic> json, String? docId) {
    return InternalUserModel(
        json['bank_account'],
        json['city'],
        json['created_by'],
        json['deleted'],
        json['direction'],
        json['dni'],
        json['email'],
        json['id'],
        json['name'],
        json['phone'],
        json['position'],
        json['postal_code'],
        json['province'],
        json['salary'],
        json['ss_number'],
        json['surname'],
        json['uid'],
        json['user'],
        docId);
  }

  Map<String, dynamic> toMap() => {
        'bank_account': bankAccount,
        'city': city,
        'created_by': createdBy,
        'deleted': deleted,
        'direction': direction,
        'dni': dni,
        'email': email,
        'id': id,
        'name': name,
        'phone': phone,
        'position': position,
        'postal_code': postalCode,
        'province': province,
        'salary': salary,
        'ss_number': ssNumber,
        'surname': surname,
        'uid': uid,
        'user': user,
      };
}
