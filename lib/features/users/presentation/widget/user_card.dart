import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';

class UserCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconBg;
  final Color cardColor;

  const UserCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconBg,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 120,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(5)),
              child: Icon(icon, color: AppColors.pureWhite, size: 18),
            )
          ]),
          const Spacer(),
          Text(
            count,
            style: const TextStyle(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
