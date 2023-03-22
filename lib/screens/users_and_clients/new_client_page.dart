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
  Map<String, double> prices = {'xl': 0.0, 'l': 0.0, 'm': 0.0, 's': 0.0, 'cartoned': 0.0};
  // TODO: Borrar estas variables - Ahora se usa el mapa anterior
  late double priceXl;
  late double priceL;
  late double priceM;
  late double priceS;
  late double cartoned;
  //
  bool hasAccount = false;
  // TODO: Mirar otra forma de contar - ¿mapas?
  String? user;
  String? emailAccount;

  // TODO: Refactorizar esto - ¿se puede borrar?
  List<String> labelList = [
    "Empresa",
    "Dirección",
    "Ciudad",
    "Provincia",
    "Código postal",
    "CIF",
    "Correo",
    'Confirmación del email'
    "Teléfono",
    "Precio/ud.",
  ];
  Map<String, TextInputType> labelInfo = {
    "Empresa": TextInputType.text,
    "Dirección": TextInputType.text,
    "Ciudad": TextInputType.text,
    "Provincia": TextInputType.text,
    "Código postal": TextInputType.number,
    "CIF": TextInputType.text,
    "Correo": TextInputType.emailAddress,
    "Teléfono": TextInputType.phone,
    "Precio/ud.": TextInputType.number,
  };
  //

  Map<String, String> eggTypes = {
    'xl': "Cajas XL",
    'l': "Cajas L",
    'm': "Cajas M",
    's': "Cajas S",
    'cartoned': "Estuchados"
  };
  List<String> userLabels = ["Usuario", "Correo", 'Confirmación del correo'];
  int contCompany = 0;
  int contUser = 0;

  bool isEmailConfirmated = false;
  bool isEmailAccountConfirmated = false;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    // TODO: Calcular ID
    id = '000001';

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }
    contCompany = 0;
    contUser = 0;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              "Nuevo cliente",
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
        Text('ID: ' + id), // TODO: Falta el ID
        // TODO: Aquí hay que personalizar el campo
        getCompanyComponentSimpleForm(
          'Empresa',
          null,
          TextInputType.text,
          (value) {
            company = value;
            // TODO: format user
          }
        ),
        getCompanyComponentSimpleForm(
            'Dirección', 
            null,
            TextInputType.text,
            (value) {
              direction = value;
            }
        ),
        getCompanyComponentSimpleForm(
            'Ciudad', 
            null,
            TextInputType.text,
            (value) {
              city = value;
            }
        ),
        getCompanyComponentSimpleForm(
            'Provincia', 
            null,
            TextInputType.text,
            (value) {
              province = value;
            }
        ),
        getCompanyComponentSimpleForm(
            'Código postal', 
            null,
            TextInputType.number,
            (value) {
              postalCode = int.parse(value);
            }
        ),
        getCompanyComponentSimpleForm(
            'CIF', 
            null,
            TextInputType.text,
            (value) {
              cif = value;
            },
            textCapitalization: TextCapitalization.characters
        ),
        getCompanyComponentSimpleForm(
            'Correo', 
            null,
            TextInputType.emailAddress,
            (value) {
              email = value;
            },
            textCapitalization: TextCapitalization.none
        ),
        getCompanyComponentSimpleForm(
            'Confirmación del correo', 
            null,
            TextInputType.emailAddress,
            (value) {
              isEmailConfirmated = (value == email);
            },
            textCapitalization: TextCapitalization.none
        ),
        getComponentTableForm(
            'Teléfono',
            getTelephoneTableRow()
        ),
        getComponentTableForm(
            'Precio/ud.',
            getPricePerUnitTableRow(),
            columnWidhts: {0: const IntrinsicColumnWidth()}),
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
              .getTypedButton("Guardar", null, null, saveClient, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton("Cancelar", null, null, goBack, () {}),
        ],
      ),
    );
  }

  Widget getCompanyComponentSimpleForm(
      String label, String? labelInputText, TextInputType textInputType, Function(String)? onChange, {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contCompany == 0) {
      topMargin = 8;
    } else if (contCompany == labelList.length) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentSimpleForm(
        label + ":",
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: const TextInputType.numberWithOptions(),
            onChange: (value) {
              prices[key] = double.parse(value);
            },
          ),
        ),
      ]));

      cont ++;
    }
    /*for (int i = 0; i < eggTypes.length; i++) {
      double bottomMargin = 8;
      if (i == eggTypes.length) {
        bottomMargin = 0;
      }
      list.add(TableRow(children: [
        Container(
            margin: const EdgeInsets.only(left: 24, right: 16),
            child: Text(eggTypes[i])),
        Container(
          height: 40,
          margin: EdgeInsets.only(left: 8, right: 16, bottom: bottomMargin),
          child: HNComponentTextInput(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textInputType: textInputType,
            onChange: onChange,
          ),
        ),
      ]));
    }*/
    return list;
  }

  Widget getClientUserContainerComponent() {
    return HNComponentContainerBorderCheckTitle(
      "Crear usuario para la app cliente",
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
            getClientComponentSimpleForm(userLabels[0], TextInputType.text, (value) {user = value;}),
            getClientComponentSimpleForm(userLabels[1], TextInputType.emailAddress, (value) {
              emailAccount = value;
            }),
            getClientComponentSimpleForm(userLabels[2], TextInputType.emailAddress, (value) {
              isEmailAccountConfirmated = (value == emailAccount);
            }),
            const Text(
                "Se le mandará a esta dirección de correo un mensaje con la información para terminar de crear la cuenta."),
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

  Widget getClientComponentSimpleForm(String label, TextInputType textInputType, Function(String)? onChange) {
    double topMargin = 4;
    double bottomMargin = 4;
    if (contUser == 0) {
      topMargin = 0;
    } else if (contUser == userLabels.length - 1) {
      bottomMargin = 16;
    }
    contUser++;

    return HNComponentSimpleForm(
      label + ":",
      8,
      40,
      const EdgeInsets.only(left: 0),
      HNComponentTextInput(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textCapitalization: TextCapitalization.none,
        textInputType: textInputType,
        onChange: onChange,
      ),
      EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      textMargin: const EdgeInsets.only(left: 24),
    );
  }

  saveClient() async {
    try {
      // TODO: si hasAccount == true y email_account no es nulo, hay que hacer llamada también a Firebase Auth
      if (hasAccount && emailAccount != null) {
        // Pendiente de desarrollo de app cliente - ¿creo contraseña que aparezca en el correo y luego que se modifique?
      } 

      // TODO: Hay que sacar los datos del cliente
      final client = ClientModel(
        id, 
        company, 
        direction, 
        city, 
        province, 
        postalCode, 
        cif, 
        email, 
        [{namePhone1: phone1}, {namePhone2: phone2}], 
        prices, 
        hasAccount, 
        user, 
        emailAccount,
        DateTime.now(),
        currentUser.documentId,
        null    // TODO: Pendiente del UID que devuelva la parte de authentication
      );
      
      // TODO: Comprobar que el Id no se repita
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
        'uid': null
      });

      // TODO: Hacer una comprobación - búsquda por el id - mostrar pop-up diciendo si ha ido todo bien
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(
            title: const Text('Cliente guardado'),
            content: const Text('La información del cliente se ha guardado correctamente'),
            actions: <Widget>[
              TextButton(
                child: const Text('De acuerdo.'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(
          title: const Text('Vaya...'), 
          content: const Text('Se ha producido un error'),actions: <Widget>[
            TextButton(
              child: const Text('De acuerdo.'),
              onPressed: () {
                //setState(() {});
                Navigator.of(context).pop();
              },
            )
          ],
        )
      );
    }
  }

  goBack() {
    Navigator.of(context).pop();
  }
}
