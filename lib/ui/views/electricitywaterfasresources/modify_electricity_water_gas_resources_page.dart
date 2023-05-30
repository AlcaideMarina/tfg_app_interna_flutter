import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/electricity_water_gas_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyElectricityWaterGasResourcesPage extends StatefulWidget {
  const ModifyElectricityWaterGasResourcesPage(this.currentUser, this.ewgModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final ElectricityWaterGasResourcesModel ewgModel;

  @override
  State<ModifyElectricityWaterGasResourcesPage> createState() => _ModifyElectricityWaterGasResourcesPageState();
}

class _ModifyElectricityWaterGasResourcesPageState extends State<ModifyElectricityWaterGasResourcesPage> {
  late InternalUserModel currentUser;
  late ElectricityWaterGasResourcesModel ewgModel;
  late int type;
  late String typeStr;
  late double? totalPrice;
  late String? notes;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    ewgModel = widget.ewgModel;

    type = ewgModel.type;
    typeStr = Utils().getKey(Constants().ewgTypes, type);
    totalPrice = ewgModel.totalPrice;
    notes = ewgModel.notes;
  }

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
            child: Text(Utils().parseTimestmpToString(ewgModel.expenseDatetime) ?? ""),
            margin: const EdgeInsets.only(left: 16),
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
                initialValue: Utils().getKey(Constants().ewgTypes, ewgModel.type),
                onChange: (dynamic value) => {
                  typeStr = value!
                },
              ),
            ),
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
                initialValue: ewgModel.totalPrice.toString(),
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
                initialValue: ewgModel.notes,
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
                goBack, 
                null, 
              ),
        ])
    );
  }

  goBack() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

}
