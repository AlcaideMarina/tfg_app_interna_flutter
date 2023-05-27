import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';
import 'package:hueveria_nieto_interna/utils/order_utils.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/client_model.dart';
import '../../../utils/constants.dart';
import '../../components/component_cell_table_form.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_table_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(this.currentUser, this.clientModel, this.orderModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final ClientModel clientModel;
  final OrderModel orderModel;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  late InternalUserModel currentUser;
  late ClientModel clientModel;
  late OrderModel orderModel;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    clientModel = widget.clientModel;
    orderModel = widget.orderModel;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Nuevo pedido',
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
                      getAllFormElements(),
                      const SizedBox(
                        height: 32,
                      ),
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

  Widget getAllFormElements() {

    List<int> statusApproxDeliveryDatetimeList = [0, 1, 2];
    String deliveryDatetimeAux;
    if (statusApproxDeliveryDatetimeList.contains(orderModel.status)) {
      String status = Utils().getKey(Constants().orderStatus, orderModel.status);
      deliveryDatetimeAux = "$status - ${Utils().parseTimestmpToString(orderModel.approxDeliveryDatetime) ?? ""}";
    } else if (orderModel.status == 4) {
      deliveryDatetimeAux = Utils().parseTimestmpToString(orderModel.deliveryDatetime!) ?? "";
    } else if (orderModel.status == 5) {
      String status = Utils().getKey(Constants().orderStatus, orderModel.status);
      String dt;
      if (orderModel.deliveryDatetime != null) {
        dt = Utils().parseTimestmpToString(orderModel.deliveryDatetime!) ?? "";
      } else {
        dt = "";
      }
      deliveryDatetimeAux = "$status - $dt";
    } else {
      String dt;
      if (orderModel.deliveryDatetime != null) {
        dt = Utils().parseTimestmpToString(orderModel.deliveryDatetime!) ?? "";
      } else {
        dt = Utils().parseTimestmpToString(orderModel.approxDeliveryDatetime) ?? "";
      }
      deliveryDatetimeAux = dt;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDropdownComponentSimpleForm('Empresa', null, clientModel.company),
        getTextComponentSimpleForm('Dirección', null, clientModel.direction),
        getTextComponentSimpleForm('CIF', null, clientModel.cif),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        getComponentTableForm('Pedido', getPricePerUnitTableRow(), 
            columnWidhts: {
              0: const IntrinsicColumnWidth(),
              2: const IntrinsicColumnWidth()
            }),
        getDropdownComponentSimpleForm('Método de pago', null, 
            OrderUtils().paymentMethodIntToString(orderModel.paymentMethod)), 
        getTextComponentSimpleForm('Fecha de entrega', null, Utils().parseTimestmpToString(orderModel.approxDeliveryDatetime)!),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Modificar', null, null, () {}, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Eliminar', null, null, () {}, () {}),
        ],
      ),
    );
  }

  Widget getDropdownComponentSimpleForm(String label, String? labelInputText, 
      String value) {
        double topMargin = 4;
        double bottomMargin = 4;
        
        return HNComponentSimpleForm(
        '$label:',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin,),
        componentDropdown: 
          HNComponentDropdown(
            [],
            labelText: labelInputText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            initialValue: value,
          ),
        );
  }

  Widget getTextComponentSimpleForm(String label, String? labelInputText,
      String value) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentSimpleForm(
        label + ':',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        componentTextInput: HNComponentTextInput(
          labelText: labelInputText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          initialValue: value,
        ),);
  }

  Widget getComponentTableForm(String label, List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentTableForm(
      label,
      8,
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }
  
  List<TableRow> getPricePerUnitTableRow() {
    List<TableRow> list = [];

    for (var item in Constants().productClasses) {
      String dozenKey = "${item.toLowerCase()}_dozen";
      String boxKey = "${item.toLowerCase()}_box";
      num? dozenPrice;
      num dozenQuantity = 0;
      num? boxPrice;
      num boxQuantity = 0;

      if (orderModel.order.containsKey(dozenKey) && orderModel.order[dozenKey] != null) {
        if (orderModel.order[dozenKey]!.containsKey("price")) {
          dozenPrice = orderModel.order[dozenKey]!["price"];
        }
        if (orderModel.order[dozenKey]!.containsKey("quantity") && orderModel.order[dozenKey]!["quantity"] != null) {
          dozenQuantity = orderModel.order[dozenKey]!["quantity"]!;
        }
      }
      if (orderModel.order.containsKey(boxKey) && orderModel.order[boxKey] != null) {
        if (orderModel.order[boxKey]!.containsKey("price")) {
          boxPrice = orderModel.order[boxKey]!["price"];
        }
        if (orderModel.order[boxKey]!.containsKey("quantity") && orderModel.order[boxKey]!["quantity"] != null) {
          boxQuantity = orderModel.order[boxKey]!["quantity"]!;
        }
      }

      list.add(
        TableRow(
          children: [
            Container(
              child: Text(item),
              margin: const EdgeInsets.only(left: 12, right: 16),
            ),
            Container(),
            Container()
          ]
        )
      );

      list.add(
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, right: 16, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: dozenQuantity.toString(),
                isEnabled: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("${dozenPrice ?? ""} €")),
          ],
        )
      );

      list.add(
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Caja")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, right: 16, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: boxQuantity.toString(),
                isEnabled: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("${boxPrice ?? ""} €")),
          ]
        )
      );
    }

    return list;

  }

  List<TableRow> getTelephoneTableRow() {
    return [
      TableRow(children: [
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 16, right: 8, bottom: 8),
            componentTextInput: HNComponentTextInput(
              labelText: 'Contacto',
              textCapitalization: TextCapitalization.words,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              initialValue: clientModel.phone[0].keys.first,
              isEnabled: false,
            ),
          ),
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 8, right: 16, bottom: 8),
            componentTextInput: HNComponentTextInput(
              labelText: 'Teléfono',
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              initialValue: clientModel.phone[0].values.first.toString(),
              isEnabled: false,
            )),
      ]),
    ];
  }
}