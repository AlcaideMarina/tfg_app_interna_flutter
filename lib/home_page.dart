import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/app_theme.dart';
import 'package:hueveria_nieto_interna/custom/custom_sizes.dart';
import 'package:hueveria_nieto_interna/values/strings_translation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (StringsTranslation.of(context) == null) {
      print("NULO");
    } else {
      print("NO NULO");
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.menu_rounded, color: AppTheme.primary,),
        toolbarHeight: 56.0,
        title: Text(
          StringsTranslation.of(context)
            ?.translate('hueveria_nieto') ?? "", 
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: CustomSizes.textSize24
          ),
        )

      ),
    );
  }

}