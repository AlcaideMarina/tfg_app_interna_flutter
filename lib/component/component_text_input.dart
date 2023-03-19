import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

/// Custom TextInput component

class HNComponentTextInput extends StatelessWidget {
  final bool autofocus;
  final String? initialValue;
  final TextCapitalization textCapitalization;
  final TextInputType? textInputType;
  final bool obscureText;
  final Function(String)? onChange;
  // validator
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? suffixIcon;
  final IconData? icon;
  final bool? isDense;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? textEditingController;

  const HNComponentTextInput(
      {Key? key,
      this.autofocus = false,
      this.initialValue,
      this.textCapitalization = TextCapitalization.none,
      this.obscureText = false,
      this.textInputType,
      this.onChange,
      // this.validator,
      this.autovalidateMode,
      this.hintText,
      this.labelText,
      this.helperText,
      this.suffixIcon,
      this.icon,
      this.isDense,
      this.contentPadding, 
      this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      initialValue: initialValue,
      textCapitalization: textCapitalization,
      keyboardType: textInputType,
      obscureText: obscureText,
      controller: textEditingController,
      onChanged: (value) => onChange != null ? onChange!(value) : null,
      validator: (value) {
        if (value == null) {
          return "Este campo es obligatorio";
        } else {
          return value.length < 3 ? 'Mínimo de 3 letras' : null;
        }
      },
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        isDense: isDense,
        contentPadding: contentPadding,
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
        icon: icon == null ? null : Icon(icon),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: CustomColors.redPrimaryColor)),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: CustomColors.redGraySecondaryColor)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: CustomColors.redPrimaryColor)),
      ),
    );
  }
}
