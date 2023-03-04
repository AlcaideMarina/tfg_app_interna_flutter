import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

class ComponentButton extends StatelessWidget {

  final String text;  // Style
  final IconData? leftIcon;  // Style
  final IconData? rightIcon;  // Style
  final TextStyle textStyle;
  final double radius;
  final VoidCallback? onPressed;    // TODO: Lo suyo sería que no fuera nulable
  final VoidCallback? onLongPressed;  // TODO: Lo suyo sería que no fuera nulable
  final bool autofocus;
  final Clip clipBehavior;
  final Color backgroundColor;
  final Color onPrimaryColor;
  final double elevation;
  final double padding;
  final BorderSide borderSide;
  final Duration? animationDuration;

  const ComponentButton(
    this.text,  
    {
      Key? key, 
      this.leftIcon, 
      this.rightIcon, 
      this.textStyle = const TextStyle(),
      this.radius = 0.0,
      this.onPressed, 
      this.onLongPressed, 
      this.autofocus = false, 
      this.clipBehavior = Clip.none, 
      this.backgroundColor = CustomColors.lightGrayColor, 
      this.onPrimaryColor = CustomColors.whiteColor, 
      this.elevation = 0.0, 
      this.padding = 15.0, 
      this.borderSide = const BorderSide(style: BorderStyle.none),
      this.animationDuration
    }
  ) : super(key: key);

  // TODO: añadir una función que calcule los márgenes de los iconos
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftIcon != null ? Icon(leftIcon) : const SizedBox(width: 24,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(text, style: textStyle,)
          ),
          rightIcon != null ? Icon(rightIcon) : const SizedBox(width: 24,)
        ],
      ),
      autofocus: autofocus,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      clipBehavior: clipBehavior,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: onPrimaryColor,
        elevation: elevation,
        padding: EdgeInsets.all(padding),
        side: borderSide,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        animationDuration: animationDuration,
      ),
    );
  }

}