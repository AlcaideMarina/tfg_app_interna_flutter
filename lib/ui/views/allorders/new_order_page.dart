import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:hueveria_nieto_interna/utils/order_utils.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/local/bd_order_field_data.dart';
import '../../../data/models/local/egg_prices_data.dart';
import '../../../data/models/order_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_cell_table_form.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_table_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage(this.currentUser, this.eggPricesMap, this.clientModelList, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final Map<String, dynamic> eggPricesMap;
  final List<ClientModel> clientModelList;

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  late InternalUserModel currentUser;
  late Map<String, dynamic> valuesMap;
  late EggPricesData productPrices;
  late List<ClientModel> clientModelList;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    valuesMap = widget.eggPricesMap;
    productPrices = EggPricesData(
      valuesMap['xl_box'], valuesMap['xl_dozen'], valuesMap['l_box'], 
      valuesMap['l_dozen'], valuesMap['m_box'], valuesMap['m_dozen'], 
      valuesMap['s_box'], valuesMap['s_dozen']);
    clientModelList = widget.clientModelList;

    dateController.text = dateFormat.format(minDate);
    datePickerTimestamp = Timestamp.fromDate(minDate);

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
  String paymentMethod = "";
  Timestamp deliveryTimestamp = Timestamp.now();
  String deliveryDatetimeStr = "";//Utils().parseTimestmpToString(deliveryTimestamp) ?? "";

  int cont = 0;

  ClientModel? client;

  List<String> companyItems = [];
  Map<String, String> companyItemsMap = {};
  List<String> paymentMethodItems = [];

  TextEditingController dateController = TextEditingController();
  DateTime minDate = DateTime.now().add(const Duration(days: 3));
  late Timestamp? datePickerTimestamp;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  
  TextEditingController directionController = TextEditingController();
  TextEditingController cifController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController namePhoneController = TextEditingController();
  
  Map<String, int> productQuantities = {}; 

  @override
  Widget build(BuildContext context) {

    if (paymentMethodItems.isEmpty) {
      for (String key in Constants().paymentMethods.keys) {
        paymentMethodItems.add(key);
      }
    }

    if (companyItems.isEmpty) {
      clientModelList.sort((a, b) => a.id.compareTo(b.id));
      for (ClientModel client in clientModelList) {
        companyItems.add(client.id.toString() + " - " + client.company);
        companyItemsMap[client.id.toString() + " - " + client.company] = client.documentId!;
      }
    }

    directionController.text = direction;
    cifController.text = cif;
    if (phone < 0) {
      phoneController.text = "";
    } else {
      phoneController.text = phone.toString();
    }
    namePhoneController.text = namePhone;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDropdownComponentSimpleForm('Empresa', null, TextInputType.text,
            (value) {
          company = value!;
          getDirectionAndCIF(company);
          setState(() {});
        }, companyItems),
        getTextComponentSimpleForm('Dirección', null, TextInputType.text, (value) {
          direction = value;
        }, textEditingController: directionController, isEnabled: false),
        getTextComponentSimpleForm('CIF', null, TextInputType.text, (value) {
          cif = value;
        }, textEditingController: cifController, isEnabled: false),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        getComponentTableForm('Pedido', getPricePerUnitTableRow(), 
            columnWidhts: {
              0: const IntrinsicColumnWidth(),
              2: const IntrinsicColumnWidth()
            }),
        getDropdownComponentSimpleForm('Método de pago', null, TextInputType.text,
            (value) => {
          paymentMethod = value!
        }, paymentMethodItems), 
        getTextComponentSimpleForm('Fecha de entrega', null, TextInputType.none, null,
          isReadOnly: true, onTap: () async {
            // TODO: Cambiar el color
            DateTime? pickedDate = await showDatePicker(
              context: context, 
              initialDate: minDate, 
              firstDate: minDate, 
              lastDate: DateTime(
                DateTime.now().year + 1,
                DateTime.now().month,
                minDate.day
              )
            );
            if (pickedDate != null) {
              setState(() {
                datePickerTimestamp = Timestamp.fromDate(pickedDate);
                dateController.text = dateFormat.format(pickedDate);
              });
            }
          },
          textEditingController: dateController),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, saveGetPriceButton, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Cancelar', null, null, goBack, () {}),
        ],
      ),
    );
  }

  Widget getDropdownComponentSimpleForm(String label, String? labelInputText, 
      TextInputType textInputType, Function(dynamic)? onChange, List<String> items,
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
        double topMargin = 4;
        double bottomMargin = 4;
        if (cont == 0) {
          topMargin = 8;
        } else if (cont == 14) {
          bottomMargin = 32;
        }
        cont++;
        
        return HNComponentSimpleForm(
        '$label:',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin,),
        componentDropdown: 
          HNComponentDropdown(
            items,
            labelText: labelInputText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textInputType: textInputType,
            onChange: onChange,
          ),
        );
  }

  Widget getTextComponentSimpleForm(String label, String? labelInputText,
      TextInputType textInputType, Function(String)? onChange,
      {TextCapitalization textCapitalization = TextCapitalization.sentences, 
      TextEditingController? textEditingController, bool isEnabled = true, bool isReadOnly = false, 
      Future<dynamic> Function()? onTap}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (cont == 0) {
      topMargin = 8;
    } else if (cont == 14) {
      bottomMargin = 32;
    }
    cont++;

    return HNComponentSimpleForm(
        label + ':',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        componentTextInput: HNComponentTextInput(
          textCapitalization: textCapitalization,
          labelText: labelInputText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textInputType: textInputType,
          onChange: onChange,
          textEditingController: textEditingController,
          isEnabled: isEnabled,
          onTap: onTap,
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
                onChange: (value) {
                  String key = "${item.toLowerCase()}_dozen";
                  productQuantities[key] = int.tryParse(value) ?? 0;
                },
                isEnabled: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("${valuesMap["${item.toLowerCase()}_dozen"]} €")),
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
                onChange: (value) {
                  String key = "${item.toLowerCase()}_box";
                  productQuantities[key] = int.tryParse(value) ?? 0;
                },
                isEnabled: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("${valuesMap["${item.toLowerCase()}_box"]} €")),
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
              onChange: (value) {
                namePhone = value;
              },
              textEditingController: namePhoneController,
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
              onChange: (value) {
                phone = int.parse(value);
              },
              textEditingController: phoneController,
              isEnabled: false,
            )),
      ]),
    ];
  }


  goBack() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  getDirectionAndCIF(String companyDropdownSelected) {
    String docId = companyItemsMap[companyDropdownSelected] ?? "";
    if (docId != "") {
      int index = 0;
      while(index < clientModelList.length) {
        client = clientModelList[index];
        if (client!.documentId == docId) {
          direction = client!.direction;
          cif = client!.cif;
          namePhone = client!.phone[0].keys.first;
          phone = client!.phone[0].values.first;
        }
        index += 1;
      }
    }
  }
  
  saveGetPriceButton() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    if (checkFields()) {
      QuerySnapshot<Map<String, dynamic>> allOrders = await FirebaseUtils.instance.getUserOrdersFuture(companyItemsMap[company]!);
      int newId = allOrders.size;
      DBOrderFieldData dbOrderFieldData = OrderUtils().getOrderStructure(productQuantities, productPrices);
      double totalPrice = Utils().roundDouble(getTotalPrice(dbOrderFieldData), 2);
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
                        child: const Text("Atrás")
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(this.context).pop();
                          // TODO: Guardar pedido
                          saveOrder(newId, dbOrderFieldData, totalPrice);
                        }, 
                        child: const Text("Contiuar")
                      ),
                    ],
                  ));
      }
    }
  }

  bool checkFields() {
    if (paymentMethod != null && datePickerTimestamp != null && isOrder()) {
      return true;
    } else {
      return false;
    }
  }

  bool isOrder() {
    if ((productQuantities.containsKey("xl_box") && productQuantities["xl_box"] != 0) || 
        (productQuantities.containsKey("xl_dozen") && productQuantities["xl_dozen"] != 0) || 
        (productQuantities.containsKey("l_box") && productQuantities["l_box"] != 0) || 
        (productQuantities.containsKey("l_dozen") && productQuantities["l_dozen"] != 0) || 
        (productQuantities.containsKey("m_box") && productQuantities["m_box"] != 0) || 
        (productQuantities.containsKey("m_dozen") && productQuantities["m_dozen"] != 0) || 
        (productQuantities.containsKey("s_box") && productQuantities["s_box"] != 0) || 
        (productQuantities.containsKey("s_dozen") && productQuantities["s_dozen"] != 0)) {
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

  double getTotalPrice(DBOrderFieldData dbOrderFieldData) {
    double totalPrice = 0.0;

    if (dbOrderFieldData.xlBoxQuantity != null && dbOrderFieldData.xlBoxPrice != null) {
      totalPrice += (dbOrderFieldData.xlBoxQuantity as int) * (dbOrderFieldData.xlBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.xlDozenQuantity != null && dbOrderFieldData.xlDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.xlDozenQuantity as int) * (dbOrderFieldData.xlDozenQuantity!.toDouble());
    }
    if (dbOrderFieldData.lBoxQuantity != null && dbOrderFieldData.lBoxPrice != null) {
      totalPrice += (dbOrderFieldData.lBoxQuantity as int) * (dbOrderFieldData.lBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.lDozenQuantity != null && dbOrderFieldData.lDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.lDozenQuantity as int) * (dbOrderFieldData.lDozenQuantity!.toDouble());
    }
    if (dbOrderFieldData.mBoxQuantity != null && dbOrderFieldData.mBoxPrice != null) {
      totalPrice += (dbOrderFieldData.mBoxQuantity as int) * (dbOrderFieldData.mBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.mDozenQuantity != null && dbOrderFieldData.mDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.mDozenQuantity as int) * (dbOrderFieldData.mDozenQuantity!.toDouble());
    }
    if (dbOrderFieldData.sBoxQuantity != null && dbOrderFieldData.sBoxPrice != null) {
      totalPrice += (dbOrderFieldData.sBoxQuantity as int) * (dbOrderFieldData.sBoxPrice!.toDouble());
    }
    if (dbOrderFieldData.sDozenQuantity != null && dbOrderFieldData.sDozenQuantity != null) {
      totalPrice += (dbOrderFieldData.sDozenQuantity as int) * (dbOrderFieldData.sDozenQuantity!.toDouble());
    }
    return totalPrice;
  }

  saveOrder(int newId, DBOrderFieldData dbOrderFieldData, double totalPrice) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    OrderModel orderModel = OrderModel(
      datePickerTimestamp!, 
      client!.id,
      client!.company,
      "user_${client!.id}", 
      null, 
      null, 
      null, 
      null, 
      null,
      null, 
      dbOrderFieldData.toMap(), 
      Timestamp.now(), 
      newId, 
      false, 
      OrderUtils().paymentMethodStringToInt(paymentMethod), 
      1, 
      totalPrice,
      null);

      bool firestoreConf =
          await FirebaseUtils.instance.saveNewOrder(client!.documentId!, orderModel);
      if (firestoreConf) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("Pedido realizado"),
                  content: const Text("Su pedido se ha realizado correctamente"),
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
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Se ha producido un error'),
                  content: const Text('Sentimos comunicarle que se ha producido un error inesperado durante el pedido. Por favor, inténtelo más tarde o póngase en contacto con nosotros.'),
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
  
}