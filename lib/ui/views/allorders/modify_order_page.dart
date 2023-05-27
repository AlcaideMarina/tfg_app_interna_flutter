import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/local/bd_order_field_data.dart';
import '../../../data/models/local/egg_prices_data.dart';
import '../../../data/models/order_model.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants.dart';
import '../../../utils/order_utils.dart';
import '../../components/component_cell_table_form.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_table_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyOrderPage extends StatefulWidget {
  const ModifyOrderPage(this.currentUser, this.clientModel, this.orderModel, this.eggPricesMap, this.internalUserModelList, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final ClientModel clientModel;
  final OrderModel orderModel;
  final Map<String, dynamic> eggPricesMap;
  final List<InternalUserModel> internalUserModelList;
  
  @override
  State<ModifyOrderPage> createState() => _ModifyOrderPageState();
}

class _ModifyOrderPageState extends State<ModifyOrderPage> {
  
  late InternalUserModel currentUser;
  late ClientModel clientModel;
  late OrderModel orderModel;
  late Map<String, dynamic> valuesMap;
  late EggPricesData eggPricesData;
  late DBOrderFieldData dbOrderFieldQuantitiesData;
  late List<InternalUserModel> internalUserModelList;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    clientModel = widget.clientModel;
    orderModel = widget.orderModel;
    valuesMap = widget.eggPricesMap;
    internalUserModelList = widget.internalUserModelList;
    eggPricesData = EggPricesData(
      valuesMap['xl_box'], valuesMap['xl_dozen'], valuesMap['l_box'], 
      valuesMap['l_dozen'], valuesMap['m_box'], valuesMap['m_dozen'], 
      valuesMap['s_box'], valuesMap['s_dozen']);
    dbOrderFieldQuantitiesData = OrderUtils().orderDataToBDOrderModel(orderModel);

    // Datos cliente
    company = clientModel.company;
    direction = clientModel.direction;
    cif = clientModel.cif;
    phone = clientModel.phone[0].values.first;
    namePhone = clientModel.phone[0].keys.first;
    // Datos pedido (sólo cantidades)
    xlDozen = dbOrderFieldQuantitiesData.xlDozenQuantity ?? 0;
    xlBox = dbOrderFieldQuantitiesData.xlBoxQuantity ?? 0;
    lDozen = dbOrderFieldQuantitiesData.lDozenQuantity ?? 0;
    lBox = dbOrderFieldQuantitiesData.lBoxQuantity ?? 0;
    mDozen = dbOrderFieldQuantitiesData.mDozenQuantity ?? 0;
    mBox = dbOrderFieldQuantitiesData.mBoxQuantity ?? 0;
    sDozen = dbOrderFieldQuantitiesData.sDozenQuantity ?? 0;
    sBox = dbOrderFieldQuantitiesData.sBoxQuantity ?? 0;
    // Datos pedido
    totalPrice = orderModel.totalPrice ?? 0;
    paid = orderModel.paid;
    paymentMethod = OrderUtils().paymentMethodIntToString(orderModel.paymentMethod);
    orderTimestamp = orderModel.orderDatetime;
    deliveryPerson = orderModel.deliveryPerson;
    deliveryNote = orderModel.deliveryNote ?? -1;
    lot = orderModel.lot ?? "";
    deliveryDni = orderModel.deliveryDni ?? "";
    status = OrderUtils().orderStatusIntToString(orderModel.status) ?? "";
  }

  String company = "";
  String direction = "";
  String cif = "";
  int phone = -1;
  String namePhone = "";
  int xlDozen = 0;
  int xlBox = 0;
  int lDozen = 0;
  int lBox = 0;
  int mDozen = 0;
  int mBox = 0;
  int sDozen = 0;
  int sBox = 0; 
  double totalPrice = 0;
  bool paid = false;
  String paymentMethod = "";
  Timestamp orderTimestamp = Timestamp.now();   // Esto no se setea en el initstate porque se hace más abajo.
  Timestamp deliveryTimestamp = Timestamp.now();
  String deliveryDatetimeStr = "";//Utils().parseTimestmpToString(deliveryTimestamp) ?? "";
  String? deliveryPerson;
  int deliveryNote = -1;
  String lot = "";
  String deliveryDni = "";
  String status = "";

  
  List<String> paymentMethodItems = [];
  List<String> deliveryPersonItems = [];
  Map<String, String> deliveryPersonItemsMap = {};
  List<String> statusItem = [];

  @override
  Widget build(BuildContext context) {

    if (paymentMethodItems.isEmpty) {
      for (String key in Constants().paymentMethods.keys) {
        paymentMethodItems.add(key);
      }
    }
    if (deliveryPersonItems.isEmpty) {
      for (InternalUserModel user in internalUserModelList) {
        deliveryPersonItems.add(user.id.toString() + " - " + user.name + " " + user.surname);
        deliveryPersonItemsMap[user.id.toString() + " - " + user.name + " " + user.surname] = user.documentId!;
      }
    }
    if (statusItem.isEmpty) {
      for (String key in Constants().orderStatus.keys) {
        statusItem.add(key);
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Modificar pedido',
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
                      Text("ID: " + orderModel.orderId.toString()),
                      const SizedBox(
                        height: 8,
                      ),
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
        getDropdownComponentSimpleForm('Empresa', null, clientModel.company, TextInputType.none, null, [clientModel.company], false),
        getTextComponentSimpleForm('Dirección', null, clientModel.direction),
        getTextComponentSimpleForm('CIF', null, clientModel.cif),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        getComponentTableForm('Pedido', getPricePerUnitTableRow(), 
            columnWidhts: {
              0: const IntrinsicColumnWidth(),
              2: const IntrinsicColumnWidth()
            }),
        getTextComponentSimpleForm('Precio total', null, (orderModel.totalPrice ?? "").toString()),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 150,
                child: 
                    CheckboxListTile(
                      title: Text("Pagado"),
                      enabled: false,
                      value: orderModel.paid,
                      onChanged: (newValue) {},
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
              ),
            ],
          ),
        ),
        getDropdownComponentSimpleForm('Método de pago', null,
            OrderUtils().paymentMethodIntToString(orderModel.paymentMethod), TextInputType.none, 
            (value) {
              paymentMethod = value;
            }, paymentMethodItems, true), 
        getTextComponentSimpleForm('Fecha de pedido', null, Utils().parseTimestmpToString(orderModel.orderDatetime) ?? ""),
        getTextComponentSimpleForm('Fecha de entrega', null, deliveryDatetimeAux),
        getDropdownComponentSimpleForm('Repartidor', null, orderModel.deliveryPerson, TextInputType.none, 
            (value) {
              deliveryPerson = value;
            }, deliveryPersonItems, true),
        getTextComponentSimpleForm('Albarán', null, (orderModel.deliveryNote ?? "").toString()),
        getTextComponentSimpleForm('Lote', null, (orderModel.lot ?? "").toString()),
        getTextComponentSimpleForm('DNI de entrega', null, orderModel.deliveryDni ?? ""),
        getDropdownComponentSimpleForm('Estado', null, OrderUtils().orderStatusIntToString(orderModel.status) ?? "", TextInputType.none,
            (value) {
              status = value;
            }, statusItem, true),
      ],
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
              .getTypedButton('Cancelar', null, null, () {}, null),
        ],
      ),
    );
  }

  Widget getDropdownComponentSimpleForm(String label, String? labelText, String? value, 
      TextInputType textInputType, Function(dynamic)? onChange, List<String> items,
      bool isEnabled,
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
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
            items,
            labelText: labelText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            initialValue: value,
            isEnabled: isEnabled,
            onChange: onChange,
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
          isEnabled: false,
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
                isEnabled: false,
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
                isEnabled: false,
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