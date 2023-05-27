import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/ui/views/allorders/new_order_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/order_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/constants.dart';
import '../../../utils/order_utils.dart';
import '../../components/component_order.dart';
import '../../components/component_panel.dart';

class AllOrdersPage extends StatefulWidget {
  const AllOrdersPage(this.currentUser, {Key? key}) : super(key: key);
  
  final InternalUserModel currentUser;

  @override
  State<AllOrdersPage> createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                                  if (item.status != Constants().orderStatus["Cancelado"]) {
                                    list.add(item);
                                  }
                                }
                                list.sort((a, b) {
                                  return a.orderDatetime.compareTo(b.orderDatetime);
                                });
              
                                if (list.isNotEmpty) {
                                  return Expanded(
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
                                    );
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
                                                    title: 'No hay clientes',
                                                    text:
                                                        "No hay registro de clientes eliminados en la base de datos.",
                                                  )),
                                        ),
                                    ));
                                }
                                
                            });
                  }
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.redPrimaryColor,
          child: const Icon(Icons.add_rounded),
          onPressed: navigateToAllOrders
        ),
      );
  }
  
  navigateToAllOrders() async {
    
    var futureEggPrices = await FirebaseUtils.instance.getEggPrices();
    Map<String, dynamic> valuesMap = futureEggPrices.docs[0].data()["values"];

    var futureClients = await FirebaseUtils.instance.getAllDocumentsFromCollectionFuture("client_info");
    List<ClientModel> clientModelList = [];
    for (var client in futureClients.docs) {
      try {
        clientModelList.add(ClientModel.fromMap(client.data(), client.id));
      } catch (e) {
        //
      }
    }

    if (context.mounted){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewOrderPage(currentUser, valuesMap, clientModelList),
          ));
    }
  }
}