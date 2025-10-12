import 'package:flutter/material.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_payment_screen/due_payment_header.dart';
import 'package:mera_web/features/due%20payment/presentation/widget/due_payment_screen/due_payment_table_container.dart';
import 'package:mera_web/core/widgets/voice_search.bar.dart';
import 'package:provider/provider.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/core/provider/user_search_provider.dart';

class DuePaymentScreen extends StatelessWidget {
  const DuePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DuePaymentHeader(title: "Due Payment Tracker"),
              const SizedBox(height: 40),
              Consumer<UserSearchProvider>(
                builder: (context, _, __) => const VoiceSearchBar(),
              ),
              const SizedBox(height: 40),
              const DuePaymentTableContainer(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
