import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/ui/views/allorders/new_order_page.dart';
import 'package:hueveria_nieto_interna/ui/views/allorders/order_detail_page.dart';

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

class ClientAllOrdersPage extends StatefulWidget {
  const ClientAllOrdersPage(this.currentUser, this.clientModel, {Key? key}) : super(key: key);
  
  final InternalUserModel currentUser;
  final ClientModel clientModel;

  @override
  State<ClientAllOrdersPage> createState() => _ClientAllOrdersPageState();
}

class _ClientAllOrdersPageState extends State<ClientAllOrdersPage> {
  late InternalUserModel currentUser;
  late ClientModel clientModel;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    clientModel = widget.clientModel;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: Text(
              "Pedidos del cliente - ID: ${clientModel.id}",
              style: const  TextStyle(fontSize: 18),
            )),
        body: Column(
          children: [
            Container(
                child:StreamBuilder<QuerySnapshot>(
                        stream: FirebaseUtils.instance.getUserOrders(clientModel.documentId!),
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
                                  return b.orderDatetime.compareTo(a.orderDatetime);
                                });
              
                                if (list.isNotEmpty) {
                                  return Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: list.length,
                                        itemBuilder: (context, i) {
                                          final OrderModel orderModel = list[i];
                                          double top = 8;
                                          double bottom = 0;
                                          if (i == 0) top = 16;
                                          if (i == list.length - 1) bottom = 16;
                                  
                                          return Container(
                                            margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                                              child: HNComponentOrders(
                                                orderModel.orderDatetime,
                                                orderModel.orderId!,
                                                orderModel.clientId.toString() + " - " + orderModel.company,
                                                OrderUtils().getOrderSummary(OrderUtils().orderDataToBDOrderModel(orderModel)),
                                                orderModel.totalPrice,
                                                orderModel.status,
                                                orderModel.deliveryDni,
                                                onTap: () async {
                                                  navigateToOrderDetail(orderModel);
                                                }
                                              ),
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
                                                    title: 'No hay pedidos',
                                                    text:
                                                        "No hay registro de pedidos para este cliente en la base de datos.",
                                                  )),
                                        ),
                                    ));
                                }
                                
                            })
                 
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.redPrimaryColor,
          child: const Icon(Icons.add_rounded),
          onPressed: navigateToNewOrder
        ),
      );
  }
  
  navigateToNewOrder() async {
    
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
  
  navigateToOrderDetail(OrderModel orderModel) async {

    var future = await FirebaseUtils.instance.getClientById(orderModel.clientId);
    InternalUserModel? deliveryPerson;
    if (future.docs.isNotEmpty) {
      ClientModel clientModel = ClientModel.fromMap(future.docs[0].data(), future.docs[0].id);
      if(orderModel.deliveryPerson != null) {
        var futureDeliveryPerson = await FirebaseUtils.instance.getInternalUserWithDocumentId(orderModel.deliveryPerson!);
        if(futureDeliveryPerson.exists && futureDeliveryPerson.data() != null) {
          deliveryPerson = InternalUserModel.fromMap(futureDeliveryPerson.data()!, futureDeliveryPerson.id);
        }
      }
      if (context.mounted){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(currentUser, clientModel, orderModel, deliveryPerson),
            ));
      }
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Ha ocurrido un error al cargar los datos del pedido. Por favor, inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }

    
  }
}