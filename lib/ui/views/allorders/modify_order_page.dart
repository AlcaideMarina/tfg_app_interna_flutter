import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/local/bd_order_field_data.dart';
import '../../../data/models/local/egg_prices_data.dart';
import '../../../data/models/order_model.dart';
import '../../../flutterfire/firebase_utils.dart';
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
  const ModifyOrderPage(this.currentUser, this.clientModel, this.orderModel,
      this.eggPricesMap, this.internalUserModelList,
      {Key? key})
      : super(key: key);

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
  late List<InternalUserModel> internalUserModelList;
  late DBOrderFieldData dbOrderFieldData;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    clientModel = widget.clientModel;
    orderModel = widget.orderModel;
    valuesMap = widget.eggPricesMap;
    internalUserModelList = widget.internalUserModelList;
    eggPricesData = EggPricesData(
        valuesMap['xl_box'],
        valuesMap['xl_dozen'],
        valuesMap['l_box'],
        valuesMap['l_dozen'],
        valuesMap['m_box'],
        valuesMap['m_dozen'],
        valuesMap['s_box'],
        valuesMap['s_dozen']);
    dbOrderFieldData =
        OrderUtils().dbOrderModelFromTwoSources(orderModel, eggPricesData);

    // Datos cliente
    company = clientModel.company;
    direction = clientModel.direction;
    cif = clientModel.cif;
    phone = clientModel.phone[0].values.first;
    namePhone = clientModel.phone[0].keys.first;
    // Datos pedido (sólo cantidades)
    xlDozen = dbOrderFieldData.xlDozenQuantity ?? 0;
    xlBox = dbOrderFieldData.xlBoxQuantity ?? 0;
    lDozen = dbOrderFieldData.lDozenQuantity ?? 0;
    lBox = dbOrderFieldData.lBoxQuantity ?? 0;
    mDozen = dbOrderFieldData.mDozenQuantity ?? 0;
    mBox = dbOrderFieldData.mBoxQuantity ?? 0;
    sDozen = dbOrderFieldData.sDozenQuantity ?? 0;
    sBox = dbOrderFieldData.sBoxQuantity ?? 0;
    // Datos pedido
    totalPrice = orderModel.totalPrice ?? 0;
    paid = orderModel.paid;
    paymentMethod =
        OrderUtils().paymentMethodIntToString(orderModel.paymentMethod);
    orderTimestamp = orderModel.orderDatetime;
    deliveryPerson = orderModel.deliveryPerson;
    deliveryNote = orderModel.deliveryNote ?? -1;
    lot = orderModel.lot ?? "";
    deliveryDni = orderModel.deliveryDni ?? "";
    status = OrderUtils().orderStatusIntToString(orderModel.status) ?? "";
    datePickerTimestamp = orderModel.approxDeliveryDatetime;
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
  Timestamp orderTimestamp = Timestamp
      .now(); // Esto no se setea en el initstate porque se hace más abajo.
  Timestamp deliveryTimestamp = Timestamp.now();
  String deliveryDatetimeStr =
      ""; //Utils().parseTimestmpToString(deliveryTimestamp) ?? "";
  String? deliveryPerson;
  int? deliveryNote;
  String? lot;
  String? deliveryDni;
  String status = "";

  List<String> paymentMethodItems = [];
  List<String> deliveryPersonItems = [];
  Map<String, String> deliveryPersonItemsMap = {};
  List<String> statusItem = [];

  TextEditingController dateController = TextEditingController();
  DateTime minDate = DateTime.now().add(const Duration(days: 3));
  late Timestamp? datePickerTimestamp;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  Map<String, int> productQuantities = {};

  @override
  Widget build(BuildContext context) {
    if (paymentMethodItems.isEmpty) {
      for (String key in Constants().paymentMethods.keys) {
        paymentMethodItems.add(key);
      }
    }
    if (deliveryPersonItems.isEmpty) {
      bool contains = false;
      for (InternalUserModel user in internalUserModelList) {
        if (deliveryPerson == user.documentId!) {
          contains = true;
          deliveryPerson =
              user.id.toString() + " - " + user.name + " " + user.surname;
        }
        deliveryPersonItems
            .add(user.id.toString() + " - " + user.name + " " + user.surname);
        deliveryPersonItemsMap[user.id.toString() +
            " - " +
            user.name +
            " " +
            user.surname] = user.documentId!;
      }
      if (deliveryPerson != null && !contains) {
        deliveryPersonItems.add("Antiguo repartidor");
        deliveryPersonItemsMap["Antiguo repartidor"] = deliveryPerson!;
        deliveryPerson = "Antiguo repartidor";
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
    // TODO: Pasar esto también a detalle de pedido
    List<int> statusApproxDeliveryDatetimeList = [0, 1, 2];
    String deliveryDatetimeAux;

    if (statusApproxDeliveryDatetimeList.contains(orderModel.status)) {
      deliveryDatetimeAux =
          Utils().parseTimestmpToString(orderModel.approxDeliveryDatetime) ??
              "";
    } else if (orderModel.status == 4) {
      deliveryDatetimeAux =
          Utils().parseTimestmpToString(orderModel.deliveryDatetime!) ?? "";
    } else if (orderModel.status == 5) {
      String status =
          Utils().getKey(Constants().orderStatus, orderModel.status);
      String dt;
      if (orderModel.deliveryDatetime != null) {
        dt = Utils().parseTimestmpToString(orderModel.deliveryDatetime ??
                orderModel.approxDeliveryDatetime) ??
            "";
      } else {
        dt = "";
      }
      deliveryDatetimeAux = "$status - $dt";
    } else {
      String dt;
      if (orderModel.deliveryDatetime != null) {
        dt = Utils().parseTimestmpToString(orderModel.deliveryDatetime!) ?? "";
      } else {
        dt = Utils().parseTimestmpToString(orderModel.approxDeliveryDatetime) ??
            "";
      }
      deliveryDatetimeAux = dt;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: Esto no está deshabilitado
        getDropdownComponentSimpleForm('Empresa', clientModel.company, null,
            TextInputType.none, null, [], false),
        getTextComponentSimpleForm(
            'Dirección', clientModel.direction, TextInputType.streetAddress,
            (value) {
          direction = value;
        }, isEnabled: false),
        getTextComponentSimpleForm('CIF', clientModel.cif, TextInputType.text,
            (value) {
          cif = value;
        }, isEnabled: false),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        getComponentTableForm('Pedido', getPricePerUnitTableRow(),
            columnWidhts: {
              0: const IntrinsicColumnWidth(),
              2: const IntrinsicColumnWidth()
            }),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 150,
                child: CheckboxListTile(
                  title: Text("Pagado"),
                  enabled: true,
                  value: paid,
                  onChanged: (newValue) {
                    paid = newValue ?? false;
                    setState(() {});
                  },
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
        ),
        // TODO: Esto no se inhabilita
        orderModel.paid
            ? getDropdownComponentSimpleForm(
                'Método de pago',
                OrderUtils().paymentMethodIntToString(orderModel.paymentMethod),
                null,
                TextInputType.none,
                null,
                [],
                false)
            : getDropdownComponentSimpleForm(
                'Método de pago',
                null,
                OrderUtils().paymentMethodIntToString(orderModel.paymentMethod),
                TextInputType.none, (value) {
                paymentMethod = value;
              }, paymentMethodItems, orderModel.paid),
        getTextComponentSimpleForm(
            'Fecha de pedido',
            Utils().parseTimestmpToString(orderModel.orderDatetime) ?? "",
            TextInputType.none,
            null,
            isEnabled: false),

        [2, 3, 4].contains(orderModel.status)
            ? getTextComponentSimpleForm('Fecha de entrega',
                deliveryDatetimeAux, TextInputType.none, null,
                isReadOnly: true, isEnabled: false)
            : getTextComponentSimpleForm('Fecha de entrega',
                deliveryDatetimeAux, TextInputType.none, null, isReadOnly: true,
                onTap: () async {
                // TODO: Cambiar el color
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: minDate,
                    firstDate: minDate,
                    lastDate: DateTime(DateTime.now().year + 1,
                        DateTime.now().month, minDate.day));
                if (pickedDate != null) {
                  setState(() {
                    datePickerTimestamp = Timestamp.fromDate(pickedDate);
                    dateController.text = dateFormat.format(pickedDate);
                  });
                }
              }, textEditingController: dateController),
        getDropdownComponentSimpleForm(
            'Repartidor', null, deliveryPerson, TextInputType.none, (value) {
          deliveryPerson = value;
        }, deliveryPersonItems, true),
        getTextComponentSimpleForm(
            'Albarán',
            (orderModel.deliveryNote ?? "").toString(),
            TextInputType.number, (value) {
          deliveryNote = int.tryParse(value);
        }),
        getTextComponentSimpleForm(
            'Lote', (orderModel.lot ?? "").toString(), TextInputType.text,
            (value) {
          lot = value;
        }),
        getTextComponentSimpleForm(
            'DNI de entrega', orderModel.deliveryDni ?? "", TextInputType.text,
            (value) {
          deliveryDni = value;
        }, isEnabled: !(orderModel.status == 3)),
        (orderModel.status == 3)
            ? getDropdownComponentSimpleForm(
                'Estado',
                OrderUtils().orderStatusIntToString(orderModel.status) ?? "",
                null,
                TextInputType.none,
                null,
                [],
                false)
            : getDropdownComponentSimpleForm(
                'Estado',
                null,
                OrderUtils().orderStatusIntToString(orderModel.status) ?? "",
                TextInputType.none, (value) {
                status = value;
              }, statusItem, !(orderModel.status == 3)),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton).getTypedButton(
              'Guardar', null, null, updateGetPriceButton, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Cancelar', null, null, goBack, null),
        ],
      ),
    );
  }

  Widget getDropdownComponentSimpleForm(
      String label,
      String? labelText,
      String? value,
      TextInputType textInputType,
      Function(dynamic)? onChange,
      List<String> items,
      bool isEnabled,
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentSimpleForm(
      '$label:',
      8,
      40,
      const EdgeInsets.symmetric(horizontal: 16),
      EdgeInsets.only(
        top: topMargin,
        bottom: bottomMargin,
      ),
      componentDropdown: HNComponentDropdown(
        items,
        labelText: labelText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        initialValue: value,
        isEnabled: isEnabled,
        onChange: onChange,
      ),
    );
  }

  Widget getTextComponentSimpleForm(String label, String initialValue,
      TextInputType textInputType, Function(String)? onChange,
      {TextCapitalization textCapitalization = TextCapitalization.sentences,
      TextEditingController? textEditingController,
      bool isEnabled = true,
      bool isReadOnly = false,
      Future<dynamic> Function()? onTap}) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentSimpleForm(
      label + ':',
      8,
      40,
      const EdgeInsets.symmetric(horizontal: 16),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      componentTextInput: HNComponentTextInput(
        textCapitalization: textCapitalization,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textInputType: textInputType,
        onChange: onChange,
        isEnabled: isEnabled,
        initialValue: initialValue,
      ),
    );
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
    bool orderEnabled = true;
    if (orderModel.paid) {
      orderEnabled = false;
    }

    for (var item in Constants().productClasses) {
      String dozenKey = "${item.toLowerCase()}_dozen";
      String boxKey = "${item.toLowerCase()}_box";
      num? dozenPrice;
      num dozenQuantity = 0;
      num? boxPrice;
      num boxQuantity = 0;
      if (valuesMap[dozenKey] != null) {
        dozenPrice = valuesMap[dozenKey];
      }
      if (valuesMap[boxKey] != null) {
        boxPrice = valuesMap[boxKey];
      }
      if (orderModel.order.containsKey(dozenKey) &&
          orderModel.order[dozenKey] != null) {
        if (orderModel.order[dozenKey]!.containsKey("quantity") &&
            orderModel.order[dozenKey]!["quantity"] != null) {
          productQuantities[dozenKey] =
              orderModel.order[dozenKey]!["quantity"]!.toInt();
        }
      }
      if (orderModel.order.containsKey(boxKey) &&
          orderModel.order[boxKey] != null) {
        if (orderModel.order[boxKey]!.containsKey("quantity") &&
            orderModel.order[boxKey]!["quantity"] != null) {
          productQuantities[boxKey] =
              orderModel.order[boxKey]!["quantity"]!.toInt();
        }
      }

      list.add(TableRow(children: [
        Container(
          child: Text(item),
          margin: const EdgeInsets.only(left: 12, right: 16),
        ),
        Container(),
        Container()
      ]));

      list.add(TableRow(
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
              initialValue: (productQuantities[dozenKey] ?? 0).toString(),
              isEnabled: orderEnabled,
              onChange: (value) {
                String key = "${item.toLowerCase()}_dozen";
                productQuantities[key] = int.tryParse(value) ?? 0;
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("${dozenPrice ?? ""} €")),
        ],
      ));

      list.add(TableRow(children: [
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
            initialValue: (productQuantities[boxKey] ?? 0).toString(),
            isEnabled: orderEnabled,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("${boxPrice ?? ""} €")),
      ]));
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
            40, const EdgeInsets.only(left: 8, right: 16, bottom: 8),
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

  goBack() {
    Navigator.of(context).pop();
  }

  updateGetPriceButton() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    if (checkFields()) {
      if (OrderUtils().orderStatusStringToInt(status) == 3 &&
          deliveryDni == null) {
        DBOrderFieldData dbOrderFieldData =
            OrderUtils().getOrderStructure(productQuantities, eggPricesData);
        double totalPrice =
            Utils().roundDouble(getTotalPrice(dbOrderFieldData), 2);
        if (context.mounted) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Precio final'),
                    content: Text(
                        'El precio total del pedido será de $totalPrice €. ¿Desea continuar?'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.of(this.context).pop();
                          },
                          child: const Text("Atrás")),
                      TextButton(
                          onPressed: () {
                            // TODO: Guardar pedido
                            updateOrder(dbOrderFieldData, totalPrice);
                          },
                          child: const Text("Continuar")),
                    ],
                  ));
        }
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Falta el DNI de entrega'),
                  content: const Text(
                      'No se puede marcar un pedido como entregado si falta el DNI que confirme la entrega.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('De acuerdo.'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Formulario incompleto'),
                content: const Text(
                    'Debe rellenar todos los campos del formulario. Por favor revise los datos e inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  updateOrder(DBOrderFieldData dbOrderFieldData, double totalPrice) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    OrderModel updateOrderModel = OrderModel(
        datePickerTimestamp!,
        orderModel.clientId,
        orderModel.company,
        orderModel.createdBy,
        deliveryTimestamp,
        deliveryDni,
        deliveryNote == -1 ? null : deliveryNote,
        deliveryPersonItemsMap[deliveryPerson],
        lot,
        orderModel.notes,
        dbOrderFieldData.toMap(),
        orderModel.orderDatetime,
        orderModel.orderId,
        paid,
        OrderUtils().paymentMethodStringToInt(paymentMethod),
        OrderUtils().orderStatusStringToInt(status),
        totalPrice,
        orderModel.documentId);

    bool firestoreConf = await FirebaseUtils.instance
        .updateOrder(clientModel.documentId!, updateOrderModel);
    if (firestoreConf) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Pedido realizado"),
                content: const Text(
                    "Los datos del pedido se han actualizado correctamente"),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                      Navigator.pop(context, updateOrderModel);
                    },
                  )
                ],
              ));
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Se ha producido un error cuando se estaban actualizado los datos del pedido. Por favor, revise los datos e inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  bool checkFields() {
    if (clientModel != null &&
        paymentMethod != null &&
        datePickerTimestamp != null &&
        isOrder()) {
      return true;
    } else {
      return false;
    }
  }

  double getTotalPrice(DBOrderFieldData dbOrderFieldData) {
    double totalPrice = 0.0;

    if (dbOrderFieldData.xlBoxQuantity != null &&
        dbOrderFieldData.xlBoxPrice != null) {
      totalPrice += (dbOrderFieldData.xlBoxQuantity as int) *
          (dbOrderFieldData.xlBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.xlDozenQuantity != null &&
        dbOrderFieldData.xlDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.xlDozenQuantity as int) *
          (dbOrderFieldData.xlDozenQuantity!.toDouble());
    }
    if (dbOrderFieldData.lBoxQuantity != null &&
        dbOrderFieldData.lBoxPrice != null) {
      totalPrice += (dbOrderFieldData.lBoxQuantity as int) *
          (dbOrderFieldData.lBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.lDozenQuantity != null &&
        dbOrderFieldData.lDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.lDozenQuantity as int) *
          (dbOrderFieldData.lDozenQuantity!.toDouble());
    }
    if (dbOrderFieldData.mBoxQuantity != null &&
        dbOrderFieldData.mBoxPrice != null) {
      totalPrice += (dbOrderFieldData.mBoxQuantity as int) *
          (dbOrderFieldData.mBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.mDozenQuantity != null &&
        dbOrderFieldData.mDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.mDozenQuantity as int) *
          (dbOrderFieldData.mDozenQuantity!.toDouble());
    }
    if (dbOrderFieldData.sBoxQuantity != null &&
        dbOrderFieldData.sBoxPrice != null) {
      totalPrice += (dbOrderFieldData.sBoxQuantity as int) *
          (dbOrderFieldData.sBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.sDozenQuantity != null &&
        dbOrderFieldData.sDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.sDozenQuantity as int) *
          (dbOrderFieldData.sDozenQuantity!.toDouble());
    }
    return totalPrice;
  }

  bool isOrder() {
    if ((productQuantities.containsKey("xl_box") &&
            productQuantities["xl_box"] != 0) ||
        (productQuantities.containsKey("xl_dozen") &&
            productQuantities["xl_dozen"] != 0) ||
        (productQuantities.containsKey("l_box") &&
            productQuantities["l_box"] != 0) ||
        (productQuantities.containsKey("l_dozen") &&
            productQuantities["l_dozen"] != 0) ||
        (productQuantities.containsKey("m_box") &&
            productQuantities["m_box"] != 0) ||
        (productQuantities.containsKey("m_dozen") &&
            productQuantities["m_dozen"] != 0) ||
        (productQuantities.containsKey("s_box") &&
            productQuantities["s_box"] != 0) ||
        (productQuantities.containsKey("s_dozen") &&
            productQuantities["s_dozen"] != 0)) {
      return true;
    } else {
      return false;
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
