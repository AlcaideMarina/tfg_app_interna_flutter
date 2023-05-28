import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../components/component_panel.dart';
import '../../components/component_worker.dart';
import '../../components/constants/hn_button.dart';

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
  late List<InternalUserModel> pendingWorkersList;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    pendingWorkersList = widget.pendingWorkersList;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Trabajadores y salarios",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Column(
            children: [
              pendingWorkersList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: pendingWorkersList.length,
                            itemBuilder: (context, i) {
                              return HNComponentWorker(
                                  pendingWorkersList[i].id,
                                  pendingWorkersList[i].name,
                                  pendingWorkersList[i].surname,
                                  pendingWorkersList[i].salary,
                                  onTap: () {});
                            }),
                      )
                  : Container(
                      margin: const EdgeInsets.fromLTRB(32, 56, 32, 8),
                      child: const HNComponentPanel(
                        title: 'No hay usuarios',
                        text:
                            "No hay registro de usuarios internos activos en la base de datos.",
                      ))
            ],
          ),
        ));
  }
}
