import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';

class UserBalanceHeader extends StatelessWidget {
  final String userName;
  final double balance;

  const UserBalanceHeader({
    super.key,
    required this.userName,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${userName[0].toUpperCase()}${userName.substring(1)}",
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: AppColors.pureWhite),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          "Total Balance Due: ₹${balance.toStringAsFixed(2)}",
          style: TextStyle(
            color: balance > 0 ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
