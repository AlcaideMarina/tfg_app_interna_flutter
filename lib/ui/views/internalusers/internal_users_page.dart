import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/component_clients.dart';
import 'package:hueveria_nieto_interna/ui/components/component_internal_users.dart';
import 'package:hueveria_nieto_interna/ui/components/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/internalusers/deleted_internal_users_page.dart';
import 'package:hueveria_nieto_interna/ui/views/clients/detail_client_page.dart';
import 'package:hueveria_nieto_interna/ui/views/clients/new_client_page.dart';
import 'package:hueveria_nieto_interna/ui/views/internalusers/new_internal_user_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

import '../../components/component_panel.dart';
import '../clients/deleted_clients_page.dart';

class InternalUsersPage extends StatefulWidget {
  const InternalUsersPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<InternalUsersPage> createState() => _InternalUsersPageState();
}

class _InternalUsersPageState extends State<InternalUsersPage> {
  late InternalUserModel currentUser;

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
              "Ver usuarios internos",
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
                          "Nuevo", null, null, navigateToNewInternalUserPage, () {}),
                  const SizedBox(
                    height: 8,
                  ),
                  HNButton(ButtonTypes.grayBlackRoundedButton).getTypedButton(
                      "Cuentas eliminadas",
                      null,
                      null,
                      navigateToDeletedInternalUsersPage,
                      () {})
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder(
                stream: FirebaseUtils.instance.getInternalUsers(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List userList = data.docs;
                      if (userList.isNotEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: userList.length,
                                itemBuilder: (context, i) {
                                  final InternalUserModel internalUser =
                                      InternalUserModel.fromMap(userList[i].data()
                                          as Map<String, dynamic>, userList[i].id);
                                  if (!internalUser.deleted) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 8),
                                      child: HNComponentInternalUsers(
                                          internalUser.id.toString(),
                                          internalUser.name + ' ' + internalUser.surname,
                                          internalUser.dni,
                                          internalUser.position,
                                          onTap: () {}),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }));
                      } else {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                            child: const HNComponentPanel(
                              title: 'No hay usuarios',
                              text:
                                  "No hay registro de usuarios internos activos en la base de datos.",
                            ));
                      }
                    } else if (snapshot.hasError) {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                          child: const HNComponentPanel(
                            title: 'Ha ocurrido un error',
                            text:
                                "Lo sentimos, pero ha habido un error al intentar recuperar los datos. Por favor, inténtelo de nuevo más tarde.",
                          ));
                    } else {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                          child: const HNComponentPanel(
                            title: 'No hay usuarios',
                            text:
                                "No hay registro de usuarios internos activos en la base de datos.",
                          ));
                    }
                  }
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.redPrimaryColor,
                      ),
                    ),
                  );
                }),
          ],
        ));
  }

  navigateToDeletedInternalUsersPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeletedInternalUsersPage(currentUser),
        ));
  }

  navigateToNewInternalUserPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewInternalUserPage(currentUser),
        ));
  }

}
