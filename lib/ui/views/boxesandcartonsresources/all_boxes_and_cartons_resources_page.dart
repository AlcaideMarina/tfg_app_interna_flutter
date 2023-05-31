import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/boxesandcartonsresources/boxes_and_cartons_resources_detail_page.dart';
import 'package:hueveria_nieto_interna/ui/views/boxesandcartonsresources/new_boxes_and_cartons_resources_page.dart';
import 'package:hueveria_nieto_interna/utils/material_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/boxes_and_cartons_resources_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';
import '../../components/component_ticket.dart';

class AllBoxesAndCartonsResourcesPage extends StatefulWidget {
  const AllBoxesAndCartonsResourcesPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<AllBoxesAndCartonsResourcesPage> createState() => _AllBoxesAndCartonsResourcesPageState();
}

class _AllBoxesAndCartonsResourcesPageState extends State<AllBoxesAndCartonsResourcesPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<BoxesAndCartonsResourcesModel> list = [];
    
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Cajas y cartones",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseUtils.instance.getAllResourceDocuments("material_boxes_and_cartons"),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List bcList = data.docs;
                      if (bcList.isNotEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: bcList.length,
                                itemBuilder: (context, i) {
                                  final BoxesAndCartonsResourcesModel bcResourceModel =
                                      BoxesAndCartonsResourcesModel.fromMap(bcList[i].data()
                                          as Map<String, dynamic>, bcList[i].id);
                                  if (!bcResourceModel.deleted) {
                                      list.add(bcResourceModel);
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 8),
                                        child: HNComponentTicket(
                                            bcResourceModel.expenseDatetime,
                                            MaterialUtils().getBCOrderSummary(MaterialUtils().bcOrderToDBBoxesAndCartonsOrderModel(bcResourceModel)),
                                            bcResourceModel.totalPrice,
                                            units: "",
                                            onTap: () {
                                              navigateToBoxesAndCartonsResourceDetail(bcResourceModel);
                                            }),
                                      );
                                  } else {
                                    if (i == (bcList.length - 1) && list.isEmpty) {
                                      return Container(
                                        margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                                        child: const HNComponentPanel(
                                          title: 'No hay usuarios',
                                          text:
                                              "No hay registro de usuarios internos activos en la base de datos.",
                                        ));
                                    } else {
                                      return Container();
                                    }
                                  }
                                }));
                      } else {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                            child: const HNComponentPanel(
                              title: 'No hay usuarios',
                              text:
                                  "No hay registro de usuarios internos activos en la base de datos.",
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
                            title: 'No hay usuarios',
                            text:
                                "No hay registro de usuarios internos activos en la base de datos.",
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
          onPressed: navigateToNewBoxesAndCartonsResource
        ),
    );
  }

  navigateToNewBoxesAndCartonsResource() async {
     Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => NewBoxesAndCartonsResourcesPage(currentUser)));
  }

  navigateToBoxesAndCartonsResourceDetail(BoxesAndCartonsResourcesModel bcResourceModel) {
     Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => BoxesAndCartonsResourceDetailPage(currentUser, bcResourceModel)));
  }
  
}
