import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/components/component_week_division_data.dart';
import 'package:hueveria_nieto_interna/ui/components/component_year_month_alert_dialog.dart';
import 'package:hueveria_nieto_interna/ui/views/monitoringcompanysituation/weekly_monitoring_company_situation_page.dart';
import 'package:intl/intl.dart';

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
    initFilterDatetime = Utils().parseStringToTimestamp('01/' + m + "/" + y).toDate();
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
              'Seg. sit. de la empresa',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Container(
              //margin: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  getFilterComponent(),
                  const SizedBox(
                    height: 24,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        child: list[i]
                      );
                    }
                  )
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
              initFilterDatetime = Utils().parseStringToTimestamp('01/' + m + "/" + y).toDate();
              endFilterDatetime = Utils().addToDate(initFilterDatetime, monthsToAdd: 1);
              getList();
            });
          }
        },
        child: Align(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Utils().parseTimestmpToString(Timestamp.fromDate(initFilterDatetime), dateFormat: "MMMM, yyyy") ?? ""),
              ],
            ),
            decoration: BoxDecoration(
                color: CustomColors.redGrayLightSecondaryColor,
                border: Border.all(
                  color: CustomColors.redPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
          ),
        ));
  }

  getList() {
    int initDayOfWeek = initFilterDatetime.weekday;
    DateTime initDate = Utils().addToDate(initFilterDatetime, daysToAdd: 1 - initDayOfWeek);

    int endDayOfWeek = endFilterDatetime.weekday;
    DateTime endDate = Utils().addToDate(endFilterDatetime, daysToAdd: 7 - endDayOfWeek);

    list = [];

    while (initDate.isBefore(endDate)) {
      list.add(
        HNComponentWeekDivisionData(
          Timestamp.fromDate(initDate), 
          Timestamp.fromDate(Utils().addToDate(initDate, daysToAdd: 6)),
          onTap: () {
            navigateToDailyMCS(
              Timestamp.fromDate(initDate),
              Timestamp.fromDate(Utils().addToDate(initDate, daysToAdd: 6))
            );
          },
        )
      );
      initDate = Utils().addToDate(initDate, daysToAdd: 7);
    }
  }

  navigateToDailyMCS(Timestamp initTimestamp, Timestamp endTimestamp) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeeklyMonitoringCompanySituationPage(currentUser, initTimestamp, endTimestamp),
        ));
  }

}
