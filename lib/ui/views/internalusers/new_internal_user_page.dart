import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class NewInternalUserPage extends StatefulWidget {
  const NewInternalUserPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  
  @override
  State<NewInternalUserPage> createState() => _NewInternalUserPageState();
}

class _NewInternalUserPageState extends State<NewInternalUserPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  late String id;
  late String name;
  late String surname;
  late String dni;
  late int phone;
  late String email;
  late String direction;
  late String city;
  late String province;
  late int postalCode;
  late bool sameDniDirecion;
  late int ssNumber;
  late String bankAccount;
  late int jobPosition;   // TODO: Esto va a tener que ser un dropdown
  late bool hasAccount;
  late String user;
  late String accountEmail;
  late bool internalApplication;
  // TODO: Lista de persisos de la app interna
  late bool deliveryApplication;
  // TODO: Lista de persisos de la app de repartos
  
  int contCompany = 0;
  int contUser = 0;
  
  List<String> items = [];
  
  @override
  Widget build(BuildContext context) {

    if (items.isEmpty) {
      for (String key in Constants().roles.keys) {
        items.add(key);
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Nuevo usuario interno',
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
                      Text("El usuario debe tener más de 6 dígitos."),
                      Text('La contraseña será igual que el usuario. Por favor, cámbiela en cuanto sea posible. Para hacer login, se necesitará el correo y la contraseña.'),
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
        getCompanyComponentSimpleForm('Nombre', null, TextInputType.text,
            (value) {
          name = value;
        }),
        getCompanyComponentSimpleForm('Apellidos', null, TextInputType.text,
            (value) {
          surname = value;
        }),
        getCompanyComponentSimpleForm('DNI', null, TextInputType.text,
            (value) {
          dni = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm('Teléfono', null, TextInputType.number,
            (value) {
          phone = int.parse(value);
        }),
        getCompanyComponentSimpleForm(
            'Correo', null, TextInputType.emailAddress, (value) {
          email = value;
        }),
        getCompanyComponentSimpleForm('Dirección', null, TextInputType.text, (value) {
          direction = value;
        }),
        getCompanyComponentSimpleForm(
            'Ciudad', null, TextInputType.emailAddress, (value) {
          city = value;
        }),
        getCompanyComponentSimpleForm('Provincia', null, TextInputType.text,
            (value) {
          province = value;
        }),
        getCompanyComponentSimpleForm('Código postal', null, TextInputType.number,
            (value) {
          postalCode = int.parse(value);
        }),
        getCompanyComponentSimpleForm('Cuenta bancaria', null, TextInputType.text,
            (value) {
          bankAccount = value;
        }),
        // TODO: Este va a ser un dropdown
        getDropdownComponentSimpleForm('Puesto', null, TextInputType.text,
            (value) => {
          jobPosition = value!
        }),
        getCompanyComponentSimpleForm('Usuario', null, TextInputType.text,
            (value) {
          user = value;
        }, textCapitalization: TextCapitalization.none),
      ],
    );
  }

  Widget getButtonsComponent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          HNButton(ButtonTypes.blackWhiteBoldRoundedButton)
              .getTypedButton('Guardar', null, null, () {}, () {}),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton('Cancelar', null, null, () {}, () {}),
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
    } else if (contCompany == 12) {
      bottomMargin = 32;
    }
    contCompany++;

    return HNComponentSimpleForm(
        label + ':',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        componentTextInput: HNComponentTextInput(
          textCapitalization: textCapitalization,
          labelText: labelInputText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textInputType: textInputType,
          onChange: onChange,
        ),);
  }

  Widget getDropdownComponentSimpleForm(String label, String? labelInputText, 
      TextInputType textInputType, Function(dynamic)? onChange, 
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
        double topMargin = 4;
        double bottomMargin = 4;
        if (contCompany == 0) {
          topMargin = 8;
        } else if (contCompany == 12) {
          bottomMargin = 32;
        }
        contCompany++;
        
        return HNComponentSimpleForm(
        '$label:',
        8,
        40,
        const EdgeInsets.symmetric(horizontal: 16),
        EdgeInsets.only(top: topMargin, bottom: bottomMargin,),
        componentDropdown: 
          HNComponentDropdown(
            items,
            labelText: labelInputText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textInputType: textInputType,
            onChange: onChange,
          ),
        );
  }
}