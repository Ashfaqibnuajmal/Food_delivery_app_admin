import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';

class LoginLogoSection extends StatelessWidget {
  final String logoPath;
  final String title;
  final String subtitle;

  const LoginLogoSection({
    super.key,
    required this.logoPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logoPath,
            height: 150,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: CustomTextStyles.title,
          ),
          Text(
            subtitle,
            style: CustomTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}
