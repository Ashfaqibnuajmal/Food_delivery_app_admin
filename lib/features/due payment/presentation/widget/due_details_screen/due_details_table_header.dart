import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';

class DuePaymentTableHeader extends StatelessWidget {
  const DuePaymentTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.mediumBlue.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Date",
                style: CustomTextStyles.header,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Status",
                style: CustomTextStyles.header,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Amount",
                style: CustomTextStyles.header,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Notes",
                style: CustomTextStyles.header,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Edit",
                style: CustomTextStyles.header,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Delete",
                style: CustomTextStyles.header,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
