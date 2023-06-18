import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/local/egg_prices_data.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_table_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifySellingPricePage extends StatefulWidget {
  const ModifySellingPricePage(this.currentUser, this.eggPricesData, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final EggPricesData eggPricesData;

  @override
  State<ModifySellingPricePage> createState() => _ModifySellingPricePageState();
}

class _ModifySellingPricePageState extends State<ModifySellingPricePage> {
  late InternalUserModel currentUser;
  late EggPricesData eggPricesData;
  late double xlBox;
  late double xlDozen;
  late double lBox;
  late double lDozen;
  late double mBox;
  late double mDozen;
  late double sBox;
  late double sDozen;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    eggPricesData = widget.eggPricesData;

    xlBox = (widget.eggPricesData.xlBox ?? 0).toDouble();
    xlDozen = (widget.eggPricesData.xlDozen ?? 0).toDouble();
    lBox = (widget.eggPricesData.lBox ?? 0).toDouble();
    lDozen = (widget.eggPricesData.lDozen ?? 0).toDouble();
    mBox = (widget.eggPricesData.mBox ?? 0).toDouble();
    mDozen = (widget.eggPricesData.mDozen ?? 0).toDouble();
    sBox = (widget.eggPricesData.sBox ?? 0).toDouble();
    sDozen = (widget.eggPricesData.sDozen ?? 0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Precio de venta',
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
                      getComponentTableForm('Pedido', getPricePerUnitTableRow(),
                          columnWidhts: {
                            0: const IntrinsicColumnWidth(),
                            2: const IntrinsicColumnWidth()
                          }),
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
    List<TableRow> list = [
      TableRow(children: [
        Container(
          child: Text("XL"),
          margin: const EdgeInsets.only(left: 12, right: 16),
        ),
        Container(),
        Container()
      ]),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: xlDozen.toString(),
              isEnabled: true,
              onChange: (value) {
                xlDozen = double.tryParse(value) ?? 0.0;
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
        ],
      ),
      TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("Caja")),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            initialValue: xlBox.toString(),
            isEnabled: true,
            onChange: (value) {
              xlBox = double.tryParse(value) ?? 0.0;
            },
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("€")),
      ]),
      TableRow(children: [
        Container(
          child: Text("L"),
          margin: const EdgeInsets.only(left: 12, right: 16),
        ),
        Container(),
        Container()
      ]),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: lDozen.toString(),
              isEnabled: true,
              onChange: (value) {
                lDozen = double.tryParse(value) ?? 0.0;
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
        ],
      ),
      TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("Caja")),
        Container(
          height: 40,
          margin: EdgeInsets.only(left: 8, bottom: 0),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            initialValue: lBox.toString(),
            isEnabled: true,
            onChange: (value) {
              lBox = double.tryParse(value) ?? 0.0;
            },
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("€")),
      ]),
      TableRow(children: [
        Container(
          child: Text("M"),
          margin: const EdgeInsets.only(left: 12, right: 16),
        ),
        Container(),
        Container()
      ]),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: mDozen.toString(),
              isEnabled: true,
              onChange: (value) {
                mDozen = double.tryParse(value) ?? 0.0;
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
        ],
      ),
      TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("Caja")),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            initialValue: mBox.toString(),
            isEnabled: true,
            onChange: (value) {
              mBox = double.tryParse(value) ?? 0.0;
            },
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("€")),
      ]),
      TableRow(children: [
        Container(
          child: Text("L"),
          margin: const EdgeInsets.only(left: 12, right: 16),
        ),
        Container(),
        Container()
      ]),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              initialValue: sDozen.toString(),
              isEnabled: true,
              onChange: (value) {
                sDozen = double.tryParse(value) ?? 0.0;
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
        ],
      ),
      TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("Caja")),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            initialValue: sBox.toString(),
            isEnabled: true,
            onChange: (value) {
              sBox = double.tryParse(value) ?? 0.0;
            },
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text("€")),
      ]),
    ];
    return list;
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
          .getTypedButton('Guardar', null, null, warningUpdatePrices, null),
    );
  }

  warningUpdatePrices() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Aviso'),
              content: const Text(
                  'Esta acción cambiará los precios de los productos a partir de este momento, dejando todos los pedidos anteriores tal y como están.\nEs una ación que puede tener grandes consecuencias.\n¿Está seguro de que quiere continuar?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Atrás'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Continuar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    updatePrices();
                  },
                )
              ],
            ));
  }

  updatePrices() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    if (xlBox != 0.0 &&
        xlDozen != 0.0 &&
        lBox != 0.0 &&
        lDozen != 0.0 &&
        mBox != 0.0 &&
        mDozen != 0.0 &&
        sBox != 0.0 &&
        sDozen != 0.0) {
      EggPricesData updateEggPricesData = EggPricesData(
          xlBox, xlDozen, lBox, lDozen, mBox, mDozen, sBox, sDozen);

      QuerySnapshot<Map<String, dynamic>> futureEggPrices =
          await FirebaseUtils.instance.getEggPrices();
      if (futureEggPrices.docs.isNotEmpty && futureEggPrices.docs[0].exists) {
        bool firestoreConf = await FirebaseUtils.instance.updateDocument(
            "default_constants",
            futureEggPrices.docs[0].id,
            {"values": updateEggPricesData.toMap()});

        if (firestoreConf) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Cambio registrado'),
                    content: const Text(
                        'Los precios de los productos se han cambiado correctamente.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('De acuerdo.'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context, updateEggPricesData);
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
                        'Se ha producido un error. Por favor, revise los datos e inténtelo de nuevo.'),
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
