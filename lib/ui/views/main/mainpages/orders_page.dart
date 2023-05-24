import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:hueveria_nieto_interna/ui/components/component_order.dart';
import 'package:hueveria_nieto_interna/utils/Utils.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';

import '../../../../custom/app_theme.dart';
import '../../../../custom/custom_colors.dart';
import '../../../../custom/custom_sizes.dart';
import '../../../../data/models/client_model.dart';
import '../../../../data/models/internal_user_model.dart';
import '../../../components/component_panel.dart';

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
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Clientes eliminados",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
            StreamBuilder(
              stream: FirebaseUtils.instance.getAllDocumentsFromCollection("client_info"),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                    
                  // _firstListOfDocs is given below (renamed to _categoryDocs)
                  List<QueryDocumentSnapshot> userDocs = snapshot.data.docs;
                  
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collectionGroup('orders').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> orderSnapshot) {
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

                            List<QueryDocumentSnapshot> orderDocs = orderSnapshot.data?.docs ?? [];
                            // _categorListOfDocs is given below (and renamed to _categories)
                            List<dynamic>? _categories = orderSnapshot.data?.docs
                              .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>,e.id)).toList();
                            // return your widgets here.
                            return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: orderDocs.length,
                                itemBuilder: (context, i) {
                                  final OrderModel orderModel = OrderModel
                                      .fromMap(orderDocs[i].data() as Map<String, dynamic>, orderDocs[i].id) ;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 8),
                                    child: HNComponentOrders(
                                      orderModel.orderDatetime,
                                      orderModel.orderId!,
                                      orderModel.company,
                                      "TODO: summary",
                                      orderModel.totalPrice,
                                      orderModel.status,
                                      orderModel.deliveryDni,
                                      onTap: () {}),
                                  );
                                  
                                }));
                        });
              }
            )
          ]
        )
    );
  }
}