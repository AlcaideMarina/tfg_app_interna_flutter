import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/finalproductcontrol/modify_final_product_control_page.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/fpc_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class FinalProductControlDetailPage extends StatefulWidget {
  const FinalProductControlDetailPage(this.currentUser, this.fpcModel,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final FPCModel fpcModel;

  @override
  State<FinalProductControlDetailPage> createState() =>
      _FinalProductControlDetailPageState();
}

class _FinalProductControlDetailPageState
    extends State<FinalProductControlDetailPage> {
  late InternalUserModel currentUser;
  late FPCModel fpcModel;

  @override
  void initState() {
    super.initState();

    currentUser = widget.currentUser;
    fpcModel = widget.fpcModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Detalle control prod. final',
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
                      getComponentTableFormWithoutLabel(
                          getPricePerUnitTableRow(),
                          columnWidhts: {
                            0: const IntrinsicColumnWidth()
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

  Widget getComponentTableFormWithoutLabel(List<TableRow> children,
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

  Widget getButtonsComponent() {
    return Column(children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton).getTypedButton(
              'Modificar', null, null, navigateToModifyFeedResource, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
            'Eliminar',
            null,
            null,
            warningDeleteFPCResource,
            null,
          ),
        ]);
  }

  List<TableRow> getPricePerUnitTableRow() {
    List<TableRow> list = [
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 12, right: 16),
              child: const Text(
                "Fch. puesta:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: TextInputType.none,
              isEnabled: false,
              labelText: Utils().parseTimestmpToString(fpcModel.layingDatetime),
            ),
          ),
        ],
      ),
      TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 12, right: 16),
            child: const Text("Fch. envasado:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: TextInputType.none,
            isEnabled: false,
            labelText: Utils().parseTimestmpToString(fpcModel.layingDatetime),
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Control de huevos:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(left: 12, right: 16, top: 16),
        ),
        Container(),
      ]),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: const Text("Aceptados:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
          Container(
            height: 40,
            margin: const  EdgeInsets.only(left: 8, bottom: 0, top: 8),
            child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: fpcModel.acceptedEggs.toString(),
                isEnabled: false),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: const Text("Rechazados:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              labelText: fpcModel.rejectedEggs.toString(),
              isEnabled: false,
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(
                left: 12,
                right: 16,
                top: 16
              ),
              child: const Text("Lote:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 16),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: const TextInputType.numberWithOptions(),
              labelText: fpcModel.lot.toString(),
              isEnabled: false,
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 12, right: 16),
              child: const Text("F. C. Pref.:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
            child: HNComponentTextInput(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textInputType: TextInputType.none,
              isEnabled: false,
              labelText:
                  Utils().parseTimestmpToString(fpcModel.bestBeforeDatetime),
            ),
          ),
        ],
      ),
      TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 12, right: 16),
            child: const Text("Fch. expedición:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: TextInputType.none,
            isEnabled: false,
            labelText: Utils().parseTimestmpToString(fpcModel.issueDatetime),
          ),
        ),
      ]),
    ];
    return list;
  }

  warningDeleteFPCResource() {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Aviso importante'),
              content: Text(
                  'Esta acción es irreversible. Va a eliminar esta información, y puede conllevar consecuencias para la empresa. ¿Está seguro de que quiere continuar?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Atrás")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteFPCResource();
                    },
                    child: const Text("Continuar")),
              ],
            ));
  }

  deleteFPCResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    bool conf = await FirebaseUtils.instance
        .deleteDocument("final_product_control", fpcModel.documentId!);

    Navigator.pop(context);
    if (conf) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('CPF eliminado'),
                content: const Text(
                    'La información del control de producto final ha sido eliminado correctamente.'),
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
                    'Se ha producido un error al eliminar el registro. Por favor, inténtelo de nuevo.'),
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

  navigateToModifyFeedResource() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ModifyFinalProductControlPage(currentUser, fpcModel)));

    if (result != null) {
      fpcModel = result;
      setState(() {});
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
