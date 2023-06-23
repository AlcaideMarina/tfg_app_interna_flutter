import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/workersresources/modify_worker_page.dart';
import 'package:hueveria_nieto_interna/utils/Utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../components/component_table_form.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class WorkerDetailPage extends StatefulWidget {
  const WorkerDetailPage(this.currentUser, this.workerUser, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final InternalUserModel workerUser;

  @override
  State<WorkerDetailPage> createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {
  late InternalUserModel currentUser;
  late InternalUserModel workerUser;
  late double? salary;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    workerUser = widget.workerUser;
    salary = workerUser.salary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Detalle de trabajador',
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
                        height: 16,
                      ),
                      getComponentTableForm("Sueldo", getSalaryCells(),
                          columnWidhts: {
                            1: const IntrinsicColumnWidth(),
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

  Widget getComponentTableForm(String label, List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;

    return HNComponentTableForm(
      label + ":",
      8,
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
    );
  }

  List<TableRow> getSalaryCells() {
    return [
      TableRow(children: [
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 8, bottom: 0),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            labelText: (salary ?? 0.0).toString(),
            isEnabled: false,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: const Text("€", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      ])
    ];
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
          child: const Text("ID:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16),
        ),
        Container(
          child: Text(workerUser.id.toString(), style: const TextStyle(fontSize: 16)),
          margin: const EdgeInsets.only(right: 16),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Nombre:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
        Container(
          child: Text(workerUser.name, style: const TextStyle(fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Apellidos:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
        Container(
          child: Text(workerUser.surname, style: const TextStyle(fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("DNI:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
        Container(
          child: Text(workerUser.dni, style: const TextStyle(fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Cuenta:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
        Container(
          child: Text(workerUser.bankAccount, style: const TextStyle(fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 4),
        ),
      ]),
      TableRow(children: [
        Container(
          child: const Text("Puesto:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 32),
        ),
        Container(
          child: Text(Utils().rolesIntToString(workerUser.position).toString(), style: const TextStyle(fontSize: 16)),
          margin: const EdgeInsets.only(right: 16, top: 32),
        ),
      ]),
    ];
  }

  Widget getButtonsComponent() {
    return HNButton(ButtonTypes.blackWhiteBoldRoundedButton).getTypedButton(
          'Modificar', null, null, navigateToModifyWorker, null,
    );
  }

  navigateToModifyWorker() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifyWorkerPage(currentUser, workerUser),
        ));

    if (result != null) {
      workerUser = result;
      salary = result.salary;
      setState(() {
        workerUser = result;
        salary = result.salary;
      });
    }
  }
}
