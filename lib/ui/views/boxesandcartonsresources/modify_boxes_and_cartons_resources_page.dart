import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/boxes_and_cartons_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/material_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/local/db_boxes_and_cartons_order_field_data.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyBoxesAndCartonsResourcesPage extends StatefulWidget {
  const ModifyBoxesAndCartonsResourcesPage(
      this.currentUser, this.bcResourcesModel,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final BoxesAndCartonsResourcesModel bcResourcesModel;

  @override
  State<ModifyBoxesAndCartonsResourcesPage> createState() =>
      _ModifyBoxesAndCartonsResourcesPageState();
}

class _ModifyBoxesAndCartonsResourcesPageState
    extends State<ModifyBoxesAndCartonsResourcesPage> {
  late InternalUserModel currentUser;
  late BoxesAndCartonsResourcesModel bcResourcesModel;
  late DBBoxesAndCartonsOrderFieldData orderFieldData;
  late int? box;
  late int? xlCarton;
  late int? lCarton;
  late int? mCarton;
  late int? sCarton;
  late double? totalPrice;

  @override
  void initState() {
    super.initState();

    currentUser = widget.currentUser;
    bcResourcesModel = widget.bcResourcesModel;

    orderFieldData =
        MaterialUtils().bcOrderToDBBoxesAndCartonsOrderModel(bcResourcesModel);

    box = orderFieldData.box;
    xlCarton = orderFieldData.xlCarton;
    lCarton = orderFieldData.lCarton;
    mCarton = orderFieldData.mCarton;
    sCarton = orderFieldData.sCarton;
    totalPrice = bcResourcesModel.totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Cajas y cartones - Modificar',
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
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }

  List<TableRow> getCells() {
    DBBoxesAndCartonsOrderFieldData fieldData =
        DBBoxesAndCartonsOrderFieldData.fromMap(bcResourcesModel.order);

    return [
      TableRow(children: [
        Container(
          child: Text("Fecha:"),
          margin: const EdgeInsets.only(right: 16),
        ),
        Container(
          child: Text(
              Utils().parseTimestmpToString(bcResourcesModel.expenseDatetime) ??
                  ""),
          margin: const EdgeInsets.only(left: 16),
        ),
      ]),
      TableRow(children: [
        Container(
          child: Text("Pedido:"),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
        Container(),
      ]),
      TableRow(children: [
        Container(
          child: Text("Cajas:"),
          margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            isEnabled: true,
            initialValue: (fieldData.box ?? "").toString(),
            onChange: (value) {
              box = int.tryParse(value);
            },
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          child: Text("Cartones XL:"),
          margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            isEnabled: true,
            initialValue: (fieldData.xlCarton ?? "").toString(),
            onChange: (value) {
              xlCarton = int.tryParse(value);
            },
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          child: Text("Cartones L:"),
          margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            isEnabled: true,
            initialValue: (fieldData.lCarton ?? "").toString(),
            onChange: (value) {
              lCarton = int.tryParse(value);
            },
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          child: Text("Cartones M:"),
          margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            isEnabled: true,
            initialValue: (fieldData.mCarton ?? "").toString(),
            onChange: (value) {
              mCarton = int.tryParse(value);
            },
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          child: Text("Cartones S:"),
          margin: const EdgeInsets.only(right: 16, top: 4, left: 16),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            isEnabled: true,
            initialValue: (fieldData.sCarton ?? "").toString(),
            onChange: (value) {
              sCarton = int.tryParse(value);
            },
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          child: Text("Precio total:"),
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
                  initialValue: bcResourcesModel.totalPrice.toString(),
                  onChange: (value) {
                    totalPrice = double.tryParse(value);
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              const Text("€"),
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
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton).getTypedButton(
              'Guardar', null, null, warningUpdateBCResource, null),
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
        ]));
  }

  goBack() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  warningUpdateBCResource() {
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
                    updateBCResource();
                  },
                )
              ],
            ));
  }

  updateBCResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    if (totalPrice != null && hasOrder()) {
      DBBoxesAndCartonsOrderFieldData data = DBBoxesAndCartonsOrderFieldData(
        box: box == 0 ? null : box,
        xlCarton: xlCarton == 0 ? null : xlCarton,
        lCarton: lCarton == 0 ? null : lCarton,
        mCarton: mCarton == 0 ? null : mCarton,
        sCarton: sCarton == 0 ? null : sCarton,
      );

      BoxesAndCartonsResourcesModel updateBCResource =
          BoxesAndCartonsResourcesModel(
              bcResourcesModel.createdBy,
              bcResourcesModel.creationDatetime,
              bcResourcesModel.deleted,
              bcResourcesModel.expenseDatetime,
              data.toMap(),
              totalPrice!,
              bcResourcesModel.documentId);
      bool firestoreConf = await FirebaseUtils.instance.updateDocument(
          "material_boxes_and_cartons",
          updateBCResource.documentId!,
          updateBCResource.toMap());
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
                          Navigator.pop(context, updateBCResource);
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

  bool hasOrder() {
    if ((box != null && box != 0) ||
        (xlCarton != null && xlCarton != 0) ||
        (lCarton != null && lCarton != 0) ||
        (mCarton != null && mCarton != 0) ||
        (sCarton != null && sCarton != 0)) {
      return true;
    } else {
      return false;
    }
  }
}
