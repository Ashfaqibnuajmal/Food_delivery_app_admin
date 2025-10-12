import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';

class ExpanceHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAddPressed;

  const ExpanceHeader({
    super.key,
    required this.title,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Text(title, style: CustomTextStyles.title),

        // Add Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mediumBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onPressed: onAddPressed,
          child: const Text(
            "Add Expanse",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
