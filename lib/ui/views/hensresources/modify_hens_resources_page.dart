import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/hens_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyHensResourcesPage extends StatefulWidget {
  const ModifyHensResourcesPage(this.currentUser, this.hensResourcesModel,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final HensResourcesModel hensResourcesModel;

  @override
  State<ModifyHensResourcesPage> createState() =>
      _ModifyHensResourcesStatePage();
}

class _ModifyHensResourcesStatePage extends State<ModifyHensResourcesPage> {
  late InternalUserModel currentUser;
  late HensResourcesModel hensResourcesModel;
  late int? totalQuantity;
  late double? totalPrice;

  @override
  void initState() {
    super.initState();

    currentUser = widget.currentUser;
    hensResourcesModel = widget.hensResourcesModel;

    totalQuantity = hensResourcesModel.hensNumber;
    totalPrice = hensResourcesModel.totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Modificar registro gallinas',
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
                      getComponentTableFormWithoutLable(getCells(),
                          columnWidhts: {
                            0: const IntrinsicColumnWidth(),
                          }),
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

  Widget getComponentTableFormWithoutLable(List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentTableFormWithoutLabel(
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }

  List<TableRow> getCells() {
    return [
      TableRow(children: [
        Container(
          child: const Text("Fecha:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, bottom: 10),
        ),
        Container(
          child: Text(Utils()
                  .parseTimestmpToString(hensResourcesModel.expenseDatetime) ??
              "", style: const TextStyle(fontSize: 16)),
          margin: const EdgeInsets.only(left: 16, bottom: 8),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Cantidad:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            isEnabled: true,
            initialValue: hensResourcesModel.hensNumber.toString(),
            onChange: (value) {
              totalQuantity = int.tryParse(value);
            },
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Precio total:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: Row(
            children: [
              Flexible(
                child: HNComponentTextInput(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  textInputType: const TextInputType.numberWithOptions(),
                  isEnabled: true,
                  initialValue: hensResourcesModel.totalPrice.toString(),
                  onChange: (value) {
                    totalPrice = double.tryParse(value);
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              const Text("€", style: TextStyle(fontSize: 16),),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ]),
    ];
  }

  Widget getButtonsComponent() {
    return Column(children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton).getTypedButton(
              'Guardar', null, null, warningUpdateHensResource, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
            'Cancelar',
            null,
            null,
            goBack,
            null,
          ),
        ]);
  }

  goBack() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  warningUpdateHensResource() {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Aviso'),
              content: const Text(
                  'Va a modificar este ticket. ¿Quiere continuar con el proceso?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Continuar'),
                  onPressed: () {
                    Navigator.pop(context);
                    updateHensResource();
                  },
                )
              ],
            ));
  }

  updateHensResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    if (totalQuantity != null &&
        totalQuantity! > 0 &&
        totalPrice != null &&
        totalPrice! > 0) {
      HensResourcesModel updateHensResource = HensResourcesModel(
          hensResourcesModel.createdBy,
          hensResourcesModel.creationDatetime,
          hensResourcesModel.deleted,
          hensResourcesModel.expenseDatetime,
          totalQuantity!,
          hensResourcesModel.shedA,
          hensResourcesModel.shedB,
          totalPrice!,
          hensResourcesModel.documentId);
      bool firestoreConf = await FirebaseUtils.instance.updateDocument(
          "material_hens",
          hensResourcesModel.documentId!,
          updateHensResource.toMap());
      if (firestoreConf) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Recurso actualizado'),
                  content: Text(
                      'La información sobre el recurso ha sido actualizada correctamente en la base de datos.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context, updateHensResource);
                        },
                        child: const Text("De acuerdo")),
                  ],
                ));
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(
                      'Se ha producido un error al actualizar el recurso. Por favor, revise los datos e inténtelo de nuevo.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(this.context).pop();
                        },
                        child: const Text("De acuerdo")),
                  ],
                ));
      }
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Formualrio incompleto'),
                content: Text(
                    'Debe rellenar todos los campos del formulario. Por favor revise los datos e inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(this.context).pop();
                      },
                      child: const Text("De acuerdo")),
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
}
