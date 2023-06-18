import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:hueveria_nieto_interna/ui/components/component_order.dart';
import 'package:hueveria_nieto_interna/ui/views/allorders/all_orders_page.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:hueveria_nieto_interna/utils/order_utils.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_colors.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../components/component_panel.dart';
import '../../../components/constants/hn_button.dart';
import '../../../components/menu/lateral_menu.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late InternalUserModel currentUser;

  @override
  void  initState() {
    super.initState();
    currentUser = widget.currentUser;
  }


  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: LateralMenu(currentUser),
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Pedidos y repartos",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Container(
                margin: EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(Utils().parseTimestmpToString(Timestamp.now()) ?? "", style: TextStyle(fontSize: 24, color: CustomColors.whiteColor),)
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: CustomColors.redPrimaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                ),
              ),
              Container(
                child: StreamBuilder(
                  stream: FirebaseUtils.instance.getAllDocumentsFromCollection("client_info"),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              
                      // TODO: Pop-up del error
                      if (snapshot.hasError) return const Text("error");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: CustomColors.redPrimaryColor,
                              ),
                            ),
                          );
                      }
              
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collectionGroup('orders').snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                              
                                // TODO: Pop-up del error
                                if (orderSnapshot.hasError) return const Text("error");
                                if (orderSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: CustomColors.redPrimaryColor,
                                        ),
                                      ),
                                    );
                                }
              
                                List<dynamic>? orderModelList = orderSnapshot.data?.docs
                                  .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>,e.id)).toList() ?? [];
                                
                                List<OrderModel> list = [];
                                final DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                                for (OrderModel item in orderModelList) {
                                  if (item.status != Constants().orderStatus["Cancelado"]
                                      && item.orderDatetime.compareTo(Timestamp.fromDate(todayDate)) >= 1) {
                                    list.add(item);
                                  }
                                }
                                list.sort((b, a) {
                                  return b.orderDatetime.compareTo(a.orderDatetime);
                                });
              
                                if (list.isNotEmpty) {
                                  return Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: CustomColors.redGrayLightSecondaryColor,
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: list.length,
                                        itemBuilder: (context, i) {
                                          final OrderModel orderModel = list[i];
                                                  
                                          return Container(
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 32, vertical: 8),
                                              child: HNComponentOrders(
                                                orderModel.orderDatetime,
                                                orderModel.orderId!,
                                                orderModel.company,
                                                OrderUtils().getOrderSummary(OrderUtils().orderDataToBDOrderModel(orderModel)),        // TODO
                                                orderModel.totalPrice,
                                                orderModel.status,
                                                orderModel.deliveryDni,
                                                onTap: () {}),
                                            );
                                          
                                        }),
                                    ));
                                } else {
                                  return Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: CustomColors.redGrayLightSecondaryColor,
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
                                      ),
                                      child: SingleChildScrollView(
                                          child: Container(
                                                  margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                                                  child: const HNComponentPanel(
                                                    title: 'No hay pedidos',
                                                    text:
                                                        "No hay registro de pedidos realizados hoy en la base de datos.",
                                                  )),
                                        ),
                                    ));
                                }
                                
                            });
                  }
                ),
              ),
              const SizedBox(height: 32,),
              HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
                'Ver todo', null, null, navigateToAllOrders, () {}),
            ]
          ),
        ),
    );
  }

  navigateToAllOrders() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllOrdersPage(currentUser),
        ));
  }
}