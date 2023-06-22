import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/views/selingprice/modify_selling_price_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/local/egg_prices_data.dart';
import '../../../utils/constants.dart';
import '../../components/component_table_form.dart';
import '../../components/component_table_form_with_subtitles.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class SellingPricePage extends StatefulWidget {
  const SellingPricePage(this.currentUser, this.eggPricesData, {Key? key})
      : super(key: key);

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
              style: TextStyle(fontSize: 18),
            )),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getComponentTableWithSubtitlesForm('Precio actual', getPricePerUnitTableRow()),
                      const SizedBox(
                        height: 40,
                      ),
                      getButtonsComponent(),
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
    

    list.add(
      Container(
        child: const Text("Huevos tamaño XL:", style: TextStyle(fontWeight: FontWeight.bold)),
        margin: const EdgeInsets.only(left: 12, right: 16),
      ));
    list.add(
      const SizedBox(height: 4,)
    );

    list.add(
      Table(
        columnWidths: const {
            0: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
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
                margin: const EdgeInsets.only(left: 8, bottom: 0),
                child: HNComponentTextInput(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  textInputType: const TextInputType.numberWithOptions(),
                  labelText: (eggPricesData.xlDozen ?? 0).toString(),
                  isEnabled: false,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
            ],
          ),
          TableRow(children: [
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("Caja")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (eggPricesData.xlBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
          ]),
        ],
      )
    );

    list.add(
      Container(
        child: const Text("Huevos tamaño L:", style: TextStyle(fontWeight: FontWeight.bold)),
        margin: const EdgeInsets.only(left: 12, right: 16, top: 4),
      ));
    list.add(
      const SizedBox(height: 4,)
    );

    list.add(
      Table(
        columnWidths: const {
            0: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
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
                margin: const EdgeInsets.only(left: 8, bottom: 0),
                child: HNComponentTextInput(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  textInputType: const TextInputType.numberWithOptions(),
                  labelText: (eggPricesData.lDozen ?? 0).toString(),
                  isEnabled: false,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
            ],
          ),
          TableRow(children: [
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("Caja")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (eggPricesData.lBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
          ]),
        ],
      )
    );
    
    list.add(
      Container(
        child: const Text("Huevos tamaño M:", style: TextStyle(fontWeight: FontWeight.bold)),
        margin: const EdgeInsets.only(left: 12, right: 16, top: 4),
      ));
    list.add(
      const SizedBox(height: 4,)
    );

    list.add(
      Table(
        columnWidths: const {
            0: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
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
                margin: const EdgeInsets.only(left: 8, bottom: 0),
                child: HNComponentTextInput(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  textInputType: const TextInputType.numberWithOptions(),
                  labelText: (eggPricesData.mDozen ?? 0).toString(),
                  isEnabled: false,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
            ],
          ),
          TableRow(children: [
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("Caja")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (eggPricesData.mBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
          ]),
        ],
      )
    );
    
    list.add(
      Container(
        child: const Text("Huevos tamaño S:", style: TextStyle(fontWeight: FontWeight.bold)),
        margin: const EdgeInsets.only(left: 12, right: 16, top: 4),
      ));
    list.add(
      const SizedBox(height: 4,)
    );

    list.add(
      Table(
        columnWidths: const {
            0: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
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
                margin: const EdgeInsets.only(left: 8, bottom: 0),
                child: HNComponentTextInput(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  textInputType: const TextInputType.numberWithOptions(),
                  labelText: (eggPricesData.sDozen ?? 0).toString(),
                  isEnabled: false,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
            ],
          ),
          TableRow(children: [
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("Caja")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (eggPricesData.sBox ?? 0).toString(),
                isEnabled: false,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: const Text("€/ud")),
          ]),
        ],
      )
    );
    
    
    
    return list;
  }

  Widget getButtonsComponent() {
    return Container(
      child: HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
          'Modificar', null, null, navigateToSellingPrice, null),
    );
  }

  navigateToSellingPrice() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ModifySellingPricePage(currentUser, eggPricesData)));

    if (result != null) {
      eggPricesData = result;
      setState(() {
        eggPricesData = result;
      });
    }
  }
}
