import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/ui/views/internalusers/modify_internal_user_page.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_colors.dart';
import '../../../custom/custom_sizes.dart';
import '../../../flutterfire/firebase_utils.dart';
import '../../../utils/Utils.dart';
import '../../components/component_dropdown.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class InternalUserDetailPage extends StatefulWidget {
  const InternalUserDetailPage(this.currentUser, this.internalUserModel, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  final InternalUserModel internalUserModel;
  
  @override
  State<InternalUserDetailPage> createState() => _InternalUserDetailPageState();
}

class _InternalUserDetailPageState extends State<InternalUserDetailPage> {
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
  late String jobPosition = "";   // TODO: Esto va a tener que ser un dropdown
  late String user = "";
  late bool internalApplication = false;
  // TODO: Lista de persisos de la app interna
  late bool deliveryApplication;
  // TODO: Lista de persisos de la app de repartos

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
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
        getCompanyComponentSimpleForm('Nombre', internalUserModel.name, TextInputType.text,
            (value) {
          name = value;
        }),
        getCompanyComponentSimpleForm('Apellidos', internalUserModel.surname, TextInputType.text,
            (value) {
          surname = value;
        }),
        getCompanyComponentSimpleForm('DNI', internalUserModel.dni, TextInputType.text,
            (value) {
          dni = value;
        }, textCapitalization: TextCapitalization.characters),
        getCompanyComponentSimpleForm('Teléfono', internalUserModel.phone.toString(), TextInputType.number,
            (value) {
          try {
            phone = int.parse(value);
          } catch (e) {
            phone = -1;
          }
        }),
        getCompanyComponentSimpleForm(
            'Correo', internalUserModel.email, TextInputType.emailAddress, (value) {
          email = value;
        }, textCapitalization: TextCapitalization.none),
        getCompanyComponentSimpleForm('Dirección', internalUserModel.direction, TextInputType.text, (value) {
          direction = value;
        }),
        getCompanyComponentSimpleForm(
            'Ciudad', internalUserModel.city, TextInputType.emailAddress, (value) {
          city = value;
        }),
        getCompanyComponentSimpleForm('Provincia', internalUserModel.province, TextInputType.text,
            (value) {
          province = value;
        }),
        getCompanyComponentSimpleForm('Código postal', internalUserModel.postalCode.toString(), TextInputType.number,
            (value) {
          try {
            postalCode = int.parse(value);
          } catch (e) {
            postalCode = -1;
          }
        }),
        getCompanyComponentSimpleForm('Nº Afiliación de la Seguridad Social', internalUserModel.ssNumber.toString(), TextInputType.number,
            (value) {
          try {
            ssNumber = int.parse(value);
          } catch (e) {
            ssNumber = -1;
          }
        }),
        getCompanyComponentSimpleForm('Cuenta bancaria', internalUserModel.bankAccount, TextInputType.text,
            (value) {
          bankAccount = value;
        }),
        // TODO: Este va a ser un dropdown
        getDropdownComponentSimpleForm('Puesto', Utils().getKey(Constants().roles, internalUserModel.position), TextInputType.text,
            (value) => {
          jobPosition = value!
        }),
        getCompanyComponentSimpleForm('Usuario', internalUserModel.user, TextInputType.text,
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
              .getTypedButton(
                'Modificar', 
                null, 
                null, 
                navigateToModifyInternalUser, 
                null),
          const SizedBox(
            height: 8,
          ),
          HNButton(ButtonTypes.redWhiteBoldRoundedButton)
              .getTypedButton(
                'Eliminar usuario', 
                null, 
                null, 
                getIsButtonEnabled() ? deleteWarningUser : null, 
                null, 
              ),
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
          isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
          textColor: CustomColors.darkGrayColor,
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
            [],
            labelText: labelInputText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textInputType: textInputType,
            onChange: onChange,
            isEnabled: false,
          backgroundColor: CustomColors.backgroundTextFieldDisabled,
          textColor: CustomColors.darkGrayColor,
          ),
        );
  }

  bool getIsButtonEnabled() {
    if (internalUserModel.documentId == currentUser.documentId ) {
      return false;
    } else {
      return true;
    }
  }

  deleteWarningUser() {
    showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Aviso importante'),
                content: const Text('Esta acción es irreversible. ¿Está seguro de que quiere eliminar el usuario?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Continuar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteUser();
                    },
                  )
                ],
              ));
  }

  deleteUser() async {
      FocusManager.instance.primaryFocus?.unfocus();
      showAlertDialog(context);
      bool conf = await FirebaseUtils.instance.deleteDocument("user_info", internalUserModel.documentId!);

      Navigator.pop(context);
      if(conf) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Usuario eliminado'),
                content: const Text(
                    'El usuario ha sido eliminado correctamente.'),
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
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Parece que ha habido un error. Por favor, inténtelo de nuevo.'),
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

  navigateToModifyInternalUser() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ModifyInternalUserPage(currentUser, internalUserModel)));

    if (result != null) {
      internalUserModel = result;
      setState(() {});
    }
  }

}