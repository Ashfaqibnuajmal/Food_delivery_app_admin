import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';

class ExpanceTableHeader extends StatelessWidget {
  const ExpanceTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Date",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
