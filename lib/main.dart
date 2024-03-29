import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/ui/views/login/login_page.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'services/id_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => IDService())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringsTranslation.of(context)?.translate("hueveria_nieto") ??
          "Huevería Nieto",
      theme: AppTheme.ligthTheme,
      home: const LoginPage(),
    );
  }
}
