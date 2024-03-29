import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/fpc_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/data/models/local/monthly_fpc_container_data.dart';
import 'package:hueveria_nieto_interna/ui/views/finalproductcontrol/daily_final_product_control_page.dart';
import 'package:hueveria_nieto_interna/utils/farm_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_fpc_monthly_container_item.dart';
import '../../components/component_panel.dart';
import 'new_final_product_control_page.dart';

class MonthlyFinalProductControlPage extends StatefulWidget {
  const MonthlyFinalProductControlPage(this.currentUser, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<MonthlyFinalProductControlPage> createState() =>
      _MonthlyFinalProductControlPageState();
}

class _MonthlyFinalProductControlPageState
    extends State<MonthlyFinalProductControlPage> {
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
            "Control prod. final - Mensual",
            style: TextStyle(fontSize: 18),
          )),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseUtils.instance
                  .getAllDocumentsFromCollection("final_product_control"),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    final List list = data.docs;
                    final List<FPCModel> fpcList =
                        FarmUtils().getFPCModel(list);
                    final List<MonthlyFPCContainerData>
                        monthlyFPCContainerDataList =
                        FarmUtils().getMonthlyFPCModelFromFPCModelList(fpcList);

                    if (monthlyFPCContainerDataList.isNotEmpty) {
                      return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: monthlyFPCContainerDataList.length,
                              itemBuilder: (context, i) {
                                MonthlyFPCContainerData data =
                                    monthlyFPCContainerDataList[i];
                                double top = 8;
                                double bottom = 0;
                                if (i == 0) top = 16;
                                if (i == list.length - 1) bottom = 16;
                                return Container(
                                    margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                                  child: HNComponentFPCMonthlyContainerItem(
                                      data, onTap: () {
                                    navigateToDailyFPC(data);
                                  }),
                                );
                              }));
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
                          text: "No hay registros en la base de datos.",
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
          onPressed: navigateToNewFPC),
    );
  }

  navigateToDailyFPC(MonthlyFPCContainerData data) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DailyFinalProductControlPage(currentUser, data),
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
}
