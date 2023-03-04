import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/values/image_routes.dart';

class LateralMenuHeader extends StatelessWidget {
  const LateralMenuHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Container(),
      decoration: BoxDecoration(
        image: DecorationImage(
          // TODO: Cambiar foto encabezado
          image: AssetImage(ImageRoutes.getRoute("ic_logo")),
          fit: BoxFit.cover
        )
      ),
    );
  }
}