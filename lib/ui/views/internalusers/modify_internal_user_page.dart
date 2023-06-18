import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ModifyInternalUserPage extends StatefulWidget {
  const ModifyInternalUserPage(this.currentUserData, this.internalUserModel,
      {Key? key})
      : super(key: key);

  final InternalUserModel currentUserData;
  final InternalUserModel internalUserModel;

  @override
  State<ModifyInternalUserPage> createState() => _ModifyInternalUserPageState();
}

class _ModifyInternalUserPageState extends State<ModifyInternalUserPage> {
  late InternalUserModel currentUser;
  late InternalUserModel internalUserModel;

  late int id = -1;
  late String name = "";
  late String surname = "";
  late String dni = "";
  late int phone = -1;
  late String email = "";
  late String direction = "";
  late String city = "";
  late String province = "";
  late int postalCode = -1;
  late bool sameDniDirecion = false;
  late int ssNumber = -1;
  late String bankAccount = "";
  late String jobPosition = "";
  late String user = "";

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUserData;
    internalUserModel = widget.internalUserModel;

    id = internalUserModel.id;
    name = internalUserModel.name;
    surname = internalUserModel.surname;
    dni = internalUserModel.dni;
    phone = internalUserModel.phone;
    email = internalUserModel.email;
    direction = internalUserModel.direction;
    city = internalUserModel.city;
    province = internalUserModel.province;
    postalCode = internalUserModel.postalCode;
    ssNumber = internalUserModel.ssNumber;
    bankAccount = internalUserModel.bankAccount;
    jobPosition = Utils().getKey(Constants().roles, internalUserModel.position);
    user = internalUserModel.user;
  }

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
              'Detalle usuario interno',
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
        getCompanyComponentSimpleForm(
            'Nombre', internalUserModel.name, TextInputType.text, (value) {
          name = value;
        }),
        getCompanyComponentSimpleForm(
            'Apellidos', internalUserModel.surname, TextInputType.text,
            (value) {
          surname = value;
        }),
        getCompanyComponentSimpleForm(
            'DNI', internalUserModel.dni, TextInputType.text, (value) {
          dni = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm('Teléfono',
            internalUserModel.phone.toString(), TextInputType.number, (value) {
          try {
            phone = int.parse(value);
          } catch (e) {
            phone = -1;
          }
        }),
        getCompanyComponentSimpleForm(
            'Correo', internalUserModel.email, TextInputType.emailAddress,
            (value) {
          email = value;
        }, textCapitalization: TextCapitalization.none, isEnabled: false),
        getCompanyComponentSimpleForm(
            'Dirección', internalUserModel.direction, TextInputType.text,
            (value) {
          direction = value;
        }),
        getCompanyComponentSimpleForm(
            'Ciudad', internalUserModel.city, TextInputType.emailAddress,
            (value) {
          city = value;
        }),
        getCompanyComponentSimpleForm(
            'Provincia', internalUserModel.province, TextInputType.text,
            (value) {
          province = value;
        }),
        getCompanyComponentSimpleForm(
            'Código postal',
            internalUserModel.postalCode.toString(),
            TextInputType.number, (value) {
          try {
            postalCode = int.parse(value);
          } catch (e) {
            postalCode = -1;
          }
        }),
        getCompanyComponentSimpleForm(
            'Nº Afiliación de la Seguridad Social',
            internalUserModel.ssNumber.toString(),
            TextInputType.number, (value) {
          try {
            ssNumber = int.parse(value);
          } catch (e) {
            ssNumber = -1;
          }
        }),
        getCompanyComponentSimpleForm('Cuenta bancaria',
            internalUserModel.bankAccount, TextInputType.text, (value) {
          bankAccount = value;
        }),
        getDropdownComponentSimpleForm(
            'Puesto',
            Utils().getKey(Constants().roles, internalUserModel.position),
            TextInputType.text,
            (value) => {jobPosition = value!}),
        getCompanyComponentSimpleForm(
            'Usuario', internalUserModel.user, TextInputType.text, (value) {
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
              .getTypedButton('Guardar', null, null, updateUser, null),
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
        ],
      ),
    );
  }

  Widget getCompanyComponentSimpleForm(String label, String initialValue,
      TextInputType textInputType, Function(String)? onChange,
      {TextCapitalization textCapitalization = TextCapitalization.sentences,
      bool isEnabled = true}) {
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textInputType: textInputType,
        onChange: onChange,
        isEnabled: isEnabled,
        initialValue: initialValue,
        backgroundColor: isEnabled
            ? CustomColors.whiteColor
            : CustomColors.backgroundTextFieldDisabled,
      ),
    );
  }

  Widget getDropdownComponentSimpleForm(String label, String initialValue,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textInputType: textInputType,
        onChange: onChange,
        isEnabled: true,
        initialValue: initialValue,
      ),
    );
  }

  ///// Functions

  updateUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showAlertDialog(context);

    bool firestoreConf = false;

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
      InternalUserModel updatedUser = InternalUserModel(
          bankAccount,
          city,
          currentUser.documentId!,
          internalUserModel.deleted,
          direction,
          dni,
          email,
          id,
          name,
          phone,
          Utils().rolesStringToInt(jobPosition),
          postalCode,
          province,
          internalUserModel.salary,
          ssNumber,
          surname,
          internalUserModel.uid,
          user,
          internalUserModel.documentId);
      firestoreConf = await FirebaseUtils.instance.updateDocument(
          "user_info", updatedUser.documentId!, updatedUser.toMap());
      if (firestoreConf) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Usuario guardado'),
                  content: const Text(
                      'La información del usuario se ha actualizado correctamente'),
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
                      'Ha ocurrido un problema al actualizar los datos del usuario en la base de datos. Por favor, revise los datos e inténtelo de nuevo.'),
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
