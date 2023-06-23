import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

/// Container whose title is on its top border.

class HNComponentContainerBorderCheckTitle extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final Container container;
  final Color backgroundColor;
  final EdgeInsets contentPadding;
  final VisualDensity visualDensity;
  final bool isDense;
  final bool value;
  final ListTileControlAffinity controlAffinity;
  final double leftPosition;
  final double rightPosition;
  final double topPosition;
  final Function(bool) onChange;

  const HNComponentContainerBorderCheckTitle(
      this.title, this.container, this.onChange,
      {Key? key,
      this.contentPadding = EdgeInsets.zero,
      this.visualDensity = VisualDensity.compact,
      this.isDense = true,
      this.value = false,
      this.backgroundColor = CustomColors.whiteColor,
      this.titleStyle = const TextStyle(fontSize: 14),
      this.controlAffinity = ListTileControlAffinity.leading,
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
            color: backgroundColor,
            child: CheckboxListTile(
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
            ),
          ),
        ),
      ],
    );
  }
}
