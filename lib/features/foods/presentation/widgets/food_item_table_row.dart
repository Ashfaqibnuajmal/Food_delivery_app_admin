import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/core/widgets/confiorm_dilog.dart';
import 'package:mera_web/features/foods/model/food_item_model.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_edit_dilog.dart';
import 'package:mera_web/features/foods/services/food_item_services.dart';
import 'package:provider/provider.dart';

// ignore: unused_element
class FoodItemTableRow extends StatelessWidget {
  final FoodItemModel food;
  const FoodItemTableRow({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.08),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.pureWhite,
                  image: DecorationImage(
                    image: NetworkImage(food.imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "${food.name}\n${food.prepTimeMinutes} min | ${food.calories} kcal\n${food.description}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text("₹ ${food.price.toStringAsFixed(2)}",
                  style: CustomTextStyles.buttonText),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.category,
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isCompo ? "Compo" : "Individual",
                style: CustomTextStyles.text,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(food.isTodayOffer ? "Offer" : "No Offer",
                  style: CustomTextStyles.userStatus(food.isTodayOffer)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                  food.isHalfAvailable
                      ? "Available\n₹ ${food.halfPrice?.toStringAsFixed(2) ?? '-'}"
                      : "Not Available",
                  style: CustomTextStyles.buttonText),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isBestSeller ? "★ Yes" : "No",
                style: CustomTextStyles.bestSeller(food.isBestSeller),
              ),
            ),
          ),

          // ✏️ Edit Button
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  foregroundColor: AppColors.pureWhite,
                  minimumSize: const Size(60, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  await customEditFoodItemDialog(
                    context: context,
                    food: food,
                    onUpdate: ({
                      required Uint8List? imageBytes,
                      required String? imageUrl,
                      required String name,
                      required int prepTimeMinutes,
                      required double calories,
                      required String description,
                      required double price,
                      required String category,
                      required bool isCompo,
                      required bool isTodayOffer,
                      required bool isHalfAvailable,
                      required double? halfPrice,
                      required bool isBestSeller,
                    }) async {
                      final foodServices = context.read<FoodItemServices>();
                      try {
                        await foodServices.editFoodItem(
                          food.copyWith(
                            name: name,
                            prepTimeMinutes: prepTimeMinutes,
                            calories: calories,
                            description: description,
                            price: price,
                            category: category,
                            isCompo: isCompo,
                            isTodayOffer: isTodayOffer,
                            isHalfAvailable: isHalfAvailable,
                            halfPrice: halfPrice,
                            isBestSeller: isBestSeller,
                          ),
                          newImageBytes: imageBytes,
                          oldImageUrl: food.imageUrl,
                        );

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Food item updated successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error updating food item: $e"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                  );
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),

          // 🗑 Delete Button
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(60, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  customDeleteDialog(context, () async {
                    await context.read<FoodItemServices>().deleteFoodItem(food);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
