import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_clients.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/flutterfire/flutterfire.dart';
import 'package:hueveria_nieto_interna/model/client_model.dart';
import 'package:hueveria_nieto_interna/model/current_user_model.dart';
import 'package:hueveria_nieto_interna/screens/users_and_clients/new_client_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

class AllClientsPage extends StatefulWidget {
  const AllClientsPage(this.currentUser, {Key? key}) : super(key: key);

  final CurrentUserModel currentUser;

  @override
  State<AllClientsPage> createState() => _AllClientsPageState();
}

class _AllClientsPageState extends State<AllClientsPage> {
  late CurrentUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    Firebase
        .initializeApp(); // TODO: Investigar si esto se puede quitar o poner de forma global
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Ver clientes",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 56, vertical: 8),
              child: Column(
                children: [
                  HNButton(ButtonTypes.redWhiteBoldRoundedButton)
                      .getTypedButton(
                          "Nuevo", null, null, navigateToNewClientPage, () {}),
                  const SizedBox(
                    height: 8,
                  ),
                  HNButton(ButtonTypes.grayBlackRoundedButton).getTypedButton(
                      "Cuentas eliminadas", null, null, () {}, () {})
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder(
                stream: getActiveClients(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List clientList = data.docs;
                      return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: clientList.length,
                              itemBuilder: (context, i) {
                                final ClientModel client = ClientModel.fromMap(
                                    clientList[i].data()
                                        as Map<String, dynamic>);
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 8),
                                  child: HNComponentClients(
                                      client.id,
                                      client.company,
                                      client.cif,
                                      "TODO"), // TODO: Falta por hacer la parte de pedidos
                                );
                              }));
                    } else if (snapshot.hasError) {
                      // TODO: mensaje de error
                    } else {
                      // TODO: mensaje de que no hay info
                    }
                  }
                  return const CircularProgressIndicator(
                    color: CustomColors.redPrimaryColor,
                  );
                }),
          ],
        ));
  }

  navigateToNewClientPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewClientPage(currentUser),
        ));
  }
}
