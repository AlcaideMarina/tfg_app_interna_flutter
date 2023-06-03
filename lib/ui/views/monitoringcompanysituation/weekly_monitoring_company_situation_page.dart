import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:hueveria_nieto_interna/ui/components/component_day_division_data.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';

class WeeklyMonitoringCompanySituationPage extends StatefulWidget {
  const WeeklyMonitoringCompanySituationPage(this.currentUser, this.initTimestamp, this.endTimestamp, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final Timestamp initTimestamp;
  final Timestamp endTimestamp;

  @override
  State<WeeklyMonitoringCompanySituationPage> createState() => _WeeklyMonitoringCompanySituationPageState();
}

class _WeeklyMonitoringCompanySituationPageState extends State<WeeklyMonitoringCompanySituationPage> {
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
              "Ver clientes",
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: Column(
            children: [
              StreamBuilder(
                stream: FirebaseUtils.instance.getAllDocumentsFromCollection("user_info"), // Reemplaza "myDataStream" con tu propio stream
                builder: (context, snapshot) {
                  /*if (snapshot.hasData) {
                    // Datos disponibles
                    final data = snapshot.data!;
        
                    return Container(
                      color: Colors.red,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Hola',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          for (var item in data)
                            Text(item),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Error al obtener los datos
                    return Container(
                      color: Colors.red,
                      padding: EdgeInsets.all(16),
                      child: Text('Error al obtener los datos'),
                    );
                  } else {
                    // Datos aún no disponibles
                    return Container(
                      color: Colors.red,
                      padding: EdgeInsets.all(16),
                      child: Text('Cargando datos...'),
                    );
                  }*/
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Center(
                                child: Text("Información semanal")
                              ),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: CustomColors.redPrimaryColor,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: CustomColors.redGrayLightSecondaryColor,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
                              ),
                              child: Text("hola")
                            )
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
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 7, // Número de días de la semana
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                      child: HNComponentDayDivisionData(
                        Timestamp.now(), 
                        onTap: () {})
                      );
                  },
                ),
              ),
            ],
          ),
        
    );
  }

  /*Widget getWeeklySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title == null
              ? Container()
              : Text(
                  title!,
                  style: const TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
          SizedBox(height: space1),
          subtitle == null
              ? Container()
              : Text(
                  subtitle!,
                  style: const TextStyle(
                      fontSize: 14.0, color: CustomColors.grayColor),
                  textAlign: TextAlign.center,
                ),
          SizedBox(height: space2),
          text == null
              ? Container()
              : Text(
                  text!,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
          SizedBox(height: space3),
          subtext == null
              ? Container()
              : Text(
                  subtext!,
                  style: const TextStyle(
                      fontSize: 13.0, color: CustomColors.grayColor),
                  textAlign: TextAlign.center,
                )
        ],
      ),
      decoration: BoxDecoration(
          color: CustomColors.redGraySecondaryColor,
          border: Border.all(
            color: CustomColors.redGraySecondaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }*/

}
