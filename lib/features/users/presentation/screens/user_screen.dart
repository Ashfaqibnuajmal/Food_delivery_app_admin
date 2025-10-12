import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/widgets/voice_search.bar.dart';
import 'package:mera_web/features/users/presentation/widget/user_summary_card.dart';
import 'package:mera_web/features/users/presentation/widget/user_table.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/users/services/user_services.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserServices();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('User Management', style: CustomTextStyles.title),
              const SizedBox(height: 25),
              const VoiceSearchBar(),
              const SizedBox(height: 30),
              UserSummaryCards(userService: userService),
              const SizedBox(height: 40),
              UserTable(userService: userService),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
