import 'dart:convert';
import 'dart:developer' as developer;

class ClientModel {
  // TODO: Igual hay que mirar que el id sea nulable, porque incialmente no va a vernir en el map - o se 
  //      añade en el map antes de pasarlo a esta clase o se deja como nulable y se añade después
  final String id;
  final String company;
  final String direction;
  final String city;
  final String province;
  final int postalCode;
  final String cif;
  final String email;
  final List<Map<String, int>> phone;
  final Map<String, double> price;
  final bool hasAccount;
  final String? user;
  final String? emailAccount;
  final DateTime? creationDatetime;
  final String? createdBy;
  final String? uid;
  final bool deleted;

  const ClientModel(
    this.id,
    this.company,
    this.direction,
    this.city,
    this.province,
    this.postalCode,
    this.cif,
    this.email,
    this.phone, 
    this.price,
    this.hasAccount,
    this.user,
    this.emailAccount,
    this.creationDatetime,
    this.createdBy,
    this.uid,
    this.deleted
  );

  factory ClientModel.fromJson(String str) => ClientModel.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory ClientModel.fromMap(Map<String, dynamic> json) {

    List<Map<String, int>> phoneMap = [];
    (json['phone'] as List<dynamic>).forEach((element) {
      try {
        (element as Map<String, dynamic>).forEach((key, value) {
          phoneMap.add({key: element[key]});
        });
      } catch (e) {
        phoneMap.add({'no-info': 0});
        developer.log('Error - ClientModel - ClientModel.fromMap() - phones: ' + e.toString());
      }
    });

    Map<String, double> priceMap = {};
    (json['price'] as Map<String, dynamic>).forEach((key, value) {
      try {
        priceMap[key] = value.toDouble();
      } catch (e) {
        priceMap[key] = 0.0;
        developer.log('Error - ClientModel - ClientModel.fromMap() - prices: ' + e.toString());
      }
    },);

    return ClientModel(
      json['id'],
      json['company'],
      json['direction'],
      json['city'],
      json['province'],
      json['postal_code'],
      json['cif'],
      json['email'],
      phoneMap,
      priceMap,
      json['has_account'],
      json['user'],
      json['email_account'],
      json['creation_datetime'],
      json['created_by'],
      json['uid'],
      json['deleted']
    );
  }

  Map<String, dynamic> toMap() => {
    // TODO: ¿deberíamos añadir id? Entiendo que no porque no se guarda en bbdd como tal
    'company': company,
    'direction': direction,
    'city': city,
    'province': province,
    'postal_code': postalCode,
    'cif': cif,
    'email': email,
    'phone': phone,
    'price': price,
    'has_account': hasAccount,
    'user': user,
    'email_account': emailAccount,
    'creation_datetime': creationDatetime,
    'created_by': createdBy,
    'uid': uid,
    'deleted': deleted
  };
}