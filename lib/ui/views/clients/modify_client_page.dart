import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/flutterfire/firebase_utils.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/internal_user_model.dart';
import '../../components/component_cell_table_form.dart';
import '../../components/component_container_border_check_title.dart';
import '../../components/component_container_border_text.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_table_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyClientPage extends StatefulWidget {
  ModifyClientPage(this.currentUserData, this.clientData, {Key? key})
      : super(key: key);

  final InternalUserModel currentUserData;
  final ClientModel clientData;

  @override
  State<ModifyClientPage> createState() => _ModifyClientPageState();
}

class _ModifyClientPageState extends State<ModifyClientPage> {
  late InternalUserModel currentUserData;
  late ClientModel clientData;

  late int id;
  late String company;
  late String direction;
  late String city;
  late String province;
  late int postalCode;
  late String cif;
  late String email;
  late int phone1;
  late int phone2;
  late String namePhone1;
  late String namePhone2;
  bool hasAccount = false;
  String? user;

  int contCompany = 0;
  int contUser = 0;

  @override
  void initState() {
    super.initState();
    currentUserData = widget.currentUserData;
    clientData = widget.clientData;

    id = clientData.id;
    company = clientData.company;
    direction = clientData.direction;
    city = clientData.city;
    province = clientData.province;
    postalCode = clientData.postalCode;
    cif = clientData.cif;
    email = clientData.email;
    phone1 = clientData.phone[0].values.first;
    namePhone1 = clientData.phone[0].keys.first;
    phone2 = clientData.phone[1].values.first;
    namePhone2 = clientData.phone[1].keys.first;
    hasAccount = clientData.hasAccount;
    user = clientData.user;
  }

  List<String> labelList = [
    'Empresa',
    'Dirección',
    'Ciudad',
    'Provincia',
    'Código postal',
    'CIF',
    'Correo',
    'Confirmación del email',
    'Teléfono',
    'Precio/ud.',
  ];
  List<String> userLabels = ['Usuario'];

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    contCompany = 0;
    contUser = 0;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Información del cliente',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getAllFormElements(),
                            const SizedBox(
                              height: 32,
                            ),
                            getButtonsComponent(),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  Widget getAllFormElements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCompanyComponentSimpleForm(
            'Empresa', clientData.company, null, TextInputType.text, (value) {
          company = value;
        }),
        getCompanyComponentSimpleForm(
            'Dirección', clientData.direction, null, TextInputType.text,
            (value) {
          direction = value;
        }),
        getCompanyComponentSimpleForm(
            'Ciudad', clientData.city, null, TextInputType.text, (value) {
          city = value;
        }),
        getCompanyComponentSimpleForm(
            'Provincia', clientData.province, null, TextInputType.text,
            (value) {
          province = value;
        }),
        getCompanyComponentSimpleForm(
            'Código postal',
            clientData.postalCode.toString(),
            null,
            TextInputType.number, (value) {
          postalCode = int.parse(value);
        }),
        getCompanyComponentSimpleForm(
            'CIF', clientData.cif, null, TextInputType.text, (value) {
          cif = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm(
            'Correo', clientData.email, null, TextInputType.emailAddress,
            (value) {
          email = value;
        }, textCapitalization: TextCapitalization.none),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        clientData.hasAccount ? Container() : getClientUserContainerComponent(),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, updateClient, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.blackRedBoldRoundedButton)
              .getTypedButton('Cancelar', null, null, goBack, () {}),
        ],
      ),
    );
  }

  Widget getCompanyComponentSimpleForm(
      String label,
      String initialValue,
      String? labelInputText,
      TextInputType textInputType,
      Function(String)? onChange,
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contCompany == 0) {
      topMargin = 8;
    } else if (contCompany == labelList.length) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentSimpleForm(
        label + ':',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        HNComponentTextInput(
          textCapitalization: textCapitalization,
          labelText: labelInputText,
          initialValue: initialValue,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textInputType: textInputType,
          onChange: onChange,
          isEnabled: true,
          textColor: CustomColors.darkGrayColor,
        ),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin));
  }

  Widget getComponentTableForm(String label, List<TableRow> children,
      {Map<int, TableColumnWidth>? columnWidhts}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contCompany == 0) {
      topMargin = 8;
    } else if (contCompany == labelList.length - 1) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentTableForm(
      label,
      8,
      TableCellVerticalAlignment.middle,
      children,
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      columnWidths: columnWidhts,
    );
  }

  List<TableRow> getTelephoneTableRow() {
    return [
      TableRow(children: [
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 16, right: 8, bottom: 8),
            HNComponentTextInput(
              labelText: 'Teléfono',
              initialValue: phone1.toString(),
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                phone1 = int.parse(value);
              },
              isEnabled: true,
              textColor: CustomColors.darkGrayColor,
            )),
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 8, right: 16, bottom: 8),
            HNComponentTextInput(
              labelText: 'Nombre contacto',
              initialValue: namePhone1,
              textCapitalization: TextCapitalization.words,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                namePhone1 = value;
              },
              isEnabled: false,
              textColor: CustomColors.darkGrayColor,
            )),
      ]),
      TableRow(children: [
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 16, right: 8),
            HNComponentTextInput(
              labelText: 'Teléfono',
              initialValue: phone2.toString(),
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                phone2 = int.parse(value);
              },
              isEnabled: true,
              textColor: CustomColors.darkGrayColor,
            )),
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 8, right: 16),
            HNComponentTextInput(
              labelText: 'Nombre contacto',
              initialValue: namePhone2,
              textCapitalization: TextCapitalization.words,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                namePhone2 = value;
              },
              isEnabled: true,
              textColor: CustomColors.darkGrayColor,
            )),
      ]),
    ];
  }

  Widget getClientUserContainerComponent() {
    return HNComponentContainerBorderCheckTitle(
      'Crear usuario para la app cliente',
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 19),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.redPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(16),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getClientComponentSimpleForm(userLabels[0], TextInputType.text,
                (value) {
              user = value;
            }, isEnabled: hasAccount),
            const Text(
                'El usuario debe tener más de 6 dígitos.\nLa contraseña será igual que el usuario. Por favor, cámbiela en cuanto sea posible. Para hacer login, se necesitará el correo y la contraseña.'),
          ],
        ),
      ),
      (bool value) {
        hasAccount = value;
        setState(() {});
      },
      leftPosition: 24,
      rightPosition: 56,
      topPosition: 0,
      value: hasAccount,
    );
  }

  Widget getClientComponentSimpleForm(
      String label, TextInputType textInputType, Function(String)? onChange,
      {bool isEnabled = true}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contUser == 0) {
      topMargin = 0;
    } else if (contUser == userLabels.length - 1) {
      bottomMargin = 16;
    }
    contUser++;

    return HNComponentSimpleForm(
      label + ':',
      8,
      40,
      const EdgeInsets.only(left: 0),
      HNComponentTextInput(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textCapitalization: TextCapitalization.none,
        textInputType: textInputType,
        onChange: onChange,
        isEnabled: isEnabled,
        backgroundColor: isEnabled
            ? CustomColors.whiteColor
            : CustomColors.backgroundTextFieldDisabled,
        textColor: CustomColors.darkGrayColor,
      ),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      textMargin: const EdgeInsets.only(left: 24),
    );
  }

  goBack() {
    Navigator.of(context).pop();
  }

  updateClient() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    String? authConf = "uid";
    bool firestoreConf = false;
    bool createAuthAccount = false;

    if (clientData.hasAccount) {
      createAuthAccount = false;
    } else {
      createAuthAccount = hasAccount;
    }

    if (createAuthAccount) {
      if (user != null && user != "") {
        authConf = await FirebaseUtils.instance.createAuthAccount(email, user!);
        clientData.uid = authConf;
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Formulario incompleto'),
                  content: const Text(
                      'Es necesario introducir un usuario si se quiere crear una cuenta. Este usuario será la contraseña por defecto hasta que el cliente la modifique. Por favor, revise los datos y vuelva a intentarlo.'),
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

    if (authConf != null) {
      if (cif != "" &&
          city != "" &&
          company != "" &&
          direction != "" &&
          email != "" &&
          namePhone1 != "" &&
          phone1 != -1 &&
          namePhone2 != "" &&
          phone2 != -1 &&
          postalCode != -1 &&
          province != "") {
        ClientModel updatedClient = ClientModel(
            cif,
            city,
            company,
            clientData.createdBy,
            clientData.deleted,
            direction,
            email,
            hasAccount,
            id,
            [
              {namePhone1: phone1},
              {namePhone2: phone2}
            ],
            postalCode,
            province,
            clientData.uid,
            user,
            clientData.documentId);
        firestoreConf =
            await FirebaseUtils.instance.updateClient(updatedClient);
        if (firestoreConf) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Cliente guardado'),
                    content: const Text(
                        'La información del cliente se ha guardado correctamente'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('De acuerdo.'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context, updatedClient);
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
                        'Ha ocurrido un problema al guardar el cliente en la base de datos. Por favor, revise los datos e inténtelo de nuevo.'),
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
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Formulario incompleto'),
                content: const Text(
                    'Por favor, revise los datos e inténtelo de nuevo.'),
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
