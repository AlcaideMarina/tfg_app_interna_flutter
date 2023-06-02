import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class NewFinalProductControlPage extends StatefulWidget {
  const NewFinalProductControlPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<NewFinalProductControlPage> createState() => _NewFinalProductControlPageState();
}

class _NewFinalProductControlPageState extends State<NewFinalProductControlPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    
    bestBeforeDatetimeController.text = dateFormat.format(bestBeforeDatetimeMinDate);
    bestBeforeDatetime = Timestamp.fromDate(bestBeforeDatetimeMinDate);
    issueDatetimeController.text = dateFormat.format(issueDatetimeMinDate);
    issueDatetime = Timestamp.fromDate(issueDatetimeMinDate);
    layingDatetimeController.text = dateFormat.format(layingDatetimeMinDate);
    layingDatetime = Timestamp.fromDate(layingDatetimeMinDate);
    packingDatetimeController.text = dateFormat.format(packingDatetimeMinDate);
    packingDatetime = Timestamp.fromDate(packingDatetimeMinDate);
  }

  int? acceptedEggs;
  int? lot;
  int? rejectedEggs;

  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  TextEditingController bestBeforeDatetimeController = TextEditingController();
  DateTime bestBeforeDatetimeMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? bestBeforeDatetime;

  TextEditingController issueDatetimeController = TextEditingController();
  DateTime issueDatetimeMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? issueDatetime;

  TextEditingController layingDatetimeController = TextEditingController();
  DateTime layingDatetimeMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? layingDatetime;

  TextEditingController packingDatetimeController = TextEditingController();
  DateTime packingDatetimeMinDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? packingDatetime;

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
                      getComponentTableFormWithoutLabel(getPricePerUnitTableRow(), 
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
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, () {}, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Cancelar', 
                null, 
                null, 
                () {},
                null, 
              ),
        ])
    );
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
                  // TODO: Cambiar el color
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: layingDatetimeMinDate, 
                    lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    setState(() {
                      layingDatetime = Timestamp.fromDate(pickedDate);
                      layingDatetimeController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: layingDatetimeController
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
                isEnabled: true,
                onTap: () async {
                  // TODO: Cambiar el color
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: packingDatetimeMinDate, 
                    lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    setState(() {
                      packingDatetime = Timestamp.fromDate(pickedDate);
                      packingDatetimeController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: packingDatetimeController
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
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 4),
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
              margin: const EdgeInsets.only(left: 24, right: 16,),
              child: Text("Lote:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 16),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: (lot ?? 0).toString(),
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
                    firstDate: layingDatetimeMinDate, 
                    lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    setState(() {
                      layingDatetime = Timestamp.fromDate(pickedDate);
                      layingDatetimeController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: layingDatetimeController
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
                    firstDate: layingDatetimeMinDate, 
                    lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    setState(() {
                      layingDatetime = Timestamp.fromDate(pickedDate);
                      layingDatetimeController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: layingDatetimeController
              ),
            ),
          ]
        ),
    ];
    return list;

  }

}
