import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_add_dilog.dart';
import 'package:provider/provider.dart';
import 'package:mera_web/core/provider/pick_image.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/core/widgets/confiorm_dilog.dart';
import 'package:mera_web/features/foods/model/food_item_model.dart';
import 'package:mera_web/features/foods/services/food_item_services.dart';

class FoodItemBody extends StatelessWidget {
  final TextEditingController foodNameController = TextEditingController();
  FoodItemBody({super.key});

  final double sidebarWidth = 250;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - sidebarWidth - 26.0,
            ),
            child: StreamBuilder<List<FoodItemModel>>(
              stream: context.read<FoodItemServices>().fetchFoodItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.lightBlue),
                  );
                }
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Center(
                    child: Text("Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red)),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No food items found",
                      style: TextStyle(color: AppColors.pureWhite),
                    ),
                  );
                }

                final foods = snapshot.data!;

                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width > 600
                        ? 600
                        : MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue.withOpacity(0.1),
                      border: Border.all(color: AppColors.mediumBlue, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        //──────────────────────────── Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            color: AppColors.deepBlue,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Image",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Name",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Edit",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Delete",
                                    style: CustomTextStyles.header,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //──────────────────────────── Body Rows
                        ListView.builder(
                          itemCount: foods.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = foods[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue.withOpacity(0.1),
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        AppColors.mediumBlue.withOpacity(0.5),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // 🖼 Image
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.pureWhite,
                                          image: DecorationImage(
                                            image: NetworkImage(item.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // 🍴 Name
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          color: AppColors.pureWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // ✏️ Edit
                                  Expanded(
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          foodNameController.text = item.name;
                                          customAddFoodDialog(
                                            context: context,
                                            oldImage: item.imageUrl,
                                            nameController: foodNameController,
                                            onPressed: () async {
                                              final newImage = context
                                                  .read<ImageProviderModel>()
                                                  .pickedImage;

                                              final updated = FoodItemModel(
                                                foodItemId: item.foodItemId,
                                                name: foodNameController.text
                                                    .trim(),
                                                imageUrl: newImage != null
                                                    ? await context
                                                            .read<
                                                                FoodItemServices>()
                                                            .sendImageToCloudinary(
                                                                newImage) ??
                                                        item.imageUrl
                                                    : item.imageUrl,
                                              );

                                              // update Firestore record
                                              await context
                                                  .read<FoodItemServices>()
                                                  .editFoodItem(
                                                    updated,
                                                    item.imageUrl,
                                                    newImage,
                                                  );

                                              if (Navigator.canPop(context)) {
                                                foodNameController.clear();
                                                context
                                                    .read<ImageProviderModel>()
                                                    .clearImage();
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                              }
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.deepBlue,
                                          foregroundColor: AppColors.pureWhite,
                                          minimumSize: const Size(60, 32),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // 🗑 Delete
                                  Expanded(
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          customDeleteDialog(context, () {
                                            context
                                                .read<FoodItemServices>()
                                                .deleteFoodItem(item);
                                            Navigator.pop(context);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: AppColors.pureWhite,
                                          minimumSize: const Size(60, 32),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
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
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
