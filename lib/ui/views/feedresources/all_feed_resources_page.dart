import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/feedresources/feed_resources_detail_page.dart';
import 'package:hueveria_nieto_interna/ui/views/feedresources/new_feed_resource_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/feed_resources_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';
import '../../components/component_ticket.dart';

class AllFeedResourcesPage extends StatefulWidget {
  const AllFeedResourcesPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<AllFeedResourcesPage> createState() => _AllFeedResourcesPageState();
}

class _AllFeedResourcesPageState extends State<AllFeedResourcesPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<FeedResourcesModel> list = [];

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Pienso",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseUtils.instance.getAllResourceDocuments("material_feed"),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List feedList = data.docs;
                      if (feedList.isNotEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: feedList.length,
                                itemBuilder: (context, i) {
                                  final FeedResourcesModel feedModel =
                                      FeedResourcesModel.fromMap(feedList[i].data()
                                          as Map<String, dynamic>, feedList[i].id);
                                  if (!feedModel.deleted) {
                                      list.add(feedModel);
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 8),
                                        child: HNComponentTicket(
                                            feedModel.expenseDatetime,
                                            feedModel.kilos.toString(),
                                            feedModel.totalPrice,
                                            units: "kilos",
                                            onTap: () {
                                              navigateToFeedDetail(feedModel);
                                            }),
                                      );
                                  } else {
                                    if (i == (feedList.length - 1) && list.isEmpty) {
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
          onPressed: navigateToNewFeed
        ),
    );
  }

  navigateToFeedDetail(FeedResourcesModel feedModel) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => FeedResourcesDetailPage(currentUser, feedModel)));
  }

  navigateToNewFeed() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => NewFeedResourcePage(currentUser)));
  }

}
