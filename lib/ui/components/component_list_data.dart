import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

class HNComponentListData extends StatelessWidget {

  final String title;
  final bool hasDivider;
  final Function()? onTap;

  const HNComponentListData(this.title, this.hasDivider, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Text(title)
          )
        ),
        hasDivider
          ? Container(
              height: 1,
              width: double.infinity,
              color: CustomColors.backgroundTextFieldDisabled,
            )
          : Container()
      ],
    );
  }
}