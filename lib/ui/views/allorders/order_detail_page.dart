import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/data/models/order_model.dart';
import 'package:hueveria_nieto_interna/ui/views/allorders/modify_order_page.dart';
import 'package:hueveria_nieto_interna/utils/order_utils.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/client_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/constants.dart';
import '../../components/component_cell_table_form.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_table_form.dart';
import '../../components/component_table_form_with_subtitles.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(
      this.currentUser, this.clientModel, this.orderModel, this.deliveryPerson,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final ClientModel clientModel;
  final OrderModel orderModel;
  final InternalUserModel? deliveryPerson;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late InternalUserModel currentUser;
  late ClientModel clientModel;
  late OrderModel orderModel;
  late InternalUserModel? deliveryPerson;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    clientModel = widget.clientModel;
    orderModel = widget.orderModel;
    deliveryPerson = widget.deliveryPerson;
  }

  String deliveryPersonStr = "";

  @override
  Widget build(BuildContext context) {
    if (deliveryPerson != null) {
      deliveryPersonStr = deliveryPerson!.id.toString() +
          " - " +
          deliveryPerson!.name +
          " " +
          deliveryPerson!.surname;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Detalle de pedido',
              style: TextStyle(fontSize: 18),
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
                      Row(
                        children: [
                          const Text("ID pedido:", style: TextStyle(fontWeight: FontWeight.bold),),
                          const SizedBox(width: 8,),
                          Text(orderModel.orderId.toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      getAllFormElements(),
                      const SizedBox(
                        height: 40,
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
      String status =
          Utils().getKey(Constants().orderStatus, orderModel.status);
      deliveryDatetimeAux =
          "$status - ${Utils().parseTimestmpToString(orderModel.approxDeliveryDatetime) ?? ""}";
    } else if (orderModel.status == 4) {
      deliveryDatetimeAux =
          Utils().parseTimestmpToString(orderModel.deliveryDatetime!) ?? "";
    } else if (orderModel.status == 5) {
      String status =
          Utils().getKey(Constants().orderStatus, orderModel.status);
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
        dt = Utils().parseTimestmpToString(orderModel.approxDeliveryDatetime) ??
            "";
      }
      deliveryDatetimeAux = dt;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDropdownComponentSimpleForm('Empresa', clientModel.company),
        getTextComponentSimpleForm('Dirección', null, clientModel.direction),
        getTextComponentSimpleForm('CIF', null, clientModel.cif),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        getComponentTableWithSubtitlesForm('Pedido', getPricePerUnitTableRow()),
        const SizedBox(height: 16,),
        getTextComponentSimpleForm(
            'Precio total', null, (orderModel.totalPrice ?? "").toString()),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 150,
                child: CheckboxListTile(
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
        getDropdownComponentSimpleForm('Método de pago',
            OrderUtils().paymentMethodIntToString(orderModel.paymentMethod)),
        getTextComponentSimpleForm('Fecha de pedido', null,
            Utils().parseTimestmpToString(orderModel.orderDatetime) ?? ""),
        getTextComponentSimpleForm(
            'Fecha de entrega', null, deliveryDatetimeAux),
        getDropdownComponentSimpleForm('Repartidor', deliveryPersonStr),
        getTextComponentSimpleForm(
            'Albarán', null, (orderModel.deliveryNote ?? "").toString()),
        getTextComponentSimpleForm(
            'Lote', null, (orderModel.lot ?? "").toString()),
        getTextComponentSimpleForm(
            'DNI de entrega', null, orderModel.deliveryDni ?? ""),
        const SizedBox(height: 24,),
        getDropdownComponentSimpleForm('Estado',
            OrderUtils().orderStatusIntToString(orderModel.status) ?? ""),
      ],
    );
  }

  Widget getButtonsComponent() {
    bool isModifyEnabled = true;
    bool isDeleteEnabled = true;
    if (orderModel.status == Constants().orderStatus["Cancelado"]) {
      isModifyEnabled = false;
      isDeleteEnabled = false;
    } else if (orderModel.status == Constants().orderStatus["Entregado"]) {
      isDeleteEnabled = false;
    }
    return Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton).getTypedButton(
              'Modificar',
              null,
              null,
              isModifyEnabled ? navigateToModifyOrder : null,
              null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
              'Eliminar',
              null,
              null,
              isDeleteEnabled ? deleteWarningOrder : null,
              null),
        ],
    );
  }

  Widget getDropdownComponentSimpleForm(String label, String value) {
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
        const [],
        labelText: value,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        initialValue: value,
        isEnabled: false,
        onChange: null,
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget getTextComponentSimpleForm(
      String label, String? labelInputText, String value) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentSimpleForm(
      label + ':',
      8,
      40,
      const EdgeInsets.symmetric(horizontal: 16),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      componentTextInput: HNComponentTextInput(
        labelText: value,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        isEnabled: false,
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget getComponentTableForm(String label, List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentTableForm(
      label + ":",
      8,
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget getComponentTableWithSubtitlesForm(String label, List<Widget> children,) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentTableFormWithSubtitles(
      label + ":",
      8,
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  List<Widget> getPricePerUnitTableRow() {
    List<Widget> list = [];

    for (var item in Constants().productClasses) {
      String dozenKey = "${item.toLowerCase()}_dozen";
      String boxKey = "${item.toLowerCase()}_box";
      num? dozenPrice;
      num dozenQuantity = 0;
      num? boxPrice;
      num boxQuantity = 0;

      if (orderModel.order.containsKey(dozenKey) &&
          orderModel.order[dozenKey] != null) {
        if (orderModel.order[dozenKey]!.containsKey("price")) {
          dozenPrice = orderModel.order[dozenKey]!["price"];
        }
        if (orderModel.order[dozenKey]!.containsKey("quantity") &&
            orderModel.order[dozenKey]!["quantity"] != null) {
          dozenQuantity = orderModel.order[dozenKey]!["quantity"]!;
        }
      }
      if (orderModel.order.containsKey(boxKey) &&
          orderModel.order[boxKey] != null) {
        if (orderModel.order[boxKey]!.containsKey("price")) {
          boxPrice = orderModel.order[boxKey]!["price"];
        }
        if (orderModel.order[boxKey]!.containsKey("quantity") &&
            orderModel.order[boxKey]!["quantity"] != null) {
          boxQuantity = orderModel.order[boxKey]!["quantity"]!;
        }
      }

      list.add(
        Container(
          child: Text("Huevos tamaño " + item + ":", style: const TextStyle(fontWeight: FontWeight.bold)),
          margin: const EdgeInsets.only(left: 12, right: 16),
        ));
      list.add(
        const SizedBox(height: 4,)
      );

      list.add(
        Table(
          columnWidths: const {
              0: IntrinsicColumnWidth(),
              2: FixedColumnWidth(96)
            },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 24, right: 16),
                    child: const Text("Docena")),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 0, right: 4, bottom: 0),
                  child: HNComponentTextInput(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    textInputType: const TextInputType.numberWithOptions(),
                    labelText: dozenQuantity.toString(),
                    isEnabled: false,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only( right: 16),
                    child: Text("${dozenPrice ?? "-"} €/ud", textAlign: TextAlign.end,)),
              ],
            ),
            TableRow(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 24, right: 16),
                    child: const Text("Caja")),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 0, right: 4, bottom: 0),
                  child: HNComponentTextInput(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    textInputType: const TextInputType.numberWithOptions(),
                    labelText: boxQuantity.toString(),
                    isEnabled: false,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Text("${boxPrice ?? "-"} €/ud", textAlign: TextAlign.end,)),
              ]
            )
          ]
        ));
        
      list.add(
        const SizedBox(height: 4,)
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
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              initialValue: clientModel.phone[0].values.first.toString(),
              isEnabled: false,
            )),
      ]),
    ];
  }

  deleteWarningOrder() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Aviso importante'),
              content: const Text(
                  'Esta acción es irreversible. ¿Está seguro de que quiere eliminar el pedido?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Continuar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteOrder();
                  },
                )
              ],
            ));
  }

  deleteOrder() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    bool conf = await FirebaseUtils.instance
        .deleteOrder(clientModel.documentId!, orderModel.documentId!);

    Navigator.pop(context);
    if (conf) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Pedido eliminado'),
                content:
                    const Text('El pedido ha sido eliminado correctamente.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Se ha producido un error al eliminar el pedido. Revise los datos e inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  )
                ],
              ));
    }
  }

  navigateToModifyOrder() async {
    var futureEggPrices = await FirebaseUtils.instance.getEggPrices();
    Map<String, dynamic> valuesMap = futureEggPrices.docs[0].data()["values"];

    var futureUsers = await FirebaseUtils.instance.getAllDeliveryPersonFuture();
    List<InternalUserModel> deliveryPersonList = [];
    for (var user in futureUsers.docs) {
      try {
        deliveryPersonList.add(InternalUserModel.fromMap(user.data(), user.id));
      } catch (e) {
        //
      }
    }

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifyOrderPage(currentUser, clientModel,
              orderModel, valuesMap, deliveryPersonList),
        ));

    if (result != null) {
      orderModel = result;
      setState(() {
        orderModel = result;
      });
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
