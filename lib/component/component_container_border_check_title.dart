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
  bool value;
  // TODO: final VoidCallback onChange;
  final ListTileControlAffinity controlAffinity;
  final double leftPosition;
  final double rightPosition;
  final double topPosition;

  HNComponentContainerBorderCheckTitle(this.title, this.container,
      // TODO: this.onChange,
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
              onChanged: (newValue) {},
              controlAffinity: controlAffinity,
            ),
          ),
        ),
      ],
    );
  }
}
