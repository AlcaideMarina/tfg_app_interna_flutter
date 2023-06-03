import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/components/component_year_month_alert_dialog.dart';
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
  }

  DateTime initialDate = DateTime.now();
  final ValueNotifier<DateTime?> selectedDateNotifier =
      ValueNotifier<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
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
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [getFilterComponent()],
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
                initialDate: initialDate,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 1),
              );
            },
          );

          if (picked != null) {
            setState(() {
              initialDate = DateTime(picked.year, picked.month);
            });
          }
        },
        child: Align(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Utils().parseTimestmpToString(Timestamp.fromDate(initialDate), dateFormat: "MMMM, yyyy") ?? ""),
              ],
            ),
            decoration: BoxDecoration(
                color: CustomColors.redGrayLightSecondaryColor,
                border: Border.all(
                  color: CustomColors.redPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
          ),
        ));
  }
}
