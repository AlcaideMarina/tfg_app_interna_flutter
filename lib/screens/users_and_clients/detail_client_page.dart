import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_cell_table_form.dart';
import 'package:hueveria_nieto_interna/component/component_container_border_check_title.dart';
import 'package:hueveria_nieto_interna/component/component_container_border_text.dart';
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
import '../../services/products_service.dart';

// TODO: Cuidado - todo esta clase está hardcodeada
// TODO: Intentar reducir código

class ClientDetailPage extends StatefulWidget {
  const ClientDetailPage(this.currentUser, this.client, {Key? key}) : super(key: key);

  final CurrentUserModel currentUser;
  final ClientModel client;

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  late CurrentUserModel currentUser;
  late ClientModel client;

  late String id;
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
  String? user;
  String? emailAccount;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    client = widget.client;
    
    id = client.id;
    company = client.company;
    direction = client.direction;
    city = client.city;
    province = client.province;
    postalCode = client.postalCode;
    cif = client.cif;
    email = client.email;
    phone1 = client.phone[0].values.first;
    namePhone1 = client.phone[0].keys.first;
    phone2 = client.phone[1].values.first;
    namePhone2 = client.phone[1].keys.first;
    prices = client.price;
    hasAccount = client.hasAccount;
    user = client.user;
    emailAccount = client.emailAccount;
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

  Map<String, String> eggTypes = {
    'xl': 'Cajas XL',
    'l': 'Cajas L',
    'm': 'Cajas M',
    's': 'Cajas S',
    'cartoned': 'Estuchados'
  };
  List<String> userLabels = ['Usuario', 'Correo', 'Confirmación del correo'];
  // TODO: Mirar otra forma de contar - ¿mapas?
  int contCompany = 0;
  int contUser = 0;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    final productsService = Provider.of<ProductsService>(context);

    prices = productsService
        .products; // TODO: Fix - cuando abres por primera vez viene todo a 0.0

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
              'Información del cliente',
              style: TextStyle(
                  color: AppTheme.primary, fontSize: CustomSizes.textSize24),
            )),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(72, 0, 48, 16),
                child: Text(
                  client.company,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.start,
                ),
              ),
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
                            const Text('Últimos pedidos:', style: TextStyle(fontWeight: FontWeight.bold),),
                            // TODO: A falta que hacer la parte de pedidos
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
        Text('ID: ' + client.id),
        getCompanyComponentSimpleForm('Empresa', client.company, null, TextInputType.text,
            (value) {
          company = value;
        }),
        getCompanyComponentSimpleForm('Dirección', client.direction, null, TextInputType.text,
            (value) {
          direction = value;
        }),
        getCompanyComponentSimpleForm('Ciudad', client.city, null, TextInputType.text,
            (value) {
          city = value;
        }),
        getCompanyComponentSimpleForm('Provincia', client.province, null, TextInputType.text,
            (value) {
          province = value;
        }),
        getCompanyComponentSimpleForm(
            'Código postal', client.postalCode.toString(), null, TextInputType.number, (value) {
          postalCode = int.parse(value);
        }),
        getCompanyComponentSimpleForm('CIF', client.cif, null, TextInputType.text, (value) {
          cif = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm(
            'Correo', client.email, null, TextInputType.emailAddress, (value) {
          email = value;
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
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Modificar', null, null, saveClient, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.blackRedBoldRoundedButton)
              .getTypedButton('Cancelar', null, null, goBack, () {}),
        ],
      ),
    );
  }

  Widget getCompanyComponentSimpleForm(String label, String initialValue, String? labelInputText,
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
          initialValue: initialValue,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textInputType: textInputType,
          onChange: onChange,
          isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
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
          isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
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
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
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
          isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
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
          isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
          textColor: CustomColors.darkGrayColor,
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
          isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
          textColor: CustomColors.darkGrayColor,
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
    return HNComponentContainerBorderText(
      'Usuario de la aplicación',
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 19),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.redPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(16),
          shape: BoxShape.rectangle,
        ),
        child: hasAccount ? clientHasAppAccount() : clientHasNotAppAccount()
      ),
      leftPosition: 24,
      rightPosition: 150,
      topPosition: 10,
    );
  }

  Widget getClientComponentSimpleForm(
      String label, TextInputType textInputType, Function(String)? onChange) {
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
          isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
          textColor: CustomColors.darkGrayColor,
      ),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      textMargin: const EdgeInsets.only(left: 24),
    );
  }

  Widget clientHasAppAccount() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getClientComponentSimpleForm(userLabels[0], TextInputType.text,
                (value) {
              user = value;
            }),
            getClientComponentSimpleForm(
                userLabels[1], TextInputType.emailAddress, (value) {
              emailAccount = value;
            }),
            HNButton(ButtonTypes.blackRedRoundedButton).getTypedButton('Eliminar', null, null, () { }, () { })

          ],
        );
  }

  Widget clientHasNotAppAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('El cliente no tiene cuenta de la aplicación.'),
        const SizedBox(height: 16,),
        HNButton(ButtonTypes.blackWhiteRoundedButton).getTypedButton('Crear cuenta', null, null, () { }, () { })
      ]
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
          id,
          company,
          direction,
          city,
          province,
          postalCode,
          cif,
          email,
          [
            {namePhone1: phone1},
            {namePhone2: phone2}
          ],
          prices,
          hasAccount,
          hasAccount ? user : null,
          hasAccount ? emailAccount : null,
          Timestamp.now(),
          currentUser.documentId,
          null, // TODO: Pendiente del UID que devuelva la parte de authentication
          false);

      await FirebaseFirestore.instance.collection('client_info').add({
        'id': client.id,
        'company': client.company,
        'direction': client.direction,
        'city': client.city,
        'province': client.province,
        'postal_code': client.postalCode,
        'cif': client.cif,
        'email': client.email,
        'phone': client.phone,
        'price': client.price,
        'has_account': client.hasAccount,
        'user': client.user,
        'email_account': client.emailAccount,
        'creation_datetime': client.creationDatetime,
        'created_by': client.createdBy,
        'uid': client.uid,
        'deleted': client.deleted
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
