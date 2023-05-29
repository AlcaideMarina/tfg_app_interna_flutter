import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/Utils.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/electricity_water_gas_resources_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';
import '../../components/component_ticket.dart';

class AllElectricityWaterGasResourcesPage extends StatefulWidget {
  const AllElectricityWaterGasResourcesPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<AllElectricityWaterGasResourcesPage> createState() => _AllElectricityWaterGasResourcesPageState();
}

class _AllElectricityWaterGasResourcesPageState extends State<AllElectricityWaterGasResourcesPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
  }
  
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<ElectricityWaterGasResourcesModel> list = [];
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Recursos - Elec., agua, gas",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseUtils.instance.getAllResourceDocuments("material_electricity_water_gas"),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List ewgList = data.docs;
                      if (ewgList.isNotEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: ewgList.length,
                                itemBuilder: (context, i) {
                                  final ElectricityWaterGasResourcesModel ewgModel =
                                      ElectricityWaterGasResourcesModel.fromMap(ewgList[i].data()
                                          as Map<String, dynamic>, ewgList[i].id);
                                  if (!ewgModel.deleted) {
                                      list.add(ewgModel);
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 8),
                                        child: HNComponentTicket(
                                            ewgModel.expenseDatetime,
                                            Utils().getKey(Constants().ewgTypes, ewgModel.type),
                                            ewgModel.totalPrice,
                                            onTap: () {}),
                                      );
                                  } else {
                                    if (i == (ewgList.length - 1) && list.isEmpty) {
                                      return Container(
                                        margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                                        child: const HNComponentPanel(
                                          title: 'No hay usuarios',
                                          text:
                                              "No hay registro de usuarios internos activos en la base de datos.",
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.redPrimaryColor,
          child: const Icon(Icons.add_rounded),
          onPressed: () {}
        ),
    );
  }
}
