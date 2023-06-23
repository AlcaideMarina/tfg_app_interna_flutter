import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/fpc_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/data/models/local/monthly_fpc_container_data.dart';
import 'package:hueveria_nieto_interna/ui/components/component_daily_final_product_control.dart';
import 'package:hueveria_nieto_interna/ui/views/finalproductcontrol/daily_deleted_final_product_control_page.dart';
import 'package:hueveria_nieto_interna/ui/views/finalproductcontrol/final_product_control_detail_page.dart';
import 'package:hueveria_nieto_interna/ui/views/finalproductcontrol/new_final_product_control_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';
import '../../components/constants/hn_button.dart';

class DailyFinalProductControlPage extends StatefulWidget {
  const DailyFinalProductControlPage(
      this.currentUser, this.monthlyFPCContainerData,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final MonthlyFPCContainerData monthlyFPCContainerData;

  @override
  State<DailyFinalProductControlPage> createState() =>
      _DailyFinalProductControlPageState();
}

class _DailyFinalProductControlPageState
    extends State<DailyFinalProductControlPage> {
  late InternalUserModel currentUser;
  late MonthlyFPCContainerData monthlyFPCContainerData;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    monthlyFPCContainerData = widget.monthlyFPCContainerData;
  }

  List<FPCModel> deletedList = [];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    deletedList = [];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "Control prod. final - Diario",
            style: TextStyle(fontSize: 18),
          )),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: HNButton(ButtonTypes.redWhiteBoldRoundedButton)
                .getTypedButton(
                    "Eliminados", null, null, navigateToDeleted, () {}),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: CustomColors.redGrayLightSecondaryColor,
          ),
          Container(
            child: StreamBuilder(
                stream: FirebaseUtils.instance.getDocumentsBetweenDates(
                    "final_product_control",
                    "laying_datetime",
                    monthlyFPCContainerData.initDate,
                    monthlyFPCContainerData.endDate),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List mapList = data.docs;
                      List<FPCModel> fpcDataList = [];

                      if (mapList.isNotEmpty) {
                        for (var item in mapList) {
                          if (item != null) {
                            FPCModel fpc =
                                FPCModel.fromMap(item.data(), item.id);
                            if (!fpc.deleted) {
                              fpcDataList.add(fpc);
                            } else {
                              deletedList.add(fpc);
                            }
                          }
                        }
                        fpcDataList.sort((a, b) =>
                            a.issueDatetime.compareTo(b.issueDatetime));

                        monthlyFPCContainerData = MonthlyFPCContainerData(
                            monthlyFPCContainerData.initDate,
                            monthlyFPCContainerData.endDate,
                            fpcDataList);

                        if (fpcDataList.isNotEmpty) {
                          return Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: fpcDataList.length,
                                  itemBuilder: (context, i) {
                                    double top = 8;
                                    double bottom = 0;
                                    if (i == 0) top = 16;
                                    if (i == fpcDataList.length - 1) bottom = 16;
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                                      child: HNComponentDailyFPC(
                                        fpcDataList[i],
                                        onTap: () {
                                          navigateToDetail(fpcDataList[i]);
                                        },
                                      ),
                                    );
                                  }));
                        } else {
                          return Container(
                              margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                              child: const HNComponentPanel(
                                title: 'No hay registros',
                                text:
                                    "No hay registros de producto final sin eliminar para el mes seleccionado en la base de datos.",
                              ));
                        }
                      } else {
                        Container(
                            margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                            child: const HNComponentPanel(
                              title: 'No hay registros',
                              text:
                                  "No hay registros de producto final sin eliminar para el mes seleccionado en la base de datos.",
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
                            title: 'No hay registros',
                            text:
                                "No hay registros de producto final sin eliminar para el mes seleccionado en la base de datos.",
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.redPrimaryColor,
          child: const Icon(Icons.add_rounded),
          onPressed: navigateToNewFPC),
    );
  }

  navigateToDeleted() {
    MonthlyFPCContainerData deleted = MonthlyFPCContainerData(
        monthlyFPCContainerData.initDate,
        monthlyFPCContainerData.endDate,
        deletedList);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DailyDeletedFinalProdcutControlPage(currentUser, deleted),
        ));
  }

  navigateToNewFPC() async {
    var futureGetNextLot = await FirebaseUtils.instance.getNextLot();
    int nextLot = 0;
    if (futureGetNextLot.docs.isNotEmpty) {
      nextLot = futureGetNextLot.docs[0].data()['lot'] + 1;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NewFinalProductControlPage(currentUser, nextLot),
        ));
  }

  navigateToDetail(FPCModel fpcModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FinalProductControlDetailPage(currentUser, fpcModel),
        ));
  }
}
