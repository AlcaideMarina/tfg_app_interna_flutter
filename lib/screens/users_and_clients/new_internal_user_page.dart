import 'package:flutter/material.dart';

import '../../model/current_user_model.dart';

class NewInternalUserPage extends StatefulWidget {
  NewInternalUserPage(this.currentUser, {Key? key}) : super(key: key);

  final CurrentUserModel currentUser;
  
  @override
  State<NewInternalUserPage> createState() => _NewInternalUserPageState();
}

class _NewInternalUserPageState extends State<NewInternalUserPage> {
  late CurrentUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  late String id;
  late String name;
  late String surname;
  late String dni;
  late int phone;
  late String email;
  late String direction;
  late String city;
  late String province;
  late int postalCode;
  late bool sameDniDirecion;
  late int ssNumber;
  late String bankAccount;
  late int jobPosition;   // TODO: Esto va a tener que ser un dropdown
  late bool hasAccount;
  late String user;
  late String accountEmail;
  late bool internalApplication;
  // TODO: Lista de persisos de la app interna
  late bool deliveryApplication;
  // TODO: Lista de persisos de la app de repartos
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}