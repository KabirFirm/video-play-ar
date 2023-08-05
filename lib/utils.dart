import 'package:flutter/material.dart';

void hideKeyboard() {
  var primaryFocus = FocusManager.instance.primaryFocus;
  if (primaryFocus != null) {
    primaryFocus.unfocus();
  }
}