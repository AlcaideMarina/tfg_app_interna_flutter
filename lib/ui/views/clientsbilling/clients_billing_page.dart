import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/component_client_billing.dart';
import 'package:hueveria_nieto_interna/ui/views/clientsbilling/billing_per_month_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';

class ClientsBillingPage extends StatefulWidget {
  const ClientsBillingPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<ClientsBillingPage> createState() => _ClientsBillingPageState();
}

class _ClientsBillingPageState extends State<ClientsBillingPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "Facturación de clientes",
            style: TextStyle(fontSize: 18),
          )),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseUtils.instance.getClients(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                final ClientModel client = ClientModel.fromMap(
                                    clientList[i].data()
                                        as Map<String, dynamic>,
                                    clientList[i].id);
                                double top = 8;
                                double bottom = 0;
                                if (i == 0) top = 16;
                                if (i == clientList.length - 1) bottom = 16;
                                if (!client.deleted) {
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                                    child: HNComponentClientBilling(
                                      client.id.toString(),
                                      client.company,
                                      onTap: () {
                                        navigateToBillingPerMonth(client);
                                      },
                                    ),
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
      ),
    );
  }

  navigateToBillingPerMonth(ClientModel clientModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BillingPerMonthPage(currentUser, clientModel)));
  }
}
