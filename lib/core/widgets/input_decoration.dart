import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: AppColors.darkBlue, // theme background for inputs
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
