import 'package:flutter/material.dart';
import 'package:hueveria_nieto_interna/custom/custom_colors.dart';

/// Custom TextInput component

class HNComponentTextInputMultiline extends StatelessWidget {
  final bool autofocus;
  final String? initialValue;
  final TextCapitalization textCapitalization;
  final TextInputType? textInputType;
  final int? maxLines;
  final int? minLines;
  final TextAlignVertical? textAlignVertical;
  final bool obscureText;
  final Function(String)? onChange;
  final Future Function()? onTap;
  // validator
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? suffixIcon;
  final IconData? icon;
  final bool? isDense;
  final bool? isEnabled;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? textEditingController;
  final Color? backgroundColor;
  final Color? textColor;
  final bool? alignLabelWithHint;

  const HNComponentTextInputMultiline(
      {Key? key,
      this.autofocus = false,
      this.initialValue,
      this.textCapitalization = TextCapitalization.sentences,
      this.obscureText = false,
      this.textInputType,
      this.maxLines = null,
      this.minLines = 1,
      this.textAlignVertical,
      this.onChange,
      this.onTap,
      // this.validator,
      this.autovalidateMode,
      this.hintText,
      this.labelText,
      this.helperText,
      this.suffixIcon,
      this.icon,
      this.isDense,
      this.isEnabled,
      this.contentPadding, 
      this.textEditingController,
      this.backgroundColor,
      this.textColor,
      this.alignLabelWithHint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      initialValue: initialValue,
      textCapitalization: textCapitalization,
      keyboardType: textInputType,
      maxLines: maxLines,
      minLines: minLines,
      textAlignVertical: textAlignVertical,
      obscureText: obscureText,
      controller: textEditingController,
      onChanged: (value) => onChange != null ? onChange!(value) : null,
      onTap: () => onTap != null ? onTap!() : null,
      validator: (value) {
        if (value == null) {
          return "Este campo es obligatorio";
        } else {
          return value.length < 3 ? 'Mínimo de 3 letras' : null;
        }
      },
      autovalidateMode: autovalidateMode,
      enabled: isEnabled,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        filled: backgroundColor != null,
        fillColor: backgroundColor,
        isDense: isDense,
        contentPadding: contentPadding,
        alignLabelWithHint: alignLabelWithHint,
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
