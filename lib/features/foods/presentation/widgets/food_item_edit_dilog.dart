// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mera_web/core/functions/image_functions.dart';
// import 'package:mera_web/core/provider/pick_image.dart';
// import 'package:mera_web/core/theme/textstyle.dart';
// import 'package:mera_web/core/theme/web_color.dart';
// import 'package:mera_web/core/widgets/input_decoration.dart';
// import 'package:mera_web/features/foods/model/food_item_model.dart';
// import 'package:mera_web/features/foods/provider/dialogstateprovider.dart';
// import 'package:provider/provider.dart';

// Future<void> customEditFoodItemDialog({
//   required BuildContext context,
//   required FoodItemModel food,
//   required void Function({
//     required Uint8List? imageBytes,
//     required String? imageUrl,
//     required String name,
//     required int prepTimeMinutes,
//     required double calories,
//     required String description,
//     required double price,
//     required String category,
//     required bool isCompo,
//     required bool isTodayOffer,
//     required bool isHalfAvailable,
//     required double? halfPrice,
//     required bool isBestSeller,
//   }) onUpdate,
// }) async {
//   final TextEditingController nameController =
//       TextEditingController(text: food.name);
//   final TextEditingController prepController =
//       TextEditingController(text: food.prepTimeMinutes.toString());
//   final TextEditingController calController =
//       TextEditingController(text: food.calories.toString());
//   final TextEditingController descController =
//       TextEditingController(text: food.description);
//   final TextEditingController priceController =
//       TextEditingController(text: food.price.toString());
//   final TextEditingController halfPriceController =
//       TextEditingController(text: food.halfPrice?.toString() ?? "");

//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return ChangeNotifierProvider(
//         create: (_) => AddFoodDialogProvider()
//           ..selectedCategory = food.category
//           ..isCompo = food.isCompo
//           ..isTodayOffer = food.isTodayOffer
//           ..isHalfAvailable = food.isHalfAvailable
//           ..isBestSeller = food.isBestSeller,
//         child: Consumer2<ImageProviderModel, AddFoodDialogProvider>(
//           builder: (context, imageProvider, dialogProvider, _) {
//             return Dialog(
//               backgroundColor: AppColors.deepBlue,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               insetPadding:
//                   const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16)
//                     .copyWith(left: 24, right: 24, bottom: 30),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // 📸 Image picker
//                     GestureDetector(
//                       onTap: () async {
//                         try {
//                           final image = await pickImage();
//                           imageProvider.setImage(image);
//                         } catch (e) {
//                           log("Image pick error: $e");
//                         }
//                       },
//                       child: Container(
//                         height: 200,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.darkBlue,
//                           border:
//                               Border.all(color: AppColors.mediumBlue, width: 2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: imageProvider.pickedImage != null
//                             ? Image.memory(imageProvider.pickedImage!,
//                                 fit: BoxFit.contain)
//                             : Image.network(
//                                 food.imageUrl,
//                                 fit: BoxFit.contain,
//                                 loadingBuilder: (context, child, progress) =>
//                                     progress == null
//                                         ? child
//                                         : const Center(
//                                             child: CircularProgressIndicator(
//                                                 color: AppColors.lightBlue)),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // 📝 Input fields
//                     _field("Food name", nameController),
//                     const SizedBox(height: 16),
//                     _field("Preparation time (min)", prepController,
//                         keyboard: TextInputType.number),
//                     const SizedBox(height: 16),
//                     _field("Calories (kcal)", calController,
//                         keyboard: TextInputType.number),
//                     const SizedBox(height: 16),
//                     _field("Description", descController, maxLines: 2),
//                     const SizedBox(height: 16),
//                     _field("Price", priceController,
//                         keyboard: TextInputType.number),
//                     const SizedBox(height: 16),

//                     // 📂 Category dropdown
//                     StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection("Category")
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                             child: CircularProgressIndicator(
//                                 color: AppColors.lightBlue),
//                           );
//                         }
//                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                           return const Text("No categories found.",
//                               style: CustomTextStyles.text);
//                         }

//                         final categories = snapshot.data!.docs
//                             .map((e) => e['name'].toString())
//                             .toList();

//                         return DropdownButtonFormField<String>(
//                           value: dialogProvider.selectedCategory,
//                           isExpanded: true,
//                           decoration: inputDecoration("Select category name"),
//                           dropdownColor: AppColors.darkBlue,
//                           style: CustomTextStyles.text.copyWith(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                           iconEnabledColor: Colors.white70,
//                           items: categories
//                               .map(
//                                 (e) => DropdownMenuItem<String>(
//                                   value: e,
//                                   child: Center(
//                                     child: Text(
//                                       e,
//                                       style: CustomTextStyles.text,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (val) =>
//                               dialogProvider.selectCategory(val),
//                           selectedItemBuilder: (context) {
//                             return categories
//                                 .map((e) => Center(
//                                       child: Text(
//                                         e,
//                                         style: CustomTextStyles.text,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ))
//                                 .toList();
//                           },
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 25),

//                     // ✅ checkboxes
//                     Wrap(
//                       alignment: WrapAlignment.spaceBetween,
//                       runSpacing: 12,
//                       spacing: 12,
//                       children: [
//                         _checkBoxItem(
//                           label: "Compo Food",
//                           value: dialogProvider.isCompo,
//                           onChanged: (v) =>
//                               dialogProvider.toggleCompo(v ?? false),
//                         ),
//                         _checkBoxItem(
//                           label: "Today Offer",
//                           value: dialogProvider.isTodayOffer,
//                           onChanged: (v) =>
//                               dialogProvider.toggleTodayOffer(v ?? false),
//                         ),
//                         _checkBoxItem(
//                           label: "Half Available",
//                           value: dialogProvider.isHalfAvailable,
//                           onChanged: (v) =>
//                               dialogProvider.toggleHalfAvailable(v ?? false),
//                         ),
//                         _checkBoxItem(
//                           label: "Best Seller",
//                           value: dialogProvider.isBestSeller,
//                           onChanged: (v) =>
//                               dialogProvider.toggleBestSeller(v ?? false),
//                         ),
//                       ],
//                     ),

//                     if (dialogProvider.isHalfAvailable) ...[
//                       const SizedBox(height: 16),
//                       _field("Half Price", halfPriceController,
//                           keyboard: TextInputType.number),
//                     ],
//                     const SizedBox(height: 30),

//                     // 🎯 Update button
//                     Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.lightBlue,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 16, horizontal: 300),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                         onPressed: () {
//                           final name = nameController.text.trim();
//                           final prep =
//                               int.tryParse(prepController.text.trim()) ?? 0;
//                           final cal =
//                               double.tryParse(calController.text.trim()) ?? 0.0;
//                           final desc = descController.text.trim();
//                           final price =
//                               double.tryParse(priceController.text.trim()) ??
//                                   0.0;
//                           final halfPrice = dialogProvider.isHalfAvailable
//                               ? double.tryParse(
//                                       halfPriceController.text.trim()) ??
//                                   0.0
//                               : null;

//                           if (name.isEmpty ||
//                               dialogProvider.selectedCategory == null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content:
//                                     Text("Please fill all required fields."),
//                                 backgroundColor: Colors.redAccent,
//                               ),
//                             );
//                             return;
//                           }

//                           onUpdate(
//                             imageBytes: imageProvider.pickedImage,
//                             imageUrl: food.imageUrl,
//                             name: name,
//                             prepTimeMinutes: prep,
//                             calories: cal,
//                             description: desc,
//                             price: price,
//                             category: dialogProvider.selectedCategory!,
//                             isCompo: dialogProvider.isCompo,
//                             isTodayOffer: dialogProvider.isTodayOffer,
//                             isHalfAvailable: dialogProvider.isHalfAvailable,
//                             halfPrice: halfPrice,
//                             isBestSeller: dialogProvider.isBestSeller,
//                           );
//                           Navigator.pop(context);
//                         },
//                         child: const Text(
//                           "Update Food Item",
//                           style: CustomTextStyles.buttonText,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }

// //────────────────────────────────────────────
// // 🔹 Helper widgets (same as add dialog)
// //────────────────────────────────────────────
// Widget _field(String hint, TextEditingController ctl,
//     {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
//   return TextField(
//     controller: ctl,
//     keyboardType: keyboard,
//     maxLines: maxLines,
//     decoration: inputDecoration(hint),
//     style: CustomTextStyles.text,
//   );
// }

// Widget _checkBoxItem({
//   required String label,
//   required bool value,
//   required ValueChanged<bool?> onChanged,
// }) {
//   return InkWell(
//     onTap: () => onChanged(!value),
//     borderRadius: BorderRadius.circular(8),
//     child: Container(
//       width: 200,
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       decoration: BoxDecoration(
//         color: AppColors.darkBlue,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: value ? AppColors.lightBlue : Colors.transparent,
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.lightBlue.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Transform.scale(
//             scale: 1.3,
//             child: Checkbox(
//               value: value,
//               onChanged: onChanged,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               side: const BorderSide(color: Colors.white54, width: 1.5),
//               activeColor: AppColors.lightBlue,
//               checkColor: AppColors.pureWhite,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               label,
//               style: CustomTextStyles.text.copyWith(
//                 color: AppColors.pureWhite,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/widgets/customtextfield.dart';
import 'package:mera_web/core/provider/pick_image.dart';
import 'package:provider/provider.dart';
import 'package:mera_web/core/functions/image_functions.dart';

Future<void> showEditFoodDialog({
  required BuildContext context,
  required String currentName,
  String? oldImage,
  required void Function(String newName) onSave,
}) async {
  final nameController = TextEditingController(text: currentName);

  await showDialog(
    context: context,
    builder: (context) {
      final imageProvider = Provider.of<ImageProviderModel>(context);

      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🖼 Image picker
              GestureDetector(
                onTap: () async {
                  try {
                    final image = await pickImage();
                    imageProvider.setImage(image);
                  } catch (e) {
                    log("Image pick error: $e");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueGrey, width: 2),
                    color: Colors.grey[200],
                  ),
                  height: 200,
                  width: double.infinity,
                  child: imageProvider.pickedImage != null
                      ? Image.memory(
                          imageProvider.pickedImage!,
                          fit: BoxFit.contain,
                        )
                      : oldImage != null
                          ? Image.network(
                              oldImage,
                              fit: BoxFit.contain,
                            )
                          : const Center(
                              child: Text(
                                "Click here to add image!",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 20),

              // 📝 Food name field
              CustemTextFIeld(
                hintText: "Enter food item name",
                controller: nameController,
              ),
              const SizedBox(height: 20),

              // 💾 Save button
              ElevatedButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty) {
                    onSave(newName);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: CustomTextStyles.addCategory, // uses your theme style
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
