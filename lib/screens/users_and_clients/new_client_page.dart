import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_cell_table_form.dart';
import 'package:hueveria_nieto_interna/component/component_container_border_check_title.dart';
import 'package:hueveria_nieto_interna/component/component_simple_form.dart';
import 'package:hueveria_nieto_interna/component/component_table_form.dart';
import 'package:hueveria_nieto_interna/component/component_text_input.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

// TODO: Cuidado - todo esta clase está hardcodeada
// TODO: Intentar reducir código

class NewClientPage extends StatefulWidget {
  NewClientPage({Key? key}) : super(key: key);

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  List<String> labelList = [
    "Empresa",
    "Dirección",
    "Ciudad",
    "Provincia",
    "Código postal",
    "CIF",
    "Correo",
    "Teléfono",
    "Precio/ud.",
  ];
  List<String> eggTypes = [
    "Cajas XL",
    "Cajas L",
    "Cajas M",
    "Cajas S",
    "Estuchados"
  ];
  List<String> userLabels = ["Usuario", "Correo"];
  int contCompany = 0;
  int contUser = 0;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }
    contCompany = 0;
    contUser = 0;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Nuevo cliente",
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
        const Text('ID: '), // TODO: Falta el ID
        getCompanyComponentSimpleForm(labelList[0]),
        getCompanyComponentSimpleForm(labelList[1]),
        getCompanyComponentSimpleForm(labelList[2]),
        getCompanyComponentSimpleForm(labelList[3]),
        getCompanyComponentSimpleForm(labelList[4]),
        getCompanyComponentSimpleForm(labelList[5]),
        getCompanyComponentSimpleForm(labelList[6]),
        getComponentTableForm(labelList[7], getTelephoneTableRow()),
        getComponentTableForm(labelList[8], getPricePerUnitTableRow(),
            columnWidhts: {0: const IntrinsicColumnWidth()}),
        getClientUserContainerComponent(),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton("Guardar", null, null, () {}, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton("Cancelar", null, null, () {}, () {}),
        ],
      ),
    );
  }

  // TODO: hay que añadir elementos a todas las funciones
  Widget getCompanyComponentSimpleForm(String label) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contCompany == 0) {
      topMargin = 8;
    } else if (contCompany == labelList.length) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentSimpleForm(
        label + ":",
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        const HNComponentTextInput(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin));
  }

  Widget getComponentTableForm(String label, List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contCompany == 0) {
      topMargin = 8;
    } else if (contCompany == labelList.length - 1) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentTableForm(
      label,
      8,
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }

  List<TableRow> getTelephoneTableRow() {
    return [
      const TableRow(children: [
        HNComponentCellTableForm(
            40,
            EdgeInsets.only(left: 16, right: 8, bottom: 8),
            HNComponentTextInput(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            )),
        HNComponentCellTableForm(
            40,
            EdgeInsets.only(left: 8, right: 16, bottom: 8),
            HNComponentTextInput(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            )),
      ]),
      const TableRow(children: [
        HNComponentCellTableForm(
            40,
            EdgeInsets.only(left: 16, right: 8),
            HNComponentTextInput(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            )),
        HNComponentCellTableForm(
            40,
            EdgeInsets.only(left: 8, right: 16),
            HNComponentTextInput(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            )),
      ]),
    ];
  }

  List<TableRow> getPricePerUnitTableRow() {
    List<TableRow> list = [];
    for (int i = 0; i < eggTypes.length; i++) {
      double bottomMargin = 8;
      if (i == eggTypes.length) {
        bottomMargin = 0;
      }
      list.add(TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text(eggTypes[i])),
        Container(
          height: 40,
          margin: EdgeInsets.only(left: 8, right: 16, bottom: bottomMargin),
          child: const HNComponentTextInput(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
        ),
      ]));
    }
    return list;
  }

  Widget getClientUserContainerComponent() {
    return HNComponentContainerBorderCheckTitle(
      "Crear usuario para la app cliente",
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 19),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.redPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(16),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getClientComponentSimpleForm(userLabels[0]),
            getClientComponentSimpleForm(userLabels[1]),
            const Text(
                "Se le mandará a esta dirección de correo un mensaje con la información para terminar de crear la cuenta."),
          ],
        ),
      ),
      leftPosition: 24,
      rightPosition: 56,
      topPosition: 0,
    );
  }

  Widget getClientComponentSimpleForm(String label) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contUser == 0) {
      topMargin = 0;
    } else if (contUser == userLabels.length - 1) {
      bottomMargin = 16;
    }
    contUser++;

    return HNComponentSimpleForm(
      label + ":",
      8,
      40,
      const EdgeInsets.only(left: 0),
      const HNComponentTextInput(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      textMargin: const EdgeInsets.only(left: 24),
    );
  }
}
