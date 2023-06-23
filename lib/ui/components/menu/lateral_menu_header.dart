import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:hueveria_nieto_interna/utils/utils.dart';

class LateralMenuHeader extends StatelessWidget {
  const LateralMenuHeader(this.currentUser, {Key? key}) : super(key: key);

  final InternalUserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentUser.name + " " + currentUser.surname,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              Utils().getKey(Constants().roles, currentUser.position),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.grayColor),
            )
          ],
        ));
  }
}
