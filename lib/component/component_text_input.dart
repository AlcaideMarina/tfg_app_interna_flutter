import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

class ComponentTextInput extends StatelessWidget {

  final bool autofocus;
  final String? initialValue;
  final TextCapitalization textCapitalization;
  final TextInputType? textInputType;
  final bool obscureText;
  // onchange
  // validator
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? suffixIcon;
  final IconData? icon;

  const ComponentTextInput({
    Key? key, 
    this.autofocus = false,
    this.initialValue, 
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.textInputType,
    // this.onChange,
    // this.validator,
    this.autovalidateMode,
    this.hintText, 
    this.labelText, 
    this.helperText, 
    this.suffixIcon, 
    this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      initialValue: initialValue,
      textCapitalization: textCapitalization,
      keyboardType: textInputType,
      obscureText: obscureText,
      onChanged: (value) {
        print('Value: $value');
      },
      validator: (value) {
        if (value == null) {
          return "Este campo es obligatorio";
        } else {
          return value.length < 3 ? 'Mínimo de 3 letras' : null;
        }
      },
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
        icon: icon == null ? null : Icon(icon),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: CustomColors.redPrimaryColor)
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: CustomColors.redGraySecondaryColor)
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: CustomColors.redPrimaryColor)
        ),
      ),
    );
  }
}