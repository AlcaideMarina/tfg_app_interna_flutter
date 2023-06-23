import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:hueveria_nieto_interna/ui/components/component_day_division_data.dart';
import 'package:hueveria_nieto_interna/ui/views/monitoringcompanysituation/daily_monitoring_company_situation_page.dart';
import 'package:hueveria_nieto_interna/utils/farm_utils.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/local/weekly_monitoring_company_situation_data.dart';
import '../../../data/models/monitoring_company_situation_model.dart';

class WeeklyMonitoringCompanySituationPage extends StatefulWidget {
  const WeeklyMonitoringCompanySituationPage(
      this.currentUser, this.initTimestamp, this.endTimestamp,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final Timestamp initTimestamp;
  final Timestamp endTimestamp;

  @override
  State<WeeklyMonitoringCompanySituationPage> createState() =>
      _WeeklyMonitoringCompanySituationPageState();
}

class _WeeklyMonitoringCompanySituationPageState
    extends State<WeeklyMonitoringCompanySituationPage> {
  late InternalUserModel currentUser;
  late Timestamp initTimestamp;
  late Timestamp endTimestamp;

  @override
  void initState() {
    super.initState();

    currentUser = widget.currentUser;
    initTimestamp = widget.initTimestamp;
    endTimestamp = widget.endTimestamp;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 56.0,
          title: const Text(
            "Seguimiento sit. empresa",
            style: TextStyle( fontSize: 18),
          )),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseUtils.instance.getDocumentsBetweenDates(
                "farm_situation",
                "situation_datetime",
                initTimestamp,
                endTimestamp),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;

                WeeklyMonitoringCompanySituationData weeklyData =
                    FarmUtils().parseFromFarmSituationToModel(snapshot.data!);

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: const Center(child: Text("INFORMACIÓN SEMANAL", style: TextStyle(fontSize: 18, color: CustomColors.whiteColor),)),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: CustomColors.redPrimaryColor,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16))),
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color:
                                      CustomColors.redGrayLightSecondaryColor,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(16))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Puesta semanal - XL:", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),),
                                      const SizedBox(width: 8,),
                                      Text(weeklyData.xlEggs.toString(), style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Puesta semanal - L:", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                                      const SizedBox(width: 8,),
                                      Text(weeklyData.lEggs.toString(), style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Puesta semanal - M:", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                                      const SizedBox(width: 8,),
                                      Text(weeklyData.mEggs.toString(), style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Puesta semanal - S:", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                                      const SizedBox(width: 8,),
                                      Text(weeklyData.sEggs.toString(), style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("PUESTA SEMANAL (TOTAL):", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                                      const SizedBox(width: 8,),
                                      Text(weeklyData.weeklyLaying.toString(), style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Bajas de gallinas esta semana:", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                                      const SizedBox(width: 8,),
                                      Text(weeklyData.hensLosses.toString(), style: const TextStyle(fontSize: 16)),
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: CustomColors.redPrimaryColor,
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(16),
                  child: const Text('Error al obtener los datos'),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                    margin:
                        const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: HNComponentDayDivisionData(
                        "Lunes",
                        Timestamp.fromDate(Utils()
                            .addToDate(initTimestamp.toDate(), daysToAdd: 0)),
                        onTap: () {
                      navigateToDailyMCS(0);
                    })),
                Container(
                    margin:
                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: HNComponentDayDivisionData(
                        "Martes",
                        Timestamp.fromDate(Utils()
                            .addToDate(initTimestamp.toDate(), daysToAdd: 1)),
                        onTap: () {
                      navigateToDailyMCS(1);
                    })),
                Container(
                    margin:
                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: HNComponentDayDivisionData(
                        "Miércoles",
                        Timestamp.fromDate(Utils()
                            .addToDate(initTimestamp.toDate(), daysToAdd: 2)),
                        onTap: () {
                      navigateToDailyMCS(2);
                    })),
                Container(
                    margin:
                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: HNComponentDayDivisionData(
                        "Jueves",
                        Timestamp.fromDate(Utils()
                            .addToDate(initTimestamp.toDate(), daysToAdd: 3)),
                        onTap: () {
                      navigateToDailyMCS(3);
                    })),
                Container(
                    margin:
                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: HNComponentDayDivisionData(
                        "Viernes",
                        Timestamp.fromDate(Utils()
                            .addToDate(initTimestamp.toDate(), daysToAdd: 4)),
                        onTap: () {
                      navigateToDailyMCS(4);
                    })),
                Container(
                    margin:
                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: HNComponentDayDivisionData(
                        "Sábado",
                        Timestamp.fromDate(Utils()
                            .addToDate(initTimestamp.toDate(), daysToAdd: 6)),
                        onTap: () {
                      navigateToDailyMCS(5);
                    })),
                Container(
                    margin:
                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: HNComponentDayDivisionData(
                        "Domingo",
                        Timestamp.fromDate(Utils()
                            .addToDate(initTimestamp.toDate(), daysToAdd: 7)),
                        onTap: () {
                      navigateToDailyMCS(6);
                    })),
              ],
            ),
          ),
        ],
      ),
    );
  }

  navigateToDailyMCS(int daysToAdd) async {
    DateTime date =
        Utils().addToDate(initTimestamp.toDate(), daysToAdd: daysToAdd);
    var future = await FirebaseUtils.instance.getDocumentsBetweenDatesFuture(
        "farm_situation",
        "situation_datetime",
        Timestamp.fromDate(date),
        Timestamp.fromDate(Utils().addToDate(date, daysToAdd: 1)));

    MonitoringCompanySituationModel mcsModel = MonitoringCompanySituationModel(
        0, null, null, {}, {}, {}, {}, Timestamp.fromDate(date), {}, null);

    if (future.docs.isNotEmpty) {
      mcsModel = MonitoringCompanySituationModel.fromMap(
          future.docs[0].data(), future.docs[0].id);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DailyMonitoringCompanySituationPage(currentUser, mcsModel)));
  }
}
