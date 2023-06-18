import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/ui/components/component_text_input.dart';
import 'package:hueveria_nieto_interna/ui/components/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/values/firebase_auth_constants.dart';
import 'package:hueveria_nieto_interna/values/image_routes.dart';
import '../../../data/models/internal_user_model.dart';
import '../main/main_page.dart';

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

  navigateToMainPage(InternalUserModel currentUser) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(currentUser),
        ));
  }

  Future<InternalUserModel?>? getUserInfo() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user_info')
        .where('uid', isEqualTo: uid)
        .get();

    String id = querySnapshot.docs[0].id;
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('user_info').doc(id).get();

    if (document.exists) {
      final Map<String, dynamic>? userInfo =
          document.data() as Map<String, dynamic>?;
      if (userInfo != null) {
        return InternalUserModel(
          userInfo['bank_account'],
          userInfo['city'],
          userInfo['created_by'],
          userInfo['deleted'],
          userInfo['direction'],
          userInfo['dni'],
          userInfo['email'],
          userInfo['id'],
          userInfo['name'],
          userInfo['phone'],
          userInfo['position'],
          userInfo['postal_code'],
          userInfo['province'],
          userInfo['salary'],
          userInfo['ss_number'],
          userInfo['surname'],
          uid!,
          userInfo['user'],
          document.id,
        );
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future signIn() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      showAlertDialog(context);

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.trim(), password: password);

      InternalUserModel? currentUser = await getUserInfo();

      if (currentUser != null && !currentUser.deleted) {
        Navigator.of(context).pop();
        navigateToMainPage(currentUser);
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'Parece que ha habido un problema. Inténtalo de nuevo más tarde.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('De acuerdo.'),
                      onPressed: () {
                        setState(() {});
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

      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: Text(errorMessage),
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
