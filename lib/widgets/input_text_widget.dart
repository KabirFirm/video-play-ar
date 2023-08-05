import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class InputTextWidget extends StatelessWidget {

  final TextEditingController textEditingController;
  final IconData? iconData;
  final String? assetReference;
  final String labelString;
  final bool isObscure;
  final bool? isEnable;
  final bool? isEmail;

  InputTextWidget(
  {
    required this.textEditingController,
    this.iconData,
    this.assetReference,
    required this.labelString,
    required this.isObscure,
    this.isEnable,
    this.isEmail

});
  @override
  Widget build(BuildContext context) {

    // todo: a) add validation, b) error color c) email validation
    return TextFormField(
      controller: textEditingController,
      enabled: isEnable ?? true,
      decoration: InputDecoration(
        filled: true,
        fillColor: isEnable == false ? Colors.black12 : Colors.transparent,
        labelText: labelString,
        prefixIcon: IconData != null
            ? Icon(iconData)
            : null,
        labelStyle: const TextStyle(
          fontSize: 18
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Colors.black26
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
                color: Colors.blue
            ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
              color: Colors.grey
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
              color: Colors.red
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
              color: Colors.red
          ),
        ),
      ),
      obscureText: isObscure,
      validator: (value) {
        if (value!.isEmpty) {
          return '';
        } else {
          if (!GetUtils.isEmail(value) && isEmail == true) {
            return '';
          } else {

            return null;
          }
        }
      },
    );
  }
}
