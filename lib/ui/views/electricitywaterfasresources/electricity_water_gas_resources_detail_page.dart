import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/electricity_water_gas_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/components/component_dropdown.dart';
import 'package:hueveria_nieto_interna/ui/views/electricitywaterfasresources/modify_electricity_water_gas_resources_page.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/component_text_input_multiline.dart';
import '../../components/constants/hn_button.dart';

class ElectricityWaterGasResourcesDetailPage extends StatefulWidget {
  const ElectricityWaterGasResourcesDetailPage(this.currentUser, this.ewgModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final ElectricityWaterGasResourcesModel ewgModel;

  @override
  State<ElectricityWaterGasResourcesDetailPage> createState() => _ElectricityWaterGasResourcesDetailPageState();
}

class _ElectricityWaterGasResourcesDetailPageState extends State<ElectricityWaterGasResourcesDetailPage> {
  late InternalUserModel currentUser;
  late ElectricityWaterGasResourcesModel ewgModel;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    ewgModel = widget.ewgModel;

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Detalle - Electr...',
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
      TableCellVerticalAlignment.top,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }

  List<TableRow> getCells() {
    return [
      TableRow(
        children: [
          Container(
            child: Text("Fecha:"),
            margin: const EdgeInsets.only(right: 16),
          ),
          Container(
            child: Text(Utils().parseTimestmpToString(ewgModel.expenseDatetime) ?? ""),
            margin: const EdgeInsets.only(left: 16),
          ),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Tipo:"),
            margin: const EdgeInsets.only(right: 16, top: 4),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentDropdown(
                [],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                isEnabled: false,
                labelText: Utils().getKey(Constants().ewgTypes, ewgModel.type),
              ),
            ),
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
                isEnabled: false,
                labelText: ewgModel.totalPrice.toString(),
              ),
            ),
        ]
      ),
      TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
              child: Text("Notas:"),
              margin: const EdgeInsets.only(right: 16, top: 16),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInputMultiline(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                textInputType: TextInputType.multiline,
                isEnabled: false,
                labelText: ewgModel.notes,
                maxLines: 5,
                minLines: 5,
                textAlignVertical: TextAlignVertical.top,
                alignLabelWithHint: true,
              ),
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
              .getTypedButton('Modificar', null, null, navigateToModifyEWGResource, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Eliminar', 
                null, 
                null, 
                warningDeleteEWGResource, 
                null, 
              ),
        ])
    );
  }

  warningDeleteEWGResource() {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: const Text('Aviso importante'),
            content: Text(
                'Esta acción es irreversible. Va a eliminar este ticket,  y puede conllevar consecuencias para la empresa. ¿Está seguro de que quiere continuar?'),
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
                  deleteEWGResource();
                }, 
                child: const Text("Continuar")
              ),
            ],
          ));
  }

  deleteEWGResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    bool conf = await FirebaseUtils.instance.deleteDocument("material_electricity_water_gas", ewgModel.documentId!);
    
    Navigator.pop(context);
    if(conf) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Recurso eliminado'),
              content: const Text(
                  'El recurso ha sido eliminado correctamente.'),
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
                  'Se ha producido un error al eliminar el recurso. Por favor, inténtelo de nuevo.'),
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

  navigateToModifyEWGResource() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ModifyElectricityWaterGasResourcesPage(currentUser, ewgModel)));

    if (result != null) {
      ewgModel = result;
      setState(() {});
    }
  }

}
