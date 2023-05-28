import 'package:flutter/material.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/local/egg_prices_data.dart';
import '../../../utils/constants.dart';
import '../../components/component_table_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class SellingPricePage extends StatefulWidget {
  const SellingPricePage(this.currentUser, this.eggPricesData, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final EggPricesData eggPricesData;
  
  @override
  State<SellingPricePage> createState() => _SellingPricePageState();
}

class _SellingPricePageState extends State<SellingPricePage> {
  late InternalUserModel currentUser;
  late EggPricesData eggPricesData;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    eggPricesData = widget.eggPricesData;
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
        TableRow(
          children: [
            Container(
              child: Text("XL"),
              margin: const EdgeInsets.only(left: 12, right: 16),
            ),
            Container(),
            Container()
          ]
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: (eggPricesData.xlDozen ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ],
        ),
        TableRow(
          children: [
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
                initialValue: (eggPricesData.xlBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ]
        ),
        TableRow(
          children: [
            Container(
              child: Text("L"),
              margin: const EdgeInsets.only(left: 12, right: 16),
            ),
            Container(),
            Container()
          ]
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: (eggPricesData.lDozen ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ],
        ),
        TableRow(
          children: [
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
                initialValue: (eggPricesData.lBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ]
        ),
        TableRow(
          children: [
            Container(
              child: Text("M"),
              margin: const EdgeInsets.only(left: 12, right: 16),
            ),
            Container(),
            Container()
          ]
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: (eggPricesData.mDozen ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ],
        ),
        TableRow(
          children: [
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
                initialValue: (eggPricesData.mBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ]
        ),
        TableRow(
          children: [
            Container(
              child: Text("L"),
              margin: const EdgeInsets.only(left: 12, right: 16),
            ),
            Container(),
            Container()
          ]
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Docena")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                initialValue: (eggPricesData.sDozen ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ],
        ),
        TableRow(
          children: [
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
                initialValue: (eggPricesData.sBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("€")),
          ]
        ),
    ];
    return list;

  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Modificar', null, null, () {}, null),
    );
  }
}