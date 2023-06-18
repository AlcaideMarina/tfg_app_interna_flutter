import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/fpc_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class NewFinalProductControlPage extends StatefulWidget {
  const NewFinalProductControlPage(this.currentUser, this.nextLot, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final int nextLot;

  @override
  State<NewFinalProductControlPage> createState() =>
      _NewFinalProductControlPageState();
}

class _NewFinalProductControlPageState
    extends State<NewFinalProductControlPage> {
  late InternalUserModel currentUser;
  late int nextLot;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    nextLot = widget.nextLot;

    bestBeforeTimestampController.text = dateFormat.format(DateTime.now());
    bestBeforeTimestamp = Timestamp.fromDate(DateTime.now());
    issueTimestampController.text = dateFormat.format(DateTime.now());
    issueTimestamp = Timestamp.fromDate(DateTime.now());
    layingTimestampController.text = dateFormat.format(DateTime.now());
    layingTimestamp = Timestamp.fromDate(DateTime.now());
    packingTimestampController.text = dateFormat.format(DateTime.now());
    packingTimtestamp = Timestamp.fromDate(DateTime.now());
  }

  int? acceptedEggs;
  int? rejectedEggs;

  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  TextEditingController bestBeforeTimestampController = TextEditingController();
  DateTime bestBeforeTimestampMinDate =
      Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? bestBeforeTimestamp;

  TextEditingController issueTimestampController = TextEditingController();
  DateTime issueTimestampMinDate =
      Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? issueTimestamp;

  TextEditingController layingTimestampController = TextEditingController();
  DateTime layingTimestampMinDate =
      Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? layingTimestamp;

  TextEditingController packingTimestampController = TextEditingController();
  DateTime packingTimestampMinDate =
      Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? packingTimtestamp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Añadir CPF',
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
                      getComponentTableFormWithoutLabel(
                          getPricePerUnitTableRow(),
                          columnWidhts: {
                            0: const IntrinsicColumnWidth(),
                            2: const IntrinsicColumnWidth()
                          }),
                      const SizedBox(
                        height: 32,
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
        child: Column(children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, saveFPC, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
            'Cancelar',
            null,
            null,
            goBack,
            null,
          ),
        ]));
  }

  List<TableRow> getPricePerUnitTableRow() {
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
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: layingTimestampMinDate,
                      lastDate: DateTime.now());
                  if (pickedDate != null) {
                    setState(() {
                      layingTimestamp = Timestamp.fromDate(pickedDate);
                      layingTimestampController.text =
                          dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: layingTimestampController),
          ),
        ],
      ),
      TableRow(children: [
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
              isEnabled: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: packingTimestampMinDate,
                    lastDate: DateTime.now());
                if (pickedDate != null) {
                  setState(() {
                    packingTimtestamp = Timestamp.fromDate(pickedDate);
                    packingTimestampController.text =
                        dateFormat.format(pickedDate);
                  });
                }
              },
              textEditingController: packingTimestampController),
        ),
      ]),
      TableRow(children: [
        Container(
          child: Text("Control de huevos:"),
          margin: const EdgeInsets.only(left: 12, right: 16, top: 16),
        ),
        Container(),
      ]),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Aceptados:")),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 8),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: (acceptedEggs ?? 0).toString(),
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
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: (rejectedEggs ?? 0).toString(),
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
              margin: const EdgeInsets.only(
                left: 24,
                right: 16,
              ),
              child: Text("Lote:")),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 16),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: nextLot.toString(),
              isEnabled: true,
              onChange: (value) {
                nextLot = int.tryParse(value) ?? 0;
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
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: bestBeforeTimestampMinDate,
                      lastDate:
                          Utils().addToDate(DateTime.now(), yearsToAdd: 1));
                  if (pickedDate != null) {
                    setState(() {
                      bestBeforeTimestamp = Timestamp.fromDate(pickedDate);
                      bestBeforeTimestampController.text =
                          dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: bestBeforeTimestampController),
          ),
        ],
      ),
      TableRow(children: [
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
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: issueTimestampMinDate,
                    lastDate: Utils().addToDate(DateTime.now(), yearsToAdd: 1));
                if (pickedDate != null) {
                  setState(() {
                    issueTimestamp = Timestamp.fromDate(pickedDate);
                    issueTimestampController.text =
                        dateFormat.format(pickedDate);
                  });
                }
              },
              textEditingController: issueTimestampController),
        ),
      ]),
    ];
    return list;
  }

  goBack() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  saveFPC() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    if (layingTimestamp != null &&
        packingTimtestamp != null &&
        bestBeforeTimestamp != null &&
        issueTimestamp != null) {
      FPCModel fpcModel = FPCModel(
          acceptedEggs ?? 0,
          bestBeforeTimestamp!,
          currentUser.documentId!,
          Timestamp.now(),
          false,
          issueTimestamp!,
          layingTimestamp!,
          nextLot,
          packingTimtestamp!,
          rejectedEggs ?? 0,
          null);
      bool firestoreConf = await FirebaseUtils.instance
          .addDocument("final_product_control", fpcModel.toMap());
      if (firestoreConf) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('FPC guardado'),
                  content: Text(
                      'El registro de producto final ha sido guardado correctamente en la base de datos.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                            ..pop()
                            ..pop();
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
                      'Se ha producido un error al guardar el registro de  producto final. Por favor, revise los datos e inténtelo de nuevo.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(this.context).pop();
                        },
                        child: const Text("De acuerdo")),
                  ],
                ));
      }
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Formualrio incompleto'),
                content: Text(
                    'Debe rellenar todos los campos del formulario. Por favor revise los datos e inténtelo de nuevo.'),
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
