import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_payment_screen/due_payment_add.dart';

class DuePaymentHeader extends StatelessWidget {
  final String title;

  const DuePaymentHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.pureWhite,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mediumBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            customAddDuePaymentDialog(context: context);
          },
          child: const Text(
            "Add Due Payment",
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
