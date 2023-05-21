import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

/// Container whose title is on its top border.

class HNComponentContainerBorderText extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final Container container;
  final Color backgroundColor;
  final double leftPosition;
  final double rightPosition;
  final double topPosition;

  const HNComponentContainerBorderText(this.title, this.container,
      {Key? key,
      this.backgroundColor = CustomColors.whiteColor,
      this.titleStyle = const TextStyle(fontSize: 14),
      this.leftPosition = 50,
      this.rightPosition = 0,
      this.topPosition = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        container,
        Positioned(
          left: leftPosition,
          right: rightPosition,
          top: topPosition,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: backgroundColor,
            child: Text(
              title,
              style: titleStyle,
            )
            
            /*CheckboxListTile(
              contentPadding: contentPadding,
              visualDensity: visualDensity,
              dense: isDense,
              title: Text(
                title,
                style: titleStyle,
              ),
              value: value,
              onChanged: (value) => onChange(value ?? false),
              controlAffinity: controlAffinity,
            ),*/
          ),
        ),
      ],
    );
  }
}
