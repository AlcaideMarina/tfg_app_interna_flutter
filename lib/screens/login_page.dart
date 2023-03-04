import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/component/component_text_input.dart';
import 'package:hueveria_nieto_interna/component/constants/hn_button.dart';
import 'package:hueveria_nieto_interna/values/image_routes.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

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
            child: Column(
              children: <Widget> [
                const SizedBox(
                  height: 96,
                ),
                Image.asset(ImageRoutes.getRoute("ic_logo"), width: 218, height: 287),
                const SizedBox(
                  height: 48,
                ),
                const HNComponentTextInput(labelText: "Usuario"),
                const SizedBox(
                  height: 24,
                ),
                const HNComponentTextInput(labelText: "Contraseña"),
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(height: 56)
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        child: HNButton(ButtonTypes.mainBoldRoundedButton).getTypedButton("ACCEDER", null, null, navigateToMainPage, () { }),
        margin: const EdgeInsets.all(24),
      ) 
      /*ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 24,),
            Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text("hola")
          ),
          ],
        ),
        autofocus: false,
        onPressed: (){},   // TODO: y si va a nulo?
        onLongPress: (){},   // TODO: y si va a nulo?
        clipBehavior: Clip.none,
        style: ElevatedButton.styleFrom(
          primary: CustomColors.redGraySecondaryColor,
          onPrimary: CustomColors.darkGrayColor,
          elevation: 0,
          padding: EdgeInsets.all(15),
        // side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        // animationDuration: animationDuration,
        ),
      )*/
    );
  }

  navigateToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
  }
}