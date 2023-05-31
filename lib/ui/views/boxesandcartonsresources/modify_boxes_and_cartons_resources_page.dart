import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/boxes_and_cartons_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/material_utils.dart';
import 'package:hueveria_nieto_interna/utils/order_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/local/db_boxes_and_cartons_order_field_data.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyBoxesAndCartonsResourcesPage extends StatefulWidget {
  const ModifyBoxesAndCartonsResourcesPage(this.currentUser, this.bcResourcesModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final BoxesAndCartonsResourcesModel bcResourcesModel;

  @override
  State<ModifyBoxesAndCartonsResourcesPage> createState() => _ModifyBoxesAndCartonsResourcesPageState();
}

class _ModifyBoxesAndCartonsResourcesPageState extends State<ModifyBoxesAndCartonsResourcesPage> {
  late InternalUserModel currentUser;
  late BoxesAndCartonsResourcesModel bcResourcesModel;
  late DBBoxesAndCartonsOrderFieldData orderFieldData;
  late int? box;
  late int? xlCarton;
  late int? lCarton;
  late int? mCarton;
  late int? sCarton;
  late double? totalPrice;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    bcResourcesModel = widget.bcResourcesModel;
    
    orderFieldData = MaterialUtils().bcOrderToDBBoxesAndCartonsOrderModel(bcResourcesModel);

    box = orderFieldData.box;
    xlCarton = orderFieldData.xlCarton;
    lCarton = orderFieldData.lCarton;
    mCarton = orderFieldData.mCarton;
    sCarton = orderFieldData.sCarton;
    totalPrice = bcResourcesModel.totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Añadir Cajas/Cartones',
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

    DBBoxesAndCartonsOrderFieldData fieldData = DBBoxesAndCartonsOrderFieldData.fromMap(bcResourcesModel.order);

    return [
      TableRow(
        children: [
          Container(
            child: Text("Fecha:"),
            margin: const EdgeInsets.only(right: 16),
          ),
          Container(
            child: Text(Utils().parseTimestmpToString(bcResourcesModel.expenseDatetime) ?? ""),
            margin: const EdgeInsets.only(left: 16),
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
                initialValue: (fieldData.box ?? "").toString(),
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
                initialValue: (fieldData.xlCarton ?? "").toString(),
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
                initialValue: (fieldData.lCarton ?? "").toString(),
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
                initialValue: (fieldData.mCarton ?? "").toString(),
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
                initialValue: (fieldData.sCarton ?? "").toString(),
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
                initialValue: bcResourcesModel.totalPrice.toString(),
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
