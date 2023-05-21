import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_text_input.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/values/firebase_auth_constants.dart';
import 'package:hueveria_nieto_interna/values/image_routes.dart';
import '../custom/custom_colors.dart';
import '../model/current_user_model.dart';
import 'home_page.dart';
import 'dart:developer' as developer;

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
                    HNComponentTextInput(
                      labelText: 'Correo',
                      textInputType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
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
                      textCapitalization: TextCapitalization.none,
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

  navigateToMainPage(CurrentUserModel currentUser) {
    // TODO: Evitar que al dar al botón de atrás, vuelva aquí - investigar
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(currentUser),
        ));
  }

  // TODO: Esto debería estar en una clase aparte
  Future<CurrentUserModel?>? getUserInfo() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('user_info')
        .where('uid', isEqualTo: uid)
        .get();
    
    String id = querySnapshot.docs[0].id;
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('user_info').doc(id).get();

    if (document.exists) {
      final Map<String, dynamic>? userInfo = document.data() as Map<String, dynamic>?;
      if (userInfo != null) {
        // TODO: hacer un .fromMap
        return CurrentUserModel(
          document.id,
          uid ?? '', 
          userInfo['id'], 
          userInfo['name'], 
          userInfo['surname'], 
          userInfo['dni'], 
          userInfo['phone'], 
          userInfo['email'], 
          userInfo['direction'], 
          userInfo['city'], 
          userInfo['province'], 
          userInfo['postal_code'], 
          userInfo['same_dni_direction'], 
          userInfo['ss_number'], 
          userInfo['bank_account'], 
          userInfo['position'], 
          userInfo['user'],
          // TODO: Faltan los permisos
        );
      } else {
        return null;
      }
    } else {
        return null;
      }
  }

  Future signIn() async {
    // TODO: añadir un Circular Progress Indicator - que no se pueda quitar
    // TODO: hacer un componente de pop-up
    // TODO: Fix - si hay algún error, no se quita el circular progress indicator
    try {
      showDialog(
        context: context, 
        builder: (_) => const Center(
          child: CircularProgressIndicator()));
      developer.log('Empieza la función signInWithEmailAndPassword()', name: 'Login');
      // TODO: Esto va muy lento - investigar
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.trim(), password: password);
      developer.log('Función signInWithEmailAndPassword() terminada', name: 'Login');
      developer.log('Empieza la función getUserInfo()', name: 'Login');
      CurrentUserModel? currentUser = await getUserInfo();
      developer.log('Función getUserInfo() terminada', name: 'Login');
      if (currentUser != null) {
        navigateToMainPage(currentUser);
      } else {
        showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text('Vaya...'),
          content: const Text('Parece que ha habido un problema. Inténtalo de nuevo más tarde.'),
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
