import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/menu/lateral_menu.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

import '../../../custom/custom_colors.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/order_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/constants.dart';
import '../../../values/image_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }
  final DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: LateralMenu(currentUser),
      appBar: AppBar(
        //leading: const Icon(Icons.menu_rounded, color: AppTheme.primary,),
        toolbarHeight: 56.0,
        title: Text(
          StringsTranslation.of(context)
            ?.translate('hueveria_nieto') ?? "Huevería nieto", 
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: CustomSizes.textSize24
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Hola, ${currentUser.name}. Bienvenido/a de nuevo.", style: TextStyle(fontSize: 32), textAlign: TextAlign.center,),
                ],
              ),
              SizedBox(
                height: 40,
              ),  
              StreamBuilder(
                stream: FirebaseUtils.instance.getAllDocumentsFromCollection("client_info"),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              
                        // TODO: Pop-up del error
                        if (snapshot.hasError) return const Text("error");
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                                child: CircularProgressIndicator(
                                  color: CustomColors.redPrimaryColor,
                                
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
                                    return const Center(
                                          child: CircularProgressIndicator(
                                            color: CustomColors.redPrimaryColor,
                                          ),
                                        
                                      );
                                  }
                              
                                  List<dynamic>? orderModelList = orderSnapshot.data?.docs
                                    .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>,e.id)).toList() ?? [];
                                  
                                  List<OrderModel> todayOrders = [];
                                  List<OrderModel> todayDelivery = [];
                                  for (OrderModel item in orderModelList) {
                                    // TODO: Comprobar si quitamos los cancelado en Android
                                    if (item.status != Constants().orderStatus["Cancelado"]) {
                                      if (item.orderDatetime.compareTo(Timestamp.fromDate(todayDate)) >= 0) {
                                        todayOrders.add(item);
                                      }
                                      if (item.approxDeliveryDatetime.compareTo(Timestamp.fromDate(todayDate)) >= 0 
                                        && item.approxDeliveryDatetime.compareTo(Timestamp.fromDate(Utils().addToDate(todayDate, daysToAdd: 1))) == -1
                                        && item.status != Constants().orderStatus["Cancelado"]) {
                                        todayDelivery.add(item);
                                      }
                                    }
                                  }
                              
                                  return Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Hoy hay ${todayOrders.length} pedidos.'
                                              )
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: CustomColors.redGraySecondaryColor,
                                              border: Border.all(
                                                color: CustomColors.redGraySecondaryColor,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(20))),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                    'Hay ${todayDelivery.length} repartos planificados para hoy.'
                                                  
                                                
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: CustomColors.redGraySecondaryColor,
                                              border: Border.all(
                                                color: CustomColors.redGraySecondaryColor,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(20))),
                                        ),
                                      ],
                                    
                                  );
                                  
                              });
                    }
              ),
              SizedBox(
                height: 32,
              ),
              StreamBuilder(
                stream: FirebaseUtils.instance.getDocumentsBetweenDates("farm_situation", "situation_datetime", Timestamp.fromDate(todayDate), Timestamp.fromDate(Utils().addToDate(todayDate, daysToAdd: 1))),// Reemplaza "myStream2" con tu propio stream
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // TODO: Pop-up del error
                  if (snapshot.hasError) return const Text("error");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                          child: CircularProgressIndicator(
                            color: CustomColors.redPrimaryColor,
                          ),
                        
                      );
                  }
                  
                  bool result = false;
                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                    result = true;
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: 
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            result 
                              ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ImageRoutes.getRoute('ic_right_tic'), 
                                    width: 16,
                                    height: 24,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Hoy se ha hecho el seguimiento de la situación de la empresa.',
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              )
                              : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ImageRoutes.getRoute('ic_wrong'), 
                                    width: 16,
                                    height: 24,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Hoy aún no se ha hecho el seguimiento de la situación de la empresa.",
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
