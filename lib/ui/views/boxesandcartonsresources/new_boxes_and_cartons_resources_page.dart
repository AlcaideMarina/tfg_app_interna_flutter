import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../utils/Utils.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_table_form.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class NewBoxesAndCartonsResourcesPage extends StatefulWidget {
  const NewBoxesAndCartonsResourcesPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<NewBoxesAndCartonsResourcesPage> createState() => _NewBoxesAndCartonsResourcesPageState();
}

class _NewBoxesAndCartonsResourcesPageState extends State<NewBoxesAndCartonsResourcesPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  TextEditingController dateController = TextEditingController();
  DateTime minDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? datePickerTimestamp;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  
  int? box;
  int? xlCarton;
  int? lCarton;
  int? mCarton;
  int? sCarton;
  double? totalPrice;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Detalle - Electr...',
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
                      getComponentTableFormWithoutLable(getCells(), 
                        columnWidhts: {
                          0: const IntrinsicColumnWidth(),
                          2: const IntrinsicColumnWidth(),
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

  Widget getComponentTableFormWithoutLable(List<TableRow> children,
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
    return [
      TableRow(
        children: [
          Container(
            child: Text("Fecha:"),
            margin: const EdgeInsets.only(right: 16),
          ),
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
                    firstDate: minDate, 
                    lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    setState(() {
                      datePickerTimestamp = Timestamp.fromDate(pickedDate);
                      dateController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                textEditingController: dateController
              ),
            ),
          Container(),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Pedido:"),
            margin: const EdgeInsets.only(right: 16, top: 4),
          ),
          Container(),
          Container(),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Cajas:"),
            margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                isEnabled: true,
                onChange: (value) {
                  box = int.tryParse(value);
                },
              ),
            ),
          Container(),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Cartones XL:"),
            margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                isEnabled: true,
                onChange: (value) {
                  xlCarton = int.tryParse(value);
                },
              ),
            ),
          Container(),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Cartones L:"),
            margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                isEnabled: true,
                onChange: (value) {
                  lCarton = int.tryParse(value);
                },
              ),
            ),
          Container(),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Cartones M:"),
            margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                isEnabled: true,
                onChange: (value) {
                  mCarton = int.tryParse(value);
                },
              ),
            ),
          Container(),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Cartones S:"),
            margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                isEnabled: true,
                onChange: (value) {
                  sCarton = int.tryParse(value);
                },
              ),
            ),
          Container(),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Precio total:"),
            margin: const EdgeInsets.only(right: 16, top: 4),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                isEnabled: true,
                onChange: (value) {
                  totalPrice = double.tryParse(value);
                },
              ),
            ),
          Container(
            child: Text("€"),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 4),
          ),
        ]
      ),
      
    ];
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Modificar', null, null, () {}, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Eliminar', 
                null, 
                null, 
                () {}, 
                null, 
              ),
        ])
    );
  }
}