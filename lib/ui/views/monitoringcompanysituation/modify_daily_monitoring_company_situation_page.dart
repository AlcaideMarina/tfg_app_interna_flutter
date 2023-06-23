import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/monitoring_company_situation_model.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyDailyMonitoringCompanySituationPage extends StatefulWidget {
  const ModifyDailyMonitoringCompanySituationPage(
      this.currentUser, this.mcsModel,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final MonitoringCompanySituationModel mcsModel;

  @override
  State<ModifyDailyMonitoringCompanySituationPage> createState() =>
      _ModifyDailyMonitoringCompanySituationPageState();
}

class _ModifyDailyMonitoringCompanySituationPageState
    extends State<ModifyDailyMonitoringCompanySituationPage> {
  late InternalUserModel currentUser;
  late MonitoringCompanySituationModel mcsModel;
  late int xlBox;
  late int xlEggs;
  late int xlCartons;
  late int lBox;
  late int lEggs;
  late int lCartons;
  late int mBox;
  late int mEggs;
  late int mCartons;
  late int sBox;
  late int sEggs;
  late int sCartons;
  late int lostHens;
  late int brokenEggs;

  @override
  void initState() {
    super.initState();

    currentUser = widget.currentUser;
    mcsModel = widget.mcsModel;

    if (mcsModel.documentId != null) {
      xlBox = mcsModel.xlEggs['boxes'] as int;
      xlEggs = mcsModel.xlEggs['eggs'] as int;
      xlCartons = mcsModel.xlEggs['cartons'] as int;
      lBox = mcsModel.lEggs['boxes'] as int;
      lEggs = mcsModel.lEggs['eggs'] as int;
      lCartons = mcsModel.lEggs['cartons'] as int;
      mBox = mcsModel.mEggs['boxes'] as int;
      mEggs = mcsModel.mEggs['eggs'] as int;
      mCartons = mcsModel.mEggs['cartons'] as int;
      sBox = mcsModel.sEggs['boxes'] as int;
      sEggs = mcsModel.sEggs['eggs'] as int;
      sCartons = mcsModel.sEggs['cartons'] as int;
      lostHens = mcsModel.hens['losses'] as int;
      brokenEggs = mcsModel.brokenEggs;
    } else {
      xlBox = 0;
      xlEggs = 0;
      xlCartons = 0;
      lBox = 0;
      lEggs = 0;
      lCartons = 0;
      mBox = 0;
      mEggs = 0;
      mCartons = 0;
      sBox = 0;
      sEggs = 0;
      sCartons = 0;
      lostHens = 0;
      brokenEggs = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                margin: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getComponentTableForm(getCells(), columnWidhts: {
                        0: const IntrinsicColumnWidth(),
                        2: const IntrinsicColumnWidth()
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      getButtonsComponent(),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

  Widget getComponentTableForm(List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentTableFormWithoutLabel(
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }

  List<TableRow> getCells() {
    List<TableRow> list = [
      TableRow(children: [
        Container(
          child: const Text("Fecha:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(left: 0, right: 16),
        ),
        Container(
          child: Text(
              Utils().parseTimestmpToString(mcsModel.situationDatetime) ?? "-"),
          margin: const EdgeInsets.only(left: 0, right: 16),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Huevos:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(left: 0, right: 16, top: 16),
        ),
        Container()
      ]),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 12, right: 16),
              child: const Text("Cajas XL:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: xlBox.toString(),
              isEnabled: true,
              onChange: (value) {
                xlBox = int.tryParse(value) ?? 0;
                xlEggs = 240 * xlBox;
                xlCartons = 14 * xlBox;
                setState(() {});
              },
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Huevos:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, bottom: 0, top: 8),
            child: Text(xlEggs.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Cartones:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 8),
            child: Text(xlCartons.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 12, right: 16, top: 8),
              child: const Text("Cajas L:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 12),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: lBox.toString(),
              isEnabled: true,
              onChange: (value) {
                lBox = int.tryParse(value) ?? 0;
                lEggs = 360 * lBox;
                lCartons = 14 * lBox;
                setState(() {});
              },
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Huevos:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, bottom: 0, top: 8),
            child: Text(lEggs.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Cartones:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 8),
            child: Text(lCartons.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 12, right: 16, top: 8),
              child: const Text("Cajas M:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 12),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: mBox.toString(),
              isEnabled: true,
              onChange: (value) {
                mBox = int.tryParse(value) ?? 0;
                mEggs = 360 * mBox;
                mCartons = 14 * mBox;
                setState(() {});
              },
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Huevos:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, bottom: 0, top: 8),
            child: Text(mEggs.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Cartones:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 8),
            child: Text(mCartons.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 12, right: 16, top: 8),
              child: const Text("Cajas S:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 12),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: sBox.toString(),
              isEnabled: true,
              onChange: (value) {
                sBox = int.tryParse(value) ?? 0;
                sEggs = 360 * sBox;
                sCartons = 14 * sBox;
                setState(() {});
              },
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Huevos:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, bottom: 0, top: 8),
            child: Text(sEggs.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: const Text("Cartones:", 
                style: TextStyle(fontStyle: FontStyle.italic))),
          Container(
            margin: const EdgeInsets.only(left: 24, top: 8),
            child: Text(sCartons.toString()),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 0, right: 16, top: 8),
              child: const Text("Bajas gallinas:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 12),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: lostHens.toString(),
              isEnabled: true,
              onChange: (value) {
                lostHens = int.tryParse(value) ?? 0;
                ;
              },
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 0, right: 16, top: 4),
              child: const Text("Huevos rotos:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 8),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: brokenEggs.toString(),
              isEnabled: true,
              onChange: (value) {
                brokenEggs = int.tryParse(value) ?? 0;
              },
            ),
          ),
        ],
      ),
    ];
    return list;
  }

  Widget getButtonsComponent() {
    return HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
          .getTypedButton("Guardar", null, null, saveMCS, null);
  }

  saveMCS() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    bool firestoreConf = false;
    MonitoringCompanySituationModel updatedMCS;
    if (mcsModel.documentId != null) {
      // Actualizar
      updatedMCS = MonitoringCompanySituationModel(
          brokenEggs,
          mcsModel.createdBy,
          mcsModel.creationDatetime,
          {
            "alive": 0,
            "losses": lostHens,
          },
          {
            "boxes": lBox,
            "cartons": lCartons,
            "eggs": lEggs,
          },
          {
            "boxes": mBox,
            "cartons": mCartons,
            "eggs": mEggs,
          },
          {
            "boxes": sBox,
            "cartons": sCartons,
            "eggs": sEggs,
          },
          mcsModel.situationDatetime,
          {
            "boxes": xlBox,
            "cartons": xlCartons,
            "eggs": xlEggs,
          },
          mcsModel.documentId);
      firestoreConf = await FirebaseUtils.instance.updateDocument(
          "farm_situation", updatedMCS.documentId!, updatedMCS.toMap());
    } else {
      // Guardar nuevo
      updatedMCS = MonitoringCompanySituationModel(
          brokenEggs,
          currentUser.documentId!,
          Timestamp.now(),
          {
            "alive": 0,
            "losses": lostHens,
          },
          {
            "boxes": lBox,
            "cartons": lCartons,
            "eggs": lEggs,
          },
          {
            "boxes": mBox,
            "cartons": mCartons,
            "eggs": mEggs,
          },
          {
            "boxes": sBox,
            "cartons": sCartons,
            "eggs": sEggs,
          },
          mcsModel.situationDatetime,
          {
            "boxes": xlBox,
            "cartons": xlCartons,
            "eggs": xlEggs,
          },
          null);
      firestoreConf = await FirebaseUtils.instance
          .addDocument("farm_situation", updatedMCS.toMap());
    }

    if (firestoreConf) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Situación guardada'),
                content: Text(
                    'La información sobre la situación de la empresa diaría ha sido guardada correctamente en la base de datos.'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pop(context, updatedMCS);
                      },
                      child: const Text("De acuerdo")),
                ],
              ));
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: Text(
                    'Se ha producido un error al guardar la situación de la empresa diaria. Por favor, revise los datos e inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("De acuerdo")),
                ],
              ));
    }
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
