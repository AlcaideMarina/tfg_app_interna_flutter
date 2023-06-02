import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/fpc_model.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class FinalProductControlDetailPage extends StatefulWidget {
  const FinalProductControlDetailPage(this.currentUser, this.fpcModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final FPCModel fpcModel;

  @override
  State<FinalProductControlDetailPage> createState() => _FinalProductControlDetailPageState();
}

class _FinalProductControlDetailPageState extends State<FinalProductControlDetailPage> {
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
              'Detalle CPF',
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
                      getComponentTableFormWithoutLabel(getPricePerUnitTableRow(), 
                        columnWidhts: {
                          0: const IntrinsicColumnWidth(),
                          2: const IntrinsicColumnWidth()
                        }),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Modificar', null, null, () {}, null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Eliminar', 
                null, 
                null, 
                () {},
                null, 
              ),
        ])
    );
  }

  List<TableRow> getPricePerUnitTableRow() {
    List<TableRow> list = [
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Fch. puesta:")),
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
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Fch. envasado:")),
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
          ]
        ),
        TableRow(
          children: [
            Container(
              child: Text("Control de huevos:"),
              margin: const EdgeInsets.only(left: 12, right: 16, top: 16),
            ),
            Container(),
          ]
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Aceptados:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 8),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: fpcModel.acceptedEggs.toString(),
                isEnabled: false
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Rechazados:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 4),
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
              margin: const EdgeInsets.only(left: 24, right: 16,),
              child: Text("Lote:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 16),
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
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("F. C. Pref.:")),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8, bottom: 0, top: 4),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: TextInputType.none,
                isEnabled: false,
                labelText: Utils().parseTimestmpToString(fpcModel.bestBeforeDatetime),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Fch. expedición:")),
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
          ]
        ),
    ];
    return list;

  }
}
