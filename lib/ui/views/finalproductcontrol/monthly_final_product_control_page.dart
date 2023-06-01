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

class MonthlyFinalProductControlPage extends StatefulWidget {
  const MonthlyFinalProductControlPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<MonthlyFinalProductControlPage> createState() => _MonthlyFinalProductControlPageState();
}

class _MonthlyFinalProductControlPageState extends State<MonthlyFinalProductControlPage> {
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
              "Todos los pedidos",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseUtils.instance.getAllDocumentsFromCollection("final_product_control"),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List list = data.docs;
                      final List<FPCModel> fpcList = FarmUtils().getFPCModel(list);
                      final List<MonthlyFPCContainerData> monthlyFPCContainerDataList = FarmUtils().getMonthlyFPCModelFromFPCModelList(fpcList);

                      if(monthlyFPCContainerDataList.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: monthlyFPCContainerDataList.length,
                                itemBuilder: (context, i) {
                                  MonthlyFPCContainerData data = monthlyFPCContainerDataList[i];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 8),
                                    child: HNComponentFPCMonthlyContainerItem(
                                      data,
                                      onTap: () {
                                        navigateToDailyFPC(data);
                                      }),
                                    );
                                }
                            )
                        );
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

  navigateToDailyFPC(MonthlyFPCContainerData data) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DailyFinalProductControlPage(currentUser, data),
        ));
  }
}