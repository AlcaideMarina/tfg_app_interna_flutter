import 'dart:convert';

class CurrentUserModel {
  final String documentId;
  final String uid;
  final String visibleID;
  final String name;
  final String surname;
  final String dni;
  final int phone;
  final String email;
  final String direction;
  final String city;
  final String province;
  final int postalCode;
  final bool sameDniDirection;
  final int ssNumber;
  final String bankAccount;
  final int position;
  final String user;
  // Lista de permisos app interna
  // Lista de permisos app repartos

  const CurrentUserModel(
  // TODO: Igual hay que mirar que el documentId sea nulable, porque incialmente no va a vernir en el map - o se 
  //      añade en el map antes de pasarlo a esta clase o se deja como nulable y se añade después
    this.documentId,
    this.uid,
    this.visibleID,
    this.name,
    this.surname,
    this.dni,
    this.phone,
    this.email,
    this.direction,
    this.city,
    this.province,
    this.postalCode,
    this.sameDniDirection,
    this.ssNumber,
    this.bankAccount,
    this.position,
    this.user
  );

  factory CurrentUserModel.fromJson(String str) => CurrentUserModel.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory CurrentUserModel.fromMap(Map<String, dynamic> json) => CurrentUserModel(
    json['document_id'],
    json['uid'],
    json['visible_id'],
    json['name'],
    json['surname'],
    json['dni'],
    json['phone'],
    json['email'],
    json['direction'],
    json['city'],
    json['province'],
    json['postal_code'],
    json['same_dni_direction'],
    json['ss_number'],
    json['bank_account'],
    json['position'],
    json['user']
  );

  Map<String, dynamic> toMap() => {
    // TODO: ¿deberíamos añadir documentId? Entiendo que no porque no se guarda en bbdd como tal
    'uid': uid,
    'visible_id': visibleID,
    'name': name,
    'surname': surname,
    'dni': dni,
    'phone': phone,
    'email': email,
    'direction': direction,
    'city': city,
    'province': province,
    'postal_code': postalCode,
    'same_dni_direction': sameDniDirection,
    'ss_number': ssNumber,
    'bank_account': bankAccount,
    'position': position,
    'user': user
  };
}