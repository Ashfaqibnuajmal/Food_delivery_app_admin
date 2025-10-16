import 'package:flutter/material.dart';
import 'package:mera_web/core/provider/user_search_provider.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/core/widgets/voice_search.bar.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_table.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_items_header.dart';
import 'package:mera_web/features/foods/presentation/widgets/foot_item_table_header.dart';
import 'package:mera_web/features/foods/services/food_item_services.dart';
import 'package:provider/provider.dart';

class FooditemScreen extends StatelessWidget {
  const FooditemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodServices = context.read<FoodItemServices>();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FoodItemsHeader(foodServices: foodServices),
              const SizedBox(height: 40),
              Consumer<UserSearchProvider>(
                builder: (context, searchProvider, _) {
                  return const VoiceSearchBar();
                },
              ),
              const SizedBox(height: 40),
              const FoodTableHeader(),
              const FoodItemTable(),
            ],
          ),
        ),
      ),
    );
  }
}
