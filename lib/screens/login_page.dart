import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_text_input.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/values/firebase_auth_constants.dart';
import 'package:hueveria_nieto_interna/values/image_routes.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isButtonEnabled = false;
String user = '';
String password = '';

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              width: double.infinity,
              child: Form(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 96,
                    ),
                    Image.asset(ImageRoutes.getRoute('ic_logo'),
                        width: 218, height: 287),
                    const SizedBox(
                      height: 48,
                    ),
                    // TODO: Esto será el usuario, no el correo
                    HNComponentTextInput(
                      labelText: 'Correo',
                      textInputType: TextInputType.emailAddress,
                      onChange: (text) {
                        user = text;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    HNComponentTextInput(
                      labelText: 'Contraseña',
                      obscureText: true,
                      onChange: (text) {
                        password = text;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const SizedBox(height: 56)
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          child: HNButton(ButtonTypes.redWhiteBoldRoundedButton).getTypedButton(
              "ACCEDER",
              null,
              null,
              getIsButtonEnabled() ? signIn : null,
              null),
          margin: const EdgeInsets.all(24),
        ));
  }

  bool getIsButtonEnabled() {
    if (user != '' && password != '') {
      return true;
    } else {
      return false;
    }
  }

  navigateToMainPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
  }

  Future signIn() async {
    // TODO: añadir un Circular Progress Indicator
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.trim(), password: password);
      // TODO: sacar el uid y pasárselo a la MainPage() - Cambiar también el constructor de la página
      navigateToMainPage();
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          FirebaseAuthConstants.genericError + ' Código de error: ' + e.code;
      if (FirebaseAuthConstants.loginErrors.containsKey(e.code)) {
        errorMessage = FirebaseAuthConstants.loginErrors[e.code] ?? "";
      }

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Vaya...'),
                content: Text(errorMessage),
                actions: <Widget>[
                  TextButton(
                    child: const Text('De acuerdo.'),
                    onPressed: () {
                      setState(() {
                        // TODO: borrar contraseña
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }
}
