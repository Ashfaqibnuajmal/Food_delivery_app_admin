//───────────────────────────────────────
// 🧩 Reusable header + cells
//───────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';

class HeaderCell extends StatelessWidget {
  final String title;
  const HeaderCell({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.pureWhite,
            ),
          ),
        ),
      );
}
