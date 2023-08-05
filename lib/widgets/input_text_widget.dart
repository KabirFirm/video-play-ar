import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {

  final TextEditingController textEditingController;
  final IconData? iconData;
  final String? assetReference;
  final String labelString;
  final bool isObscure;
  final bool? isEnable;

  InputTextWidget(
  {
    required this.textEditingController,
    this.iconData,
    this.assetReference,
    required this.labelString,
    required this.isObscure,
    this.isEnable

});
  @override
  Widget build(BuildContext context) {

    // todo: a) add validation, b) error color c) email validation
    return TextField(
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
      ),
      obscureText: isObscure,
    );
  }
}
