import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/components/component_week_division_data.dart';
import 'package:hueveria_nieto_interna/ui/components/component_year_month_alert_dialog.dart';
import 'package:hueveria_nieto_interna/ui/views/monitoringcompanysituation/weekly_monitoring_company_situation_page.dart';
import 'package:hueveria_nieto_interna/values/image_routes.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../utils/Utils.dart';

class MonthlyMonitoringCompanySituationPage extends StatefulWidget {
  const MonthlyMonitoringCompanySituationPage(this.currentUser, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<MonthlyMonitoringCompanySituationPage> createState() =>
      _MonthlyMonitoringCompanySituationPageState();
}

class _MonthlyMonitoringCompanySituationPageState
    extends State<MonthlyMonitoringCompanySituationPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    String m = now.month.toString();
    while (m.length < 2) {
      m = '0' + m;
    }
    String y = now.year.toString();
    while (y.length < 4) {
      y = '0' + y;
    }
    initFilterDatetime =
        Utils().parseStringToTimestamp('01/' + m + "/" + y).toDate();
    endFilterDatetime = Utils().addToDate(initFilterDatetime, monthsToAdd: 1);
  }

  DateTime now = DateTime.now();
  DateTime initFilterDatetime = DateTime.now();
  DateTime endFilterDatetime = DateTime.now();

  List<HNComponentWeekDivisionData> list = [];

  @override
  Widget build(BuildContext context) {
    getList();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Seguimiento sit. empresa',
              style: TextStyle(fontSize: 18),
            )),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  getFilterComponent(),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.redGrayLightSecondaryColor,
                  ),
                  const SizedBox(height: 8,),
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                          double top = 8;
                          double bottom = 0;
                          if (i == 0) top = 16;
                          if (i == list.length - 1) bottom = 16;
                          return Container(
                            margin: EdgeInsets.fromLTRB(24, top, 24, bottom),
                            child: list[i]);
                      })
                ],
              ),
            ),
          ),
        ));
  }

  Widget getFilterComponent() {
    return GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return HNComponentYearMonthAlertDialog(
                initialDate: initFilterDatetime,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 1),
              );
            },
          );

          if (picked != null) {
            setState(() {
              initFilterDatetime = DateTime(picked.year, picked.month);
              String m = picked.month.toString();
              while (m.length < 2) {
                m = '0' + m;
              }
              String y = picked.year.toString();
              while (y.length < 4) {
                y = '0' + y;
              }
              initFilterDatetime =
                  Utils().parseStringToTimestamp('01/' + m + "/" + y).toDate();
              endFilterDatetime =
                  Utils().addToDate(initFilterDatetime, monthsToAdd: 1);
              getList();
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Row(
            children: [
              const Text("Filtro:", style: TextStyle(fontSize: 16),),
              const SizedBox(width: 24,),
              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(Utils().parseTimestmpToString(
                                Timestamp.fromDate(initFilterDatetime),
                                dateFormat: "MMMM, yyyy") ??
                            "", style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),),
                      ),
                      Transform.rotate(
                        angle: 90 * pi/180,
                        child: Image.asset(ImageRoutes.getRoute('ic_next_arrow'), width: 24, height: 24,))
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: CustomColors.redGrayLightSecondaryColor,
                      border: Border.all(
                        color: CustomColors.redPrimaryColor,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(16))),
                ),
              ),
            ],
          ),
        ));
  }

  getList() {
    int initDayOfWeek = initFilterDatetime.weekday;
    DateTime initDate =
        Utils().addToDate(initFilterDatetime, daysToAdd: 1 - initDayOfWeek);

    int endDayOfWeek = endFilterDatetime.weekday;
    DateTime endDate =
        Utils().addToDate(endFilterDatetime, daysToAdd: 7 - endDayOfWeek);

    list = [];

    while (initDate.isBefore(endDate)) {
      Timestamp init = Timestamp.fromDate(initDate);
      Timestamp end =
          Timestamp.fromDate(Utils().addToDate(initDate, daysToAdd: 6));
      list.add(HNComponentWeekDivisionData(
        init,
        end,
        onTap: () {
          navigateToDailyMCS(init, end);
        },
      ));
      initDate = Utils().addToDate(initDate, daysToAdd: 7);
    }
  }

  navigateToDailyMCS(Timestamp initTimestamp, Timestamp endTimestamp) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeeklyMonitoringCompanySituationPage(
              currentUser, initTimestamp, endTimestamp),
        ));
  }
}
