import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class InternalUserModel {
  final String id;
  final String bankAccount;
  final String city;
  final String createdBy;
  final Timestamp creationDate;
  final String direction;
  final String dni;
  final String email;
  final String name;
  final int phone;
  final int position;
  final int postalCode;
  final String province;
  final bool sameDniDirection;    // TODO: Investigar - ¿este dato es necesario?
  final int ssNumber;
  final String surname;
  final String uid;
  final String user;
  final bool deleted;

  InternalUserModel(
    this.id, 
    this.bankAccount, 
    this.city, 
    this.createdBy, 
    this.creationDate, 
    this.direction, 
    this.dni, 
    this.email, 
    this.name, 
    this.phone, 
    this.position, 
    this.postalCode, 
    this.province, 
    this.sameDniDirection, 
    this.ssNumber, 
    this.surname, 
    this.uid, 
    this.user,
    this.deleted);

factory InternalUserModel.fromJson(String str) =>
      InternalUserModel.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory InternalUserModel.fromMap(Map<String, dynamic> json) {
    return InternalUserModel(
        json['id'],
        json['bank_account'],
        json['city'],
        json['created_by'],
        json['creation_date'],
        json['direction'],
        json['dni'],
        json['email'],
        json['name'],
        json['phone'],
        json['position'],
        json['postal_code'],
        json['province'],
        json['same_dni_direction'],
        json['ss_number'],
        json['surname'],
        json['uid'],
        json['user'],
        json['deleted']);
  }

  Map<String, dynamic> toMap() => {
        // TODO: ¿deberíamos añadir id? Entiendo que no porque no se guarda en bbdd como tal
        'id': id,
        'bankAccount': bankAccount,
        'city': city,
        'created_by': createdBy,
        'creation_date': creationDate,
        'direction': direction,
        'dni': dni,
        'email': email,
        'name': name,
        'phone': phone,
        'position': position,
        'postal_code': postalCode,
        'province': province,
        'same_dni_direction': sameDniDirection,
        'ss_number': ssNumber,
        'surname': surname,
        'uid': uid,
        'user': user,
        'deleted': deleted
      };
  
}