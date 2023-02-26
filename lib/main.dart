import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/login_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // TODO: poner el tema claro u oscuro en función de la configuración por defecto del dispositivo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringsTranslation.of(context)?.translate("hueveria_nieto") ?? "Huevería Nieto",
      theme: AppTheme.ligthTheme,
      
      home: LoginPage(),
    );
  }
}
