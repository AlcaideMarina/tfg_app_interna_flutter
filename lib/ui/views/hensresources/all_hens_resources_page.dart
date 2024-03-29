import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/hens_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/components/component_ticket.dart';
import 'package:hueveria_nieto_interna/ui/views/hensresources/hens_resources_detail_page.dart';
import 'package:hueveria_nieto_interna/ui/views/hensresources/new_hens_resource_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';

class AllHensResourcesPage extends StatefulWidget {
  const AllHensResourcesPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<AllHensResourcesPage> createState() => _AllHensResourcesPageState();
}

class _AllHensResourcesPageState extends State<AllHensResourcesPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<HensResourcesModel> list = [];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "Registro gallinas",
            style: TextStyle(fontSize: 18),
          )),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseUtils.instance
                  .getAllResourceDocuments("material_hens"),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    final List hensList = data.docs;
                    if (hensList.isNotEmpty) {
                      return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: hensList.length,
                              itemBuilder: (context, i) {
                                final HensResourcesModel hensModel =
                                    HensResourcesModel.fromMap(
                                        hensList[i].data()
                                            as Map<String, dynamic>,
                                        hensList[i].id);
                                if (!hensModel.deleted) {
                                  list.add(hensModel);
                                  double top = 8;
                                  double bottom = 0;
                                  if (list.length == 1) top = 24;
                                  if (i == hensList.length - 1) bottom = 16;
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                                    child: HNComponentTicket(
                                        hensModel.expenseDatetime,
                                        hensModel.hensNumber.toString(),
                                        hensModel.totalPrice,
                                        units: "gallinas", onTap: () {
                                      navigateToHensResourcesDetail(hensModel);
                                    }),
                                  );
                                } else {
                                  if (i == (hensList.length - 1) &&
                                      list.isEmpty) {
                                    return Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            32, 56, 32, 8),
                                        child: const HNComponentPanel(
                                          title: 'No hay recursos',
                                          text:
                                              "No hay registro de recursos de gallinas sin eliminar en la base de datos.",
                                        ));
                                  } else {
                                    return Container();
                                  }
                                }
                              }));
                    } else {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                          child: const HNComponentPanel(
                            title: 'No hay recursos',
                            text:
                                "No hay registro de recursos de gallinas sin eliminar en la base de datos.",
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
                          title: 'No hay recursos',
                          text:
                              "No hay registro de recursos de gallinas sin eliminar en la base de datos.",
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.redPrimaryColor,
          child: const Icon(Icons.add_rounded),
          onPressed: navigateToNewHensTicker),
    );
  }

  navigateToNewHensTicker() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewHensResourcePage(currentUser),
        ));
  }

  navigateToHensResourcesDetail(HensResourcesModel hensResourcesModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HensResourcesDetailPage(currentUser, hensResourcesModel),
        ));
  }
}
