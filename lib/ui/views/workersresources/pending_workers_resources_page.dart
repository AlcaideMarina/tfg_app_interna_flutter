import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/workersresources/worker_detail_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_panel.dart';
import '../../components/component_worker.dart';

class PendingWorkersResourcesPage extends StatefulWidget {
  const PendingWorkersResourcesPage(this.currentUser, this.pendingWorkersList,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final List<InternalUserModel> pendingWorkersList;

  @override
  State<PendingWorkersResourcesPage> createState() =>
      _PendingWorkersResourcesPageState();
}

class _PendingWorkersResourcesPageState
    extends State<PendingWorkersResourcesPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<InternalUserModel> list = [];
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Salarios pendientes",
              style: TextStyle(fontSize: 18),
            )),
        body: Column(
            children: [
              const SizedBox(height: 16,),
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
                                      InternalUserModel.fromMap(userList[i].data()
                                          as Map<String, dynamic>, userList[i].id);
                                  if (!internalUser.deleted) {
                                    if (internalUser.salary == null) {
                                      list.add(internalUser);
                                      double top = 8;
                                      double bottom = 0;
                                      if (i == 0) top = 240;
                                      if (i == userList.length - 1) bottom = 16;
                                        return Container(
                                          margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                                        child: HNComponentWorker(
                                            internalUser.id,
                                            internalUser.name,
                                            internalUser.surname,
                                            internalUser.salary,
                                            onTap: () {
                                              navigateToWorkerDetail(internalUser);
                                            }),
                                      );
                                    } else {
                                      if (i == (userList.length - 1) && list.isEmpty) {
                                        return Container(
                                          margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                                          child: const HNComponentPanel(
                                            title: 'No hay usuarios',
                                            text:
                                                "No hay registro de usuarios internos activos en la base de datos que estén pendientes de asignar el salario.",
                                          ));
                                      } else {
                                        return Container();
                                      }
                                    }
                                  } else {
                                    if (i == (userList.length - 1) && list.isEmpty) {
                                      return Container(
                                        margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                                        child: const HNComponentPanel(
                                          title: 'No hay usuarios',
                                          text:
                                              "No hay registro de usuarios internos activos en la base de datos que estén pendientes de asignar el salario.",
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
                                  "No hay registro de usuarios internos activos en la base de datos que estén pendientes de asignar el salario.",
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
                                "No hay registro de usuarios internos activos en la base de datos que estén pendientes de asignar el salario.",
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
        );
  }

  navigateToWorkerDetail(InternalUserModel workerUser) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkerDetailPage(currentUser, workerUser),
        ));
  }
}
