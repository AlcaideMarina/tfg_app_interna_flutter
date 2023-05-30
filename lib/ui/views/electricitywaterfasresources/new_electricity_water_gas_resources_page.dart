import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class NewElectricityWaterGasResourcesPage extends StatefulWidget {
  const NewElectricityWaterGasResourcesPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  State<NewElectricityWaterGasResourcesPage> createState() => _NewElectricityWaterGasResourcesPageState();
}

class _NewElectricityWaterGasResourcesPageState extends State<NewElectricityWaterGasResourcesPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    
    dateController.text = dateFormat.format(minDate);
    datePickerTimestamp = Timestamp.fromDate(minDate);
  }

  TextEditingController dateController = TextEditingController();
  DateTime minDate = Utils().addToDate(DateTime.now(), yearsToAdd: -1);
  late Timestamp? datePickerTimestamp;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  
  int? type;
  String? typeStr;
  double? totalPrice;
  String? notes;

  List<String> typeItems = [];
  
  @override
  Widget build(BuildContext context) {

    if (typeItems.isEmpty) {
      for (String key in Constants().ewgTypes.keys) {
        typeItems.add(key);
      }
    }
    
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Modificar - Elect...',
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
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Tipo:"),
            margin: const EdgeInsets.only(right: 16, top: 4),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentDropdown(
                typeItems,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: TextInputType.text,
                isEnabled: false,
                onChange: (dynamic value) => {
                  typeStr = value!
                },
              ),
          )
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
        ]
      ),
      TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
              child: Text("Notas:"),
              margin: const EdgeInsets.only(right: 16, top: 16),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                textInputType: TextInputType.multiline,
                isEnabled: true,
                maxLines: 5,
                minLines: 5,
                textAlignVertical: TextAlignVertical.top,
                alignLabelWithHint: true,
                onChange: (value) {
                  notes = value;
                },
              ),
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

  goBack() {
    Navigator.of(context).pop();
  }
}