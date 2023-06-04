import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/data/models/monitoring_company_situation_model.dart';
import 'package:hueveria_nieto_interna/ui/components/component_table_form_without_label.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../components/component_table_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class DailyMonitoringCompanySituationPage extends StatefulWidget {
  const DailyMonitoringCompanySituationPage(this.currentUser, this.mcsModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final MonitoringCompanySituationModel mcsModel;

  @override
  State<DailyMonitoringCompanySituationPage> createState() => _DailyMonitoringCompanySituationPageState();
}

class _DailyMonitoringCompanySituationPageState extends State<DailyMonitoringCompanySituationPage> {
  late InternalUserModel currentUser;
  late MonitoringCompanySituationModel mcsModel;

  @override
  void initState() {
    super.initState();
    
    currentUser = widget.currentUser;
    mcsModel = widget.mcsModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Seg. sit. empresa - Detalle',
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
                      getComponentTableForm(getCells(), 
                        columnWidhts: {
                          0: const IntrinsicColumnWidth(),
                          2: const IntrinsicColumnWidth()
                        }),
                      const SizedBox(
                        height: 32,
                      ),
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

  Widget getComponentTableForm(List<TableRow> children,
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
    List<TableRow> list = [
        TableRow(
          children: [
            Container(
              child: Text("Fecha:"),
              margin: const EdgeInsets.only(left: 12, right: 16),
            ),
            Container(
              child: Text(Utils().parseTimestmpToString(mcsModel.situationDatetime) ?? "-"),
              margin: const EdgeInsets.only(left: 12, right: 16),
            ),
          ]
        ),
        TableRow(
          children: [
            Container(
              child: Text("Huevos:"),
              margin: const EdgeInsets.only(left: 12, right: 16, top: 16),
            ),
            Container()
          ]
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Cajas XL:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (mcsModel.xlEggs['box'] ?? 0).toString(),
                isEnabled: false,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Huevos:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 0, top: 8),
              child: Text((mcsModel.xlEggs['eggs'] ?? 0).toString()),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Cartones:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 8, top: 8),
              child: Text((mcsModel.xlEggs['cartons'] ?? 0).toString()),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Cajas L:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (mcsModel.lEggs['box'] ?? 0).toString(),
                isEnabled: false,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Huevos:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 0, top: 8),
              child: Text((mcsModel.lEggs['eggs'] ?? 0).toString()),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Cartones:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 8, top: 8),
              child: Text((mcsModel.lEggs['cartons'] ?? 0).toString()),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Cajas M:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (mcsModel.mEggs['box'] ?? 0).toString(),
                isEnabled: false,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Huevos:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 0, top: 8),
              child: Text((mcsModel.mEggs['eggs'] ?? 0).toString()),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Cartones:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 8, top: 8),
              child: Text((mcsModel.mEggs['cartons'] ?? 0).toString()),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Cajas S:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (mcsModel.sEggs['box'] ?? 0).toString(),
                isEnabled: false,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Huevos:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 0, top: 8),
              child: Text((mcsModel.sEggs['eggs'] ?? 0).toString()),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 16, top: 8),
              child: Text("Cartones:")),
            Container(
              margin: EdgeInsets.only(left: 24, bottom: 8, top: 8),
              child: Text((mcsModel.sEggs['cartons'] ?? 0).toString()),
            ),
          ],
        ),
        
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16),
              child: Text("Bajas gallinas:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (mcsModel.hens['losses'] ?? 0).toString(),
                isEnabled: false,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 16, top: 8),
              child: Text("Huevos rotos:")),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 8, bottom: 0, top: 8),
              child: HNComponentTextInput(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textInputType: const TextInputType.numberWithOptions(),
                labelText: (mcsModel.brokenEggs).toString(),
                isEnabled: false,
              ),
            ),
          ],
        ),
    ];
    return list;

  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
        .getTypedButton(
          mcsModel.documentId == null ? 'Añadir' : 'Modificar', null, null, () {}, null),
    );
  }

}
