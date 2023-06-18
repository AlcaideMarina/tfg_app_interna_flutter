import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/data/models/local/billing_data.dart';
import 'package:hueveria_nieto_interna/data/models/local/billing_per_month_data.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';
import 'package:hueveria_nieto_interna/ui/components/component_billing_per_month.dart';
import 'package:hueveria_nieto_interna/ui/views/clientsbilling/montly_billing_detail_page.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:hueveria_nieto_interna/utils/order_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/local/order_billing_data.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';

class BillingPerMonthPage extends StatefulWidget {
  const BillingPerMonthPage(this.currentUser, this.clientModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final ClientModel clientModel;

  @override
  State<BillingPerMonthPage> createState() => _BillingPerMonthPageState();
}

class _BillingPerMonthPageState extends State<BillingPerMonthPage> {
  late InternalUserModel currentUser;
  late ClientModel clientModel;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    clientModel = widget.clientModel;
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
              "Facturación de clientes",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseUtils.instance.getUserOrders(clientModel.documentId!),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List orderList = data.docs;
                      final List<OrderBillingData> orderBillingDataList = OrderUtils().getOrderBillingData(orderList);
                      final List<BillingPerMonthData> list = OrderUtils().getBillingContainerFromOrderModel(orderBillingDataList);
                      if (orderList.isNotEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: list.length,
                                itemBuilder: (context, i) {
                                  BillingPerMonthData data = list[i];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 8),
                                    child: HNComponentBillingPerMonth(
                                      BillingPerMonthData(data.initDate, data.endDate, data.billingData),
                                      onTap: () {
                                        int dataMonth = data.initDate.toDate().month;
                                        int thisMonth = DateTime.now().month;
                                        navigateToMonthlyBillingDetail(data.billingData!, dataMonth == thisMonth);
                                      }),
                                    );
                                }));
                      } else {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                            child: HNComponentPanel(
                              title: 'No hay registros',
                              text:
                                  "Aún no hay registros de facturación para el cliente seleccionado (${clientModel.id} - {${clientModel.company})",
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
                          child: HNComponentPanel(
                            title: 'No hay registros',
                            text:
                                "Aún no hay registros de facturación para el cliente seleccionado (${clientModel.id} - {${clientModel.company})",
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

  navigateToMonthlyBillingDetail(BillingData billingData, bool isThisMonth) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MonthlyBillingDetailPage(currentUser, billingData, isThisMonth)));
  }
}