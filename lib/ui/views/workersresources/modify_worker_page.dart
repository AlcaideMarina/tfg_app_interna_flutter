import 'package:flutter/material.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../components/component_table_form.dart';
import '../../components/component_table_form_without_label.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyWorkerPage extends StatefulWidget {
  const ModifyWorkerPage(this.currentUser, this.workerUser, {Key? key})
      : super(key: key);

  final InternalUserModel currentUser;
  final InternalUserModel workerUser;

  @override
  State<ModifyWorkerPage> createState() => _ModifyWorkerPageState();
}

class _ModifyWorkerPageState extends State<ModifyWorkerPage> {
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
              'Modificar trabajador',
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
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            initialValue: (salary ?? 0.0).toString(),
            isEnabled: true,
            onChange: (value) {
              salary = double.tryParse(value) ?? 0.0;
            },
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: const Text("€", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
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
    return Column(children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, updateUserWarning, null),
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

  updateUserWarning() {
    if (salary != null && salary != 0.0) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Aviso'),
                content: Text(
                    'Esta acción cambiará el salario del trabajador con DNI ${workerUser.dni}, pasando de ser de ${workerUser.salary ?? "-"} € mensuales, a $salary €.\n¿Está seguro de que quiere continuar?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Atrás'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Continuar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      updateSalary();
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Formulario incorrecto'),
                content: const Text(
                    'Los datos introducidos no son válidos. Por favor, revise el formulario e inténtelo de nuevo.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  updateSalary() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    InternalUserModel updatedUser = InternalUserModel(
        workerUser.bankAccount,
        workerUser.city,
        workerUser.createdBy,
        workerUser.deleted,
        workerUser.direction,
        workerUser.dni,
        workerUser.email,
        workerUser.id,
        workerUser.name,
        workerUser.phone,
        workerUser.position,
        workerUser.postalCode,
        workerUser.province,
        salary,
        workerUser.ssNumber,
        workerUser.surname,
        workerUser.uid,
        workerUser.user,
        workerUser.documentId);

    bool firestoreConf = await FirebaseUtils.instance.updateDocument(
        "user_info", updatedUser.documentId!, updatedUser.toMap());
    if (firestoreConf) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Sueldo actualizado'),
                content: const Text(
                    'El sueldo del trabajador ha sido modificado correctamente.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, updatedUser);
                    },
                  )
                ],
              ));
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Se ha producido un error cuando se estaban actualizando los datos del usuario. Por favor, revise los datos e inténtelo de nuevo.'),
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
}
