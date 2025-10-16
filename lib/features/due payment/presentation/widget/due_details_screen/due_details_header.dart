import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_details_screen/entry_add.dart';

class DueDetailsHeader extends StatelessWidget {
  final String userId;
  final String userName;

  const DueDetailsHeader({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                size: 20,
                color: AppColors.pureWhite,
              ),
            ),
            Text(
              "${userName[0].toUpperCase()}${userName.substring(1)}'s Due Details",
              style: CustomTextStyles.loginHeading,
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mediumBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onPressed: () {
            customAddEntryDialog(context: context, userId: userId);
          },
          child: const Text("Add Entry", style: CustomTextStyles.buttonText),
        ),
      ],
    );
  }
}
