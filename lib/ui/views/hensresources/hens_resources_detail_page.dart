import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/hens_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/Utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';
import 'modify_hens_resources_page.dart';

class HensResourcesDetailPage extends StatefulWidget {
  const HensResourcesDetailPage(this.currentUser, this.hensResourcesModel,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final HensResourcesModel hensResourcesModel;

  @override
  State<HensResourcesDetailPage> createState() =>
      _HensResourcesStateDetailPage();
}

class _HensResourcesStateDetailPage extends State<HensResourcesDetailPage> {
  late InternalUserModel currentUser;
  late HensResourcesModel hensResourcesModel;

  @override
  void initState() {
    super.initState();

    currentUser = widget.currentUser;
    hensResourcesModel = widget.hensResourcesModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Detalle registro gallinas',
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
            isEnabled: false,
            labelText: hensResourcesModel.hensNumber.toString(),
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
                  isEnabled: false,
                  labelText: hensResourcesModel.totalPrice.toString(),
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
              'Modificar', null, null, navigateToModifyHensResource, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
            'Eliminar',
            null,
            null,
            warningDeleteHensResource,
            null,
          ),
        ]);
  }

  warningDeleteHensResource() {
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
                    child: const Text("Atrás")),
                TextButton(
                    onPressed: () {
                      Navigator.of(this.context).pop();
                      deleteHensResource();
                    },
                    child: const Text("Continuar")),
              ],
            ));
  }

  deleteHensResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    bool conf = await FirebaseUtils.instance
        .deleteDocument("material_hens", hensResourcesModel.documentId!);

    Navigator.pop(context);
    if (conf) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Recurso eliminado'),
                content:
                    const Text('El recurso ha sido eliminado correctamente.'),
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

  navigateToModifyHensResource() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ModifyHensResourcesPage(currentUser, hensResourcesModel)));

    if (result != null) {
      hensResourcesModel = result;
      setState(() {});
    }
  }
}
