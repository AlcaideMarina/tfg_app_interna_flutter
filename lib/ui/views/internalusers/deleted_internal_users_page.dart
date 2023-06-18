import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/component_panel.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';

import '../../components/component_internal_users.dart';
import '../../../data/models/internal_user_model.dart';

class DeletedInternalUsersPage extends StatefulWidget {
  const DeletedInternalUsersPage(this.currentUser, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<DeletedInternalUsersPage> createState() =>
      _DeletedInternalUsersPageState();
}

class _DeletedInternalUsersPageState extends State<DeletedInternalUsersPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Cuentas eliminadas",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
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
                                      InternalUserModel.fromMap(
                                          userList[i].data()
                                              as Map<String, dynamic>,
                                          userList[i].id);
                                  if (internalUser.deleted) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 8),
                                      child: HNComponentInternalUsers(
                                          internalUser.id.toString(),
                                          internalUser.name +
                                              ' ' +
                                              internalUser.surname,
                                          internalUser.dni,
                                          internalUser.position),
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
                                  "No hay registro de usuarios internos eliminados en la base de datos.",
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
                                "No hay registro de usuarios internos eliminados en la base de datos.",
                          ));
                    }
                  } else {
                    return const CircularProgressIndicator(
                      color: CustomColors.redPrimaryColor,
                    );
                  }
                }),
          ],
        ));
  }
}
