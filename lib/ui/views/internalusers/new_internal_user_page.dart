import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
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

  int id = -1;
  String name = "";
  String surname = "";
  String dni = "";
  int phone = -1;
  String email = "";
  String direction = "";
  String city = "";
  String province = "";
  int postalCode = -1;
  bool sameDniDirecion = false;
  int ssNumber = -1;
  String bankAccount = "";
  String jobPosition = "";
  String user = "";

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
                      Text(
                          'La contraseña será igual que el usuario. Por favor, cámbiela en cuanto sea posible. Para hacer login, se necesitará el correo y la contraseña.'),
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
        getCompanyComponentSimpleForm('DNI', null, TextInputType.text, (value) {
          dni = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm('Teléfono', null, TextInputType.number,
            (value) {
          try {
            phone = int.parse(value);
          } catch (e) {
            phone = -1;
          }
        }),
        getCompanyComponentSimpleForm(
            'Correo', null, TextInputType.emailAddress, (value) {
          email = value;
        }, textCapitalization: TextCapitalization.none),
        getCompanyComponentSimpleForm('Dirección', null, TextInputType.text,
            (value) {
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
        getCompanyComponentSimpleForm(
            'Código postal', null, TextInputType.number, (value) {
          try {
            postalCode = int.parse(value);
          } catch (e) {
            postalCode = -1;
          }
        }),
        getCompanyComponentSimpleForm(
            'Nº Afiliación de la Seguridad Social', null, TextInputType.number,
            (value) {
          try {
            ssNumber = int.parse(value);
          } catch (e) {
            ssNumber = -1;
          }
        }),
        getCompanyComponentSimpleForm(
            'Cuenta bancaria', null, TextInputType.text, (value) {
          bankAccount = value;
        }),
        // TODO: Este va a ser un dropdown
        getDropdownComponentSimpleForm('Puesto', null, TextInputType.text,
            (value) => {jobPosition = value!}),
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
              .getTypedButton('Guardar', null, null, saveUser, () {}),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textInputType: textInputType,
        onChange: onChange,
      ),
    );
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
      EdgeInsets.only(
        top: topMargin,
        bottom: bottomMargin,
      ),
      componentDropdown: HNComponentDropdown(
        items,
        labelText: labelInputText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textInputType: textInputType,
        onChange: onChange,
      ),
    );
  }

  ////// Functions

  saveUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    String? uid;
    bool firestoreConf = false;
    id = await FirebaseUtils.instance.getNextInternalUserId();

    if (bankAccount != "" &&
        city != "" &&
        direction != "" &&
        email != "" &&
        dni != "" &&
        email != "" &&
        name != "" &&
        phone != -1 &&
        postalCode != -1 &&
        jobPosition != "" &&
        postalCode != -1 &&
        province != "" &&
        ssNumber != -1 &&
        surname != "" &&
        user != "") {
      uid = await FirebaseUtils.instance.createAuthAccount(email, user);

      if (uid != null) {
        InternalUserModel internalUser = InternalUserModel(
            bankAccount,
            city,
            currentUser.documentId!,
            false,
            direction,
            dni,
            email,
            id,
            name,
            phone,
            Utils().rolesStringToInt(jobPosition),
            postalCode,
            province,
            null,
            ssNumber,
            surname,
            uid,
            user,
            null);
        firestoreConf =
            await FirebaseUtils.instance.createInternalUser(internalUser);
        if (firestoreConf) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Cliente guardado'),
                    content: const Text(
                        'La información del usuario se ha guardado correctamente'),
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
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        'Ha ocurrido un problema al guardar el usuario en la base de datos. Por favor, revise los datos e inténtelo de nuevo.'),
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
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Formulario incompleto'),
                  content: const Text(
                      'Debe rellenar todos los campos del formulario. Por favor revise los datos e inténtelo de nuevo.'),
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
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Formulario incompleto'),
                content: const Text(
                    'Debe rellenar todos los campos del formulario. Por favor revise los datos e inténtelo de nuevo.'),
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
