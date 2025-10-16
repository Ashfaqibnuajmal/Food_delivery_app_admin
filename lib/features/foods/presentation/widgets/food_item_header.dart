import 'package:flutter/material.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_add_dilog.dart';
import 'package:provider/provider.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/core/widgets/cutom_snackbar.dart';
import 'package:mera_web/core/provider/pick_image.dart';
import 'package:mera_web/features/foods/services/food_item_services.dart';

class FoodItemHeader extends StatelessWidget {
  final TextEditingController foodNameController;
  const FoodItemHeader({super.key, required this.foodNameController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Food Items",
            style: CustomTextStyles.categoriesTitle,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mediumBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: () => foodItemCustomAddDialog(context),
            child: const Text(
              "Add Food Item",
              style: CustomTextStyles.addCategory,
            ),
          ),
        ],
      ),
    );
  }

  //─────────────────────────────────────────────
  // 🔸 Food Add Dialog Trigger
  //─────────────────────────────────────────────
  void foodItemCustomAddDialog(BuildContext context) {
    customAddFoodDialog(
      context: context,
      nameController: foodNameController,
      onPressed: () async {
        final imageProvider = context.read<ImageProviderModel>();
        final image = imageProvider.pickedImage;
        final name = foodNameController.text.trim();

        // ✅ simple validation
        if (name.isEmpty || image == null) {
          return customSnackbar(
            context,
            "Please enter a name and pick an image.",
            Colors.red,
          );
        }

        try {
          await context.read<FoodItemServices>().addFoodItem(name, image);
          // ✅ success feedback
          customSnackbar(
              context, "Food Item added successfully!", Colors.green);

          if (Navigator.canPop(context)) {
            foodNameController.clear();
            imageProvider.clearImage();
            Navigator.pop(context);
          }
        } catch (e) {
          customSnackbar(
              context, "Error adding Food Item: $e", Colors.redAccent);
        }
      },
    );
  }
}
