import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/component_clients.dart';
import 'package:hueveria_nieto_interna/ui/components/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/ui/views/clients/detail_client_page.dart';
import 'package:hueveria_nieto_interna/ui/views/clients/new_client_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

import '../../components/component_panel.dart';
import '../../../data/models/internal_user_model.dart';
import 'deleted_clients_page.dart';

class AllClientsPage extends StatefulWidget {
  const AllClientsPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<AllClientsPage> createState() => _AllClientsPageState();
}

class _AllClientsPageState extends State<AllClientsPage> {
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
                      "Clientes eliminadas",
                      null,
                      null,
                      navigateToDeletedClientsPage,
                      () {})
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder(
                stream: FirebaseUtils.instance.getClients(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List clientList = data.docs;
                      if (clientList.isNotEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: clientList.length,
                                itemBuilder: (context, i) {
                                  final ClientModel client =
                                      ClientModel.fromMap(clientList[i].data()
                                          as Map<String, dynamic>, clientList[i].id);
                                  if (!client.deleted) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 8),
                                        child: HNComponentClients(
                                            client.id.toString(),
                                            client.company,
                                            client.cif,
                                            onTap: () => navigateToDetailClientsPage(client),),
                                      );
                                  } else {
                                    return Container();
                                  }
                                }));
                      } else {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                            child: const HNComponentPanel(
                              title: 'No hay clientes',
                              text:
                                  "No hay registro de clientes activos en la base de datos.",
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
                            title: 'No hay clientes',
                            text:
                                "No hay registro de clientes activos en la base de datos.",
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

  navigateToNewClientPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewClientPage(currentUser),
        ));
  }

  navigateToDeletedClientsPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeletedClientsPage(currentUser),
        ));
  }

  navigateToDetailClientsPage(ClientModel client) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => ClientDetailPage(currentUser, client)));
  }
}