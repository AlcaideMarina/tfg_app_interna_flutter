import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/fpc_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyFinalProductControlPage extends StatefulWidget {
  const ModifyFinalProductControlPage(this.currentUser, this.fpcModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final FPCModel fpcModel;

  @override
  State<ModifyFinalProductControlPage> createState() => _ModifyFinalProductControlPageState();
}

class _ModifyFinalProductControlPageState extends State<ModifyFinalProductControlPage> {
  late InternalUserModel currentUser;
  late FPCModel fpcModel;
  
  late int acceptedEggs;
  late int rejectedEggs;
  late int lot;

  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  TextEditingController bestBeforeTimestampController = TextEditingController();
  DateTime bestBeforeTimestampMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp bestBeforeTimestamp;

  TextEditingController issueTimestampController = TextEditingController();
  DateTime issueTimestampMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp issueTimestamp;

  TextEditingController layingTimestampController = TextEditingController();
  DateTime layingTimestampMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp layingTimestamp;

  TextEditingController packingTimestampController = TextEditingController();
  DateTime packingTimestampMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp packingTimtestamp;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    fpcModel = widget.fpcModel;

    acceptedEggs = fpcModel.acceptedEggs;
    rejectedEggs = fpcModel.rejectedEggs;
    lot = fpcModel.lot;
    
    bestBeforeTimestampController.text = dateFormat.format(fpcModel.bestBeforeDatetime.toDate());
    bestBeforeTimestamp = fpcModel.bestBeforeDatetime;
    issueTimestampController.text = dateFormat.format(fpcModel.issueDatetime.toDate());
    issueTimestamp = fpcModel.issueDatetime;
    layingTimestampController.text = dateFormat.format(fpcModel.layingDatetime.toDate());
    layingTimestamp = fpcModel.issueDatetime;
    packingTimestampController.text = dateFormat.format(fpcModel.packingDatetime.toDate());
    packingTimtestamp = fpcModel.packingDatetime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Modificar FPC',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getComponentTableFormWithoutLabel(getCells(), 
                        columnWidhts: {
                          0: const IntrinsicColumnWidth(),
                        }),
                      const SizedBox(
                        height: 16,
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

  Widget getComponentTableFormWithoutLabel(List<TableRow> children,
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

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, warningUpdateFPCResource, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Cancelar', 
                null, 
                null, 
                goBack,
                null, 
              ),
        ])
    );
  }

  List<TableRow> getCells() {
    List<TableRow> list = [
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Fch. puesta:")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: TextInputType.none,
                isEnabled: true,
                onTap: () async {
                  // TODO: Cambiar el color
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: layingTimestampMinDate, 
                    lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    setState(() {
                      layingTimestamp = Timestamp.fromDate(pickedDate);
                      layingTimestampController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: layingTimestampController
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Fch. envasado:")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: TextInputType.none,
                onTap: () async {
                  // TODO: Cambiar el color
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: packingTimestampMinDate, 
                    lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    setState(() {
                      packingTimtestamp = Timestamp.fromDate(pickedDate);
                      packingTimestampController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: packingTimestampController
              ),
            ),
          ]
        ),
        TableRow(
          children: [
            Container(
              child: Text("Control de huevos:"),
              margin: const EdgeInsets.only(left: 12, right: 16, top: 16),
            ),
            Container(),
          ]
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Aceptados:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 8),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: acceptedEggs.toString(),
                isEnabled: true,
                onChange: (value) {
                  acceptedEggs = int.tryParse(value) ?? 0;
                },
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Rechazados:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: rejectedEggs.toString(),
                isEnabled: true,
                onChange: (value) {
                  rejectedEggs = int.tryParse(value) ?? 0;
                },
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16,),
              child: Text("Lote:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 16),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: lot.toString(),
                isEnabled: true,
                onChange: (value) {
                  lot = int.tryParse(value) ?? 0;
                },
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("F. C. Pref.:")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: TextInputType.none,
                isEnabled: true,
                onTap: () async {
                  // TODO: Cambiar el color
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: bestBeforeTimestampMinDate, 
                    lastDate: Utils().addToDate(DateTime.now(), yearsToAdd: 1)
                  );
                  if (pickedDate != null) {
                    setState(() {
                      bestBeforeTimestamp = Timestamp.fromDate(pickedDate);
                      bestBeforeTimestampController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: bestBeforeTimestampController
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Fch. expedición:")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: TextInputType.none,
                isEnabled: true,
                onTap: () async {
                  // TODO: Cambiar el color
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: issueTimestampMinDate, 
                    lastDate: Utils().addToDate(DateTime.now(), yearsToAdd: 1)
                  );
                  if (pickedDate != null) {
                    setState(() {
                      issueTimestamp = Timestamp.fromDate(pickedDate);
                      issueTimestampController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: issueTimestampController
              ),
            ),
          ]
        ),
    ];
    return list;

  }

  goBack() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  warningUpdateFPCResource() {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: const Text('Aviso'),
          content: Text(
              'Va a modificar la información de la fecha de expedición ${Utils().parseTimestmpToString(fpcModel.issueDatetime) ?? "-"}. ¿Quiere continuar con el proceso?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Continuar'),
              onPressed: () {
                Navigator.pop(context);
                updateFPCResource();
              },
            )
          ],
        ));
  }

  updateFPCResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    FPCModel updatedFPC = FPCModel(
      acceptedEggs,
      bestBeforeTimestamp,
      fpcModel.createdBy,
      fpcModel.creationDatetime, 
      fpcModel.deleted, 
      issueTimestamp,
      layingTimestamp,
      lot,
      packingTimtestamp,
      rejectedEggs,
      fpcModel.documentId);

    bool firestoreConf = await FirebaseUtils.instance.updateDocument("final_product_control", updatedFPC.documentId!, updatedFPC.toMap());
    if (firestoreConf) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('FPC actualizado'),
                  content: Text(
                      'Los datos del producto final se han actualizado correctamente.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pop(context, updatedFPC);
                      }, 
                      child: const Text("De acuerdo")
                    ),
                  ],
                ));
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(
                      'Se ha producido un error cuando se estaban actualizado los datos del producto final. Por favor, revise los datos e inténtelo de nuevo.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(this.context).pop();
                      }, 
                      child: const Text("De acuerdo")
                    ),
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
