import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mera_web/core/provider/user_search_provider.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/core/widgets/confiorm_dilog.dart';
import 'package:mera_web/core/widgets/voice_search.bar.dart';
import 'package:mera_web/features/foods/model/food_item_model.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_add_dilog.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_edit_dilog.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_items_header.dart';
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
              // 🔹 Voice & Text Search Bar
              Consumer<UserSearchProvider>(
                builder: (context, searchProvider, _) {
                  return VoiceSearchBar();
                },
              ),
              const SizedBox(height: 40),

              // 🔹 Table Header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: const BoxDecoration(
                  color: AppColors.deepBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const Row(
                  children: [
                    _HeaderCell("Image", flex: 2),
                    _HeaderCell("Name\n&\nPrepTime\n&\nCalories", flex: 3),
                    _HeaderCell("Price", flex: 2),
                    _HeaderCell("Category", flex: 2),
                    _HeaderCell("Food Type", flex: 2),
                    _HeaderCell("Today Offer", flex: 2),
                    _HeaderCell("Half Portion\n&\nPrice", flex: 3),
                    _HeaderCell("Best Seller", flex: 2),
                    _HeaderCell("Edit", flex: 2),
                    _HeaderCell("Delete", flex: 2),
                  ],
                ),
              ),

              // 🔹 Food List with Filter
              Expanded(
                child: StreamBuilder<List<FoodItemModel>>(
                  stream: foodServices.fetchFoodItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.lightBlue,
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No food items found",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return Consumer<UserSearchProvider>(
                      builder: (context, searchProvider, _) {
                        final query = searchProvider.query.toLowerCase();

                        // Filtered list based on voice/text
                        final filteredItems = snapshot.data!
                            .where((food) =>
                                food.name.toLowerCase().contains(query))
                            .toList();

                        if (filteredItems.isEmpty) {
                          return const Center(
                            child: Text(
                              "No food items found",
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final food = filteredItems[index];
                            return _FoodRow(food: food);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//────────────────────────────────────────────────────────────
// 🔹 Helper row widget
//────────────────────────────────────────────────────────────
class _FoodRow extends StatelessWidget {
  final FoodItemModel food;
  const _FoodRow({required this.food});

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
              child: Text(
                "₹ ${food.price.toStringAsFixed(2)}",
                style: const TextStyle(
                    color: AppColors.pureWhite, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.category,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isCompo ? "Compo" : "Individual",
                style: const TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isTodayOffer ? "Offer" : "No Offer",
                style: TextStyle(
                  color: food.isTodayOffer ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                food.isHalfAvailable
                    ? "Available\n₹ ${food.halfPrice?.toStringAsFixed(2) ?? '-'}"
                    : "Not Available",
                style: const TextStyle(
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                food.isBestSeller ? "★ Yes" : "No",
                style: TextStyle(
                  color:
                      food.isBestSeller ? Colors.amberAccent : Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
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

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Food item updated successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
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

//────────────────────────────────────────────────────────────
// 🔹 Helper header cell widget
//────────────────────────────────────────────────────────────
class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _HeaderCell(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
