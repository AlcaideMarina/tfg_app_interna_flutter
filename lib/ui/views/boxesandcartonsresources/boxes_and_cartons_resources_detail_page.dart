import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/boxes_and_cartons_resources_model.dart';
import 'package:hueveria_nieto_interna/ui/views/boxesandcartonsresources/modify_boxes_and_cartons_resources_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../data/models/local/db_boxes_and_cartons_order_field_data.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class BoxesAndCartonsResourceDetailPage extends StatefulWidget {
  const BoxesAndCartonsResourceDetailPage(this.currentUser, this.bcResourcesModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final BoxesAndCartonsResourcesModel bcResourcesModel;

  @override
  State<BoxesAndCartonsResourceDetailPage> createState() => _BoxesAndCartonsResourceDetailPageState();
}

class _BoxesAndCartonsResourceDetailPageState extends State<BoxesAndCartonsResourceDetailPage> {
  late InternalUserModel currentUser;
  late BoxesAndCartonsResourcesModel bcResourcesModel;
  late DBBoxesAndCartonsOrderFieldData fieldData;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    bcResourcesModel = widget.bcResourcesModel;
    fieldData = DBBoxesAndCartonsOrderFieldData.fromMap(bcResourcesModel.order);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Cajas y cartones - Detalle',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: 18),
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
    return [
      TableRow(
        children: [
          Container(
            child: Text("Fecha:"),
            margin: const EdgeInsets.only(right: 16),
          ),
          Container(
            child: Text(Utils().parseTimestmpToString(bcResourcesModel.expenseDatetime) ?? ""),
            margin: const EdgeInsets.only(left: 16),
          ),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Pedido:"),
            margin: const EdgeInsets.only(right: 16, top: 4),
          ),
          Container(),
        ]
      ),
      TableRow(
        children: [
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
                isEnabled: false,
                labelText: (fieldData.box ?? "").toString(),
              ),
            ),
        ]
      ),
      TableRow(
        children: [
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
                isEnabled: false,
                labelText: (fieldData.xlCarton ?? "").toString(),
              ),
            ),
        ]
      ),
      TableRow(
        children: [
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
                isEnabled: false,
                labelText: (fieldData.lCarton ?? "").toString(),
              ),
            ),
        ]
      ),
      TableRow(
        children: [
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
                isEnabled: false,
                labelText: (fieldData.mCarton ?? "").toString(),
              ),
            ),
        ]
      ),
      TableRow(
        children: [
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
                isEnabled: false,
                labelText: (fieldData.sCarton ?? "").toString(),
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
              child: Row(
                children: [
                  Flexible(
                    child: HNComponentTextInput(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      textInputType: const TextInputType.numberWithOptions(),
                      isEnabled: false,
                      labelText: bcResourcesModel.totalPrice.toString(),
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
              .getTypedButton('Modificar', null, null, navigateToNewHensTicker, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Eliminar', 
                null, 
                null, 
                warningDeleteBCResource,
                null, 
              ),
        ])
    );
  }

  warningDeleteBCResource() {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: const Text('Aviso importante'),
            content: Text(
                'Esta acción es irreversible. Va a eliminar este ticket, y puede conllevar consecuencias para la empresa. ¿Está seguro de que quiere continuar?'),
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
                  deleteBCResource();
                }, 
                child: const Text("Continuar")
              ),
            ],
          ));
  }

  deleteBCResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    bool conf = await FirebaseUtils.instance.deleteDocument("material_boxes_and_cartons", bcResourcesModel.documentId!);
    
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

  navigateToNewHensTicker() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifyBoxesAndCartonsResourcesPage(currentUser, bcResourcesModel),
        ));

    if (result != null) {
      bcResourcesModel = result;
      setState(() {
        bcResourcesModel = result;
        fieldData = DBBoxesAndCartonsOrderFieldData.fromMap(result.order);
      });
    }
  }

}
