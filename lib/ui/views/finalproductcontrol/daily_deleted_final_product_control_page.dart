import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/data/models/local/monthly_fpc_container_data.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../components/component_daily_final_product_control.dart';
import '../../components/component_panel.dart';

class DailyDeletedFinalProdcutControlPage extends StatefulWidget {
  const DailyDeletedFinalProdcutControlPage(
      this.currentUser, this.monthlyFPCContainerData,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final MonthlyFPCContainerData monthlyFPCContainerData;

  @override
  State<DailyDeletedFinalProdcutControlPage> createState() =>
      _DailyDeletedFinalProdcutControlPageState();
}

class _DailyDeletedFinalProdcutControlPageState
    extends State<DailyDeletedFinalProdcutControlPage> {
  late InternalUserModel currentUser;
  late MonthlyFPCContainerData monthlyFPCContainerData;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    monthlyFPCContainerData = widget.monthlyFPCContainerData;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "CPF - Reg. eliminados",
            style: TextStyle(
                color: AppTheme.primary, fontSize: CustomSizes.textSize24),
          )),
      body: monthlyFPCContainerData.list.isNotEmpty
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(), 
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: monthlyFPCContainerData.list.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: HNComponentDailyFPC(
                        monthlyFPCContainerData.list[i],
                        onTap: () {},
                      ),
                    );
                  })
              : Container(
                  margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                  child: const HNComponentPanel(
                    title: 'No hay registros',
                    text:
                        "No hay registros de producto final eliminados para el mes seleccionado en la base de datos.",
                  )),
    );
  }
}
