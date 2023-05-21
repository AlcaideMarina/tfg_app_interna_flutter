import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_cell_table_form.dart';
import 'package:hueveria_nieto_interna/component/component_container_border_check_title.dart';
import 'package:hueveria_nieto_interna/component/component_simple_form.dart';
import 'package:hueveria_nieto_interna/component/component_table_form.dart';
import 'package:hueveria_nieto_interna/component/component_text_input.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/model/client_model.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import '../../flutterfire/flutterfire.dart';
import '../../model/current_user_model.dart';

// TODO: Cuidado - todo esta clase está hardcodeada
// TODO: Intentar reducir código

class NewClientPage extends StatefulWidget {
  const NewClientPage(this.currentUser, {Key? key}) : super(key: key);

  final CurrentUserModel currentUser;

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

// TODO: Faltan todas las validaciones
class _NewClientPageState extends State<NewClientPage> {
  late CurrentUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

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
  Map<String, double> prices = {};
  bool hasAccount = false;
  // TODO: Mirar otra forma de contar - ¿mapas?
  String? user;
  String? emailAccount;

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

  Map<String, String> eggTypes = {
    'xl': 'Cajas XL',
    'l': 'Cajas L',
    'm': 'Cajas M',
    's': 'Cajas S',
    'cartoned': 'Estuchados'
  };
  List<String> userLabels = ['Usuario', 'Correo', 'Confirmación del correo'];
  int contCompany = 0;
  int contUser = 0;

  bool isEmailConfirmated = false;
  bool isEmailAccountConfirmated = false;

  final TextEditingController userController = TextEditingController();
  String companyUserName = '';
  String phone1UserName = '';
  String phone1NameUserName = '';

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print('NULO');
    } else {
      print('NO NULO');
    }
    contCompany = 0;
    contUser = 0;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Nuevo cliente',
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
                      getAllFormElements(),
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

  Widget getAllFormElements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCompanyComponentSimpleForm('Empresa', null, TextInputType.text,
            (value) {
          company = value;
          // format user
          companyUserName = value.toLowerCase().replaceAll(RegExp(' '), '_');
          userController.text =
              companyUserName + '_' + phone1NameUserName + '_' + phone1UserName;
        }),
        getCompanyComponentSimpleForm('Dirección', null, TextInputType.text,
            (value) {
          direction = value;
        }),
        getCompanyComponentSimpleForm('Ciudad', null, TextInputType.text,
            (value) {
          city = value;
        }),
        getCompanyComponentSimpleForm('Provincia', null, TextInputType.text,
            (value) {
          province = value;
        }),
        getCompanyComponentSimpleForm(
            'Código postal', null, TextInputType.number, (value) {
          postalCode = int.parse(value);
        }),
        getCompanyComponentSimpleForm('CIF', null, TextInputType.text, (value) {
          cif = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm(
            'Correo', null, TextInputType.emailAddress, (value) {
          email = value;
        }, textCapitalization: TextCapitalization.none),
        getCompanyComponentSimpleForm(
            'Confirmación del correo', null, TextInputType.emailAddress,
            (value) {
          isEmailConfirmated = (value == email);
        }, textCapitalization: TextCapitalization.none),
        getComponentTableForm('Teléfono', getTelephoneTableRow()),
        getComponentTableForm('Precio/ud.', getPricePerUnitTableRow(),
            columnWidhts: {
              0: const IntrinsicColumnWidth(),
              2: const IntrinsicColumnWidth()
            }),
        getClientUserContainerComponent(),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, saveClient, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Cancelar', null, null, goBack, () {}),
        ],
      ),
    );
  }

  Widget getCompanyComponentSimpleForm(String label, String? labelInputText,
      TextInputType textInputType, Function(String)? onChange,
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textInputType: textInputType,
          onChange: onChange,
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
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                phone1 = int.parse(value);
                // format user
                if (value.length > 2) {
                  phone1UserName = value.substring(value.length - 2);
                } else {
                  phone1UserName = '';
                }
                userController.text = companyUserName +
                    '_' +
                    phone1NameUserName +
                    '_' +
                    phone1UserName;
              },
            )),
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 8, right: 16, bottom: 8),
            HNComponentTextInput(
              labelText: 'Nombre contacto',
              textCapitalization: TextCapitalization.words,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                namePhone1 = value;
                // format user
                phone1NameUserName = '';
                final list = namePhone1.split(' ');
                for (String word in list) {
                  if (word.isNotEmpty) {
                    phone1NameUserName += word.toLowerCase().substring(0, 1);
                  }
                }
                userController.text = companyUserName +
                    '_' +
                    phone1NameUserName +
                    '_' +
                    phone1UserName;
              },
            )),
      ]),
      TableRow(children: [
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 16, right: 8),
            HNComponentTextInput(
              labelText: 'Teléfono',
              textInputType: TextInputType.number,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                phone2 = int.parse(value);
              },
            )),
        HNComponentCellTableForm(
            40,
            const EdgeInsets.only(left: 8, right: 16),
            HNComponentTextInput(
              labelText: 'Nombre contacto',
              textCapitalization: TextCapitalization.words,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onChange: (value) {
                namePhone2 = value;
              },
            )),
      ]),
    ];
  }

  List<TableRow> getPricePerUnitTableRow() {
    List<TableRow> list = [];
    int cont = 0;
    for (var key in eggTypes.keys) {
      double bottomMargin = 8;
      if (cont == eggTypes.length) {
        bottomMargin = 0;
      }

      list.add(TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text(eggTypes[key] ?? 'error - ' + key)),
        Container(
          height: 40,
          margin: EdgeInsets.only(left: 8, right: 16, bottom: bottomMargin),
          child: HNComponentTextInput(
            initialValue: prices[key] != null ? prices[key].toString() : '0.0',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            onChange: (value) {
              // TODO: Fix - Aquí hay que meter una validación para comprobar que el input se pueda pasar a double
              prices[key] = double.parse(value);
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: const Text('€'),
        )
      ]));

      cont++;
    }
    return list;
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
            }, controller: userController),
            getClientComponentSimpleForm(
                userLabels[1], TextInputType.emailAddress, (value) {
              emailAccount = value;
            }),
            getClientComponentSimpleForm(
                userLabels[2], TextInputType.emailAddress, (value) {
              isEmailAccountConfirmated = (value == emailAccount);
            }),
            const Text(
                'Se le mandará a esta dirección de correo un mensaje con la información para terminar de crear la cuenta.'),
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
      {TextEditingController? controller}) {
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
        textEditingController: controller,
      ),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      textMargin: const EdgeInsets.only(left: 24),
    );
  }

  saveClient() async {
    try {
      // TODO: Cerrar el teclado
      // TODO: CircularProgressIndicator()

      // TODO: Conseguir el valor del id
      id = await getNextUserId();
      // TODO: si hasAccount == true y email_account no es nulo, hay que hacer llamada también a Firebase Auth
      if (hasAccount && emailAccount != null) {
        // Pendiente de desarrollo de app cliente - ¿creo contraseña que aparezca en el correo y luego que se modifique?
      }

      final client = ClientModel(
          cif,
          city,
          company,
          currentUser.documentId,
          false,
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
          null, // TODO: Pendiente del UID que devuelva la parte de authentication
          hasAccount ? user : null,
          null
      );

      await FirebaseFirestore.instance.collection('client_info').add({
        'cif': client.cif,
        'city': client.city,
        'company': client.company,
        'created_by': client.createdBy,
        'deleted': client.deleted,
        'direction': client.direction,
        'email': client.email,
        'id': client.id,
        'has_account': client.hasAccount,
        'phone': client.phone,
        'postal_code': client.postalCode,
        'province': client.province,
        'uid': client.uid,
        'user': client.user
      });

      // TODO: Cerrar CircularProgressIndicator()

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
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  )
                ],
              ));
    } catch (e) {
      developer.log(e.toString(), name: 'Error - NewPageDart');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Vaya...'),
                content: const Text('Se ha producido un error'),
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

  goBack() {
    Navigator.of(context).pop();
  }
}
