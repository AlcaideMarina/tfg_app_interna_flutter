import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/feed_resources_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/feedresources/modify_feed_resources_page.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class FeedResourcesDetailPage extends StatefulWidget {
  const FeedResourcesDetailPage(this.currentUser, this.feedModel,  {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final FeedResourcesModel feedModel;

  @override
  State<FeedResourcesDetailPage> createState() => _FeedResourcesDetailPageState();
}

class _FeedResourcesDetailPageState extends State<FeedResourcesDetailPage> {
  late InternalUserModel currentUser;
  late FeedResourcesModel feedResourcesModel;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    feedResourcesModel = widget.feedModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Detalle - Pienso',
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
    return [
      TableRow(
        children: [
          Container(
            child: Text("Fecha:"),
            margin: const EdgeInsets.only(right: 16),
          ),
          Container(
            child: Text(Utils().parseTimestmpToString(feedResourcesModel.expenseDatetime) ?? ""),
            margin: const EdgeInsets.only(left: 16),
          ),
        ]
      ),
      TableRow(
        children: [
          Container(
            child: Text("Cantidad (kg):"),
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
                labelText: feedResourcesModel.kilos.toString(),
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
                labelText: feedResourcesModel.totalPrice.toString(),
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
              .getTypedButton('Modificar', null, null, navigateToModifyFeedResource, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Eliminar', 
                null, 
                null, 
                warningDeleteFeedResource, 
                null, 
              ),
        ])
    );
  }

  warningDeleteFeedResource() {
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
                  deleteFeedResource();
                }, 
                child: const Text("Continuar")
              ),
            ],
          ));
  }

  deleteFeedResource() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);
    bool conf = await FirebaseUtils.instance.deleteDocument("material_feed", feedResourcesModel.documentId!);
    
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

  navigateToModifyFeedResource() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ModifyFeedResourcesPage(currentUser, feedResourcesModel)));

    if (result != null) {
      feedResourcesModel = result;
      setState(() {});
    }
  }

}
