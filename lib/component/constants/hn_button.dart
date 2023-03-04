import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

import '../component_button.dart';

enum ButtonTypes {

  mainRoundedButton,
  mainBoldRoundedButton,
  secondaryRoundedButton,
  secondaryBoldRoundedButton,
  whiteRedRoundedButton,
  whiteRedBoldRoundedButton,
  whiteBlackRoundedButton,
  whiteBlackBoldRoundedButton,

  mainCricleButton,
  mainBoldCricleButton,
  secondaryCricleButton,
  secondaryBoldCricleButton,
  whiteRedCricleButton,
  whiteRedBoldCricleButton,
  whiteBlackCricleButton,
  whiteBlackBoldCricleButton,

}

class HNButton {

  final ButtonTypes type;

  HNButton(this.type);

  late double radius;
  double circleRadius = 100.0;
  double roundedRadius = 16.0;
  TextStyle textStyle = const TextStyle();
  bool autofocus = false;
  Clip clipBehavior = Clip.none;
  late Color backgroundColor;
  late Color onPrimaryColor;
  double elevation = 0.0;
  double padding = 15.0;
  BorderSide borderSide = const BorderSide(style: BorderStyle.none);
  Duration? animationDuration;

  ComponentButton getTypedButton(String text, IconData? leftIcon,
    IconData? rightIcon,  VoidCallback? onPressed, VoidCallback? onLongPressed, 
    {double? customRadius, TextStyle? customTextStyle, bool? customAutofocus,
    Clip? customClipBehavior, Color? customBackgroundColor,
    Color? customOnPrimaryColor, double? customElevation, double? customPadding,
    BorderSide? customBorderSide, Duration? customAnimationDuration,}) {

    autofocus = customAutofocus ?? autofocus;
    clipBehavior = customClipBehavior ?? clipBehavior;
    elevation = customElevation ?? elevation;
    padding = customPadding ?? padding;
    borderSide = customBorderSide ?? borderSide;
    animationDuration = customAnimationDuration ?? const Duration(seconds: 0);

    switch(type) {
      case ButtonTypes.mainRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redPrimaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.whiteColor;
        break;
      }
      case ButtonTypes.mainBoldRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redPrimaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.whiteColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }
      case ButtonTypes.secondaryRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redGraySecondaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        break;
      }
      case ButtonTypes.secondaryBoldRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redGraySecondaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }
      case ButtonTypes.whiteRedRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.redPrimaryColor;
        break;
      }
      case ButtonTypes.whiteRedBoldRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.redPrimaryColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }
      case ButtonTypes.whiteBlackRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        break;
      }
      case ButtonTypes.whiteBlackBoldRoundedButton: {
        radius = customRadius ?? roundedRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }

      case ButtonTypes.mainCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redPrimaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.whiteColor;
        break;
      }
      case ButtonTypes.mainBoldCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redPrimaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.whiteColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }
      case ButtonTypes.secondaryCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redGraySecondaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        break;
      }
      case ButtonTypes.secondaryBoldCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.redGraySecondaryColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }
      case ButtonTypes.whiteRedCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.redPrimaryColor;
        break;
      }
      case ButtonTypes.whiteRedBoldCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.redPrimaryColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }
      case ButtonTypes.whiteBlackCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        break;
      }
      case ButtonTypes.whiteBlackBoldCricleButton: {
        radius = customRadius ?? circleRadius;
        backgroundColor = customBackgroundColor ?? CustomColors.whiteColor;
        onPrimaryColor = customOnPrimaryColor ?? CustomColors.blackColor;
        textStyle = customTextStyle ?? textStyle;
        break;
      }
    }

    return ComponentButton(
      text, 
      leftIcon: leftIcon, 
      rightIcon: rightIcon, 
      radius: radius, 
      onPressed: onPressed, 
      onLongPressed: onLongPressed, 
      autofocus: autofocus, 
      clipBehavior: clipBehavior, 
      backgroundColor: backgroundColor, 
      onPrimaryColor: onPrimaryColor, 
      elevation: elevation, 
      padding: padding, 
      borderSide: borderSide
    );
  }
    
}