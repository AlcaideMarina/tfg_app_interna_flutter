import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/component_worker.dart';
import 'package:hueveria_nieto_interna/ui/views/workersresources/pending_workers_resources_page.dart';
import 'package:hueveria_nieto_interna/ui/views/workersresources/worker_detail_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';
import '../../components/constants/hn_button.dart';

class AllWorkersResources extends StatefulWidget {
  const AllWorkersResources(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<AllWorkersResources> createState() => _AllWorkersResourcesState();
}

class _AllWorkersResourcesState extends State<AllWorkersResources> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  List<InternalUserModel> workerList = [];
  List<InternalUserModel> pendingWorkersList = [];

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    workerList = [];
    pendingWorkersList = [];

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Trabajadores y salarios",
              style: TextStyle(fontSize: 18),
            )),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: HNButton(ButtonTypes.redWhiteBoldRoundedButton)
                  .getTypedButton("Sueldos pendientes", null, null,
                      navigateToPendingWorkers, () {}),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: CustomColors.redGraySecondaryColor,
            ),
            StreamBuilder(
                stream: FirebaseUtils.instance.getInternalUsers(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      final List userList = data.docs;
                      if (userList.isNotEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: userList.length,
                                itemBuilder: (context, i) {
                                  final InternalUserModel internalUser =
                                      InternalUserModel.fromMap(
                                          userList[i].data()
                                              as Map<String, dynamic>,
                                          userList[i].id);
                                  if (!internalUser.deleted) {
                                    if (internalUser.salary != null) {
                                      workerList.add(internalUser);
                                      double top = 8;
                                      double bottom = 0;
                                      if (workerList.length == 1) top = 24;
                                      if (i == userList.length - 1) bottom = 16;
                                        return Container(
                                          margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                                        child: HNComponentWorker(
                                            internalUser.id,
                                            internalUser.name,
                                            internalUser.surname,
                                            internalUser.salary, onTap: () {
                                          navigateToWorkerDetail(internalUser);
                                        }),
                                      );
                                    } else {
                                      pendingWorkersList.add(internalUser);
                                      if (i == (userList.length - 1) &&
                                          workerList.isEmpty) {
                                        return Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                32, 56, 32, 8),
                                            child: const HNComponentPanel(
                                              title: 'No hay usuarios',
                                              text:
                                                  "No hay registro de usuarios internos activos en la base de datos.",
                                            ));
                                      } else {
                                        return Container();
                                      }
                                    }
                                  } else {
                                    if (i == (userList.length - 1) &&
                                        workerList.isEmpty) {
                                      return Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              32, 56, 32, 8),
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
        ));
  }

  navigateToPendingWorkers() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PendingWorkersResourcesPage(currentUser, pendingWorkersList),
        ));
  }

  navigateToWorkerDetail(InternalUserModel workerUser) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkerDetailPage(currentUser, workerUser),
        ));
  }
}
