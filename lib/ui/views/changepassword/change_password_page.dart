import 'package:flutter/material.dart';

import '../../../custom/app_theme.dart';
import '../../../custom/custom_sizes.dart';
import '../../../data/models/internal_user_model.dart';
import '../../components/component_simple_form.dart';
import '../../components/component_text_input.dart';
import '../../components/constants/hn_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;
  
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late InternalUserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  String oldPass = "";
  String newPass1 = "";
  String newPass2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 56.0,
            title: const Text(
              'Gallinas - Añadir',
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
                      getComponentSimpleForm('Contraseña actual', null, TextInputType.text,
                          (value) {
                        oldPass = value;
                      }),
                      getComponentSimpleForm('Nueva contraseña', null, TextInputType.text,
                          (value) {
                        newPass1 = value;
                      }),
                      getComponentSimpleForm('Repita la nueva contraseña', null, TextInputType.text,
                          (value) {
                        newPass2 = value;
                      }),
                      const SizedBox(
                        height: 16,
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

  Widget getComponentSimpleForm(String label, String? labelInputText,
      TextInputType textInputType, Function(String)? onChange,
      {TextCapitalization textCapitalization = TextCapitalization.sentences}) {
    double topMargin = 4;
    double bottomMargin = 4;

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

}
