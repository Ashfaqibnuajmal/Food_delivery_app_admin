// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mera_web/core/provider/user_search_provider.dart';
// import 'package:mera_web/core/theme/web_color.dart';
// import 'package:mera_web/core/widgets/voice_search.bar.dart';
// import 'package:mera_web/features/foods/model/food_item_model.dart';
// import 'package:mera_web/features/foods/services/food_item_services.dart';
// import 'package:mera_web/features/foods/presentation/widgets/food_item_add_dilog.dart';
// import 'package:mera_web/features/foods/presentation/widgets/food_item_edit_dilog.dart';
// import 'package:mera_web/features/foods/presentation/widgets/food_item_header.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class FooditemScreen extends StatelessWidget {
//   const FooditemScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final foodService = Provider.of<FoodItemServices>(context, listen: false);

//     return Scaffold(
//       backgroundColor: AppColors.darkBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FoodItemHeader(
//                 title: "Food Items Management",
//                 oneAddPressed: () async {
//                   await customAddFoodItemDialog(
//                     context: context,
//                     onSubmit: ({
//                       required Uint8List? imageBytes,
//                       required String name,
//                       required int prepTimeMinutes,
//                       required double calories,
//                       required String description,
//                       required double price,
//                       required String category,
//                       required bool isCompo,
//                       required bool isTodayOffer,
//                       required bool isHalfAvailable,
//                       required double? halfPrice,
//                       required bool isBestSeller,
//                     }) async {
//                       // Upload image
//                       final storageRef = FirebaseStorage.instance.ref().child(
//                           "food_images/${DateTime.now().millisecondsSinceEpoch}.jpg");
//                       await storageRef.putData(imageBytes!);
//                       final imageUrl = await storageRef.getDownloadURL();

//                       final newItem = FoodItemModel(
//                         foodItemUid: "",
//                         imageUrl: imageUrl,
//                         name: name,
//                         prepTimeMinutes: prepTimeMinutes,
//                         calories: calories,
//                         description: description,
//                         price: price,
//                         category: category,
//                         isCompo: isCompo,
//                         isTodayOffer: isTodayOffer,
//                         isHalfAvailable: isHalfAvailable,
//                         halfPrice: halfPrice,
//                         isBestSeller: isBestSeller,
//                       );

//                       await foodService.addFoodItem(newItem);
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 40),
//               Consumer<UserSearchProvider>(
//                 builder: (context, _, __) => const VoiceSearchBar(),
//               ),
//               const SizedBox(height: 40),

//               //──────────────────────────────────────────────
//               // Header
//               //──────────────────────────────────────────────
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                 decoration: const BoxDecoration(
//                   color: AppColors.deepBlue,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: const Row(
//                   children: [
//                     _HeaderCell("Image", flex: 2),
//                     _HeaderCell("Name\n&\nPrepTime\n&\nCalories", flex: 3),
//                     _HeaderCell("Description", flex: 3),
//                     _HeaderCell("Price", flex: 2),
//                     _HeaderCell("Category", flex: 2),
//                     _HeaderCell("Food Type", flex: 2),
//                     _HeaderCell("Today Offer", flex: 2),
//                     _HeaderCell("Half Portion\n&\nPrice", flex: 3),
//                     _HeaderCell("Best Seller", flex: 2),
//                     _HeaderCell("Edit", flex: 2),
//                     _HeaderCell("Delete", flex: 2),
//                   ],
//                 ),
//               ),

//               //──────────────────────────────────────────────
//               // Table Body (Realtime Firestore)
//               //──────────────────────────────────────────────
//               Expanded(
//                 child: StreamBuilder<List<FoodItemModel>>(
//                   stream: foodService.fetchFoodItems(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                           child: CircularProgressIndicator(
//                               color: AppColors.lightBlue));
//                     }
//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           "No food items found.",
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                       );
//                     }

//                     final items = snapshot.data!;
//                     return ListView.separated(
//                       itemCount: items.length,
//                       separatorBuilder: (_, __) => Divider(
//                         color: AppColors.mediumBlue.withOpacity(0.4),
//                         height: 0,
//                       ),
//                       itemBuilder: (context, index) {
//                         final food = items[index];
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: AppColors.lightBlue.withOpacity(0.08),
//                           ),
//                           child: Row(
//                             children: [
//                               // Image
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: AppColors.pureWhite,
//                                       image: DecorationImage(
//                                         image: NetworkImage(food.imageUrl),
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // Name + PrepTime + Calories
//                               Expanded(
//                                 flex: 3,
//                                 child: Center(
//                                   child: Text(
//                                     "${food.name}\n${food.prepTimeMinutes} min | ${food.calories} kcal",
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       color: AppColors.pureWhite,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // Description
//                               Expanded(
//                                 flex: 3,
//                                 child: Center(
//                                   child: Text(
//                                     food.description,
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       color: AppColors.pureWhite,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // Price
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: Text(
//                                     "₹${food.price.toStringAsFixed(2)}",
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               // Category
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: Text(
//                                     food.category,
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               // Food Type
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: Text(
//                                     food.isCompo ? "Compo" : "Individual",
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               // Today Offer – green or red text
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: Text(
//                                     food.isTodayOffer ? "Offer" : "No Offer",
//                                     style: TextStyle(
//                                       color: food.isTodayOffer
//                                           ? Colors.greenAccent
//                                           : Colors.redAccent,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // Half Portion + Price
//                               Expanded(
//                                 flex: 3,
//                                 child: Center(
//                                   child: Text(
//                                     food.isHalfAvailable
//                                         ? "Available ₹${food.halfPrice?.toStringAsFixed(2) ?? '-'}"
//                                         : "Not Available",
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               // Best Seller
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: Text(
//                                     food.isBestSeller ? "★ Yes" : "No",
//                                     style: TextStyle(
//                                       color: food.isBestSeller
//                                           ? Colors.amberAccent
//                                           : Colors.white60,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               // Edit
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: ElevatedButton(
//                                     onPressed: () async {
//                                       await customEditFoodItemDialog(
//                                         context: context,
//                                         food: food,
//                                         onUpdate: ({
//                                           required Uint8List? imageBytes,
//                                           required String? imageUrl,
//                                           required String name,
//                                           required int prepTimeMinutes,
//                                           required double calories,
//                                           required String description,
//                                           required double price,
//                                           required String category,
//                                           required bool isCompo,
//                                           required bool isTodayOffer,
//                                           required bool isHalfAvailable,
//                                           required double? halfPrice,
//                                           required bool isBestSeller,
//                                         }) async {
//                                           String finalUrl = imageUrl!;
//                                           if (imageBytes != null) {
//                                             final storageRef = FirebaseStorage
//                                                 .instance
//                                                 .ref()
//                                                 .child(
//                                                     "food_images/${DateTime.now().millisecondsSinceEpoch}.jpg");
//                                             await storageRef
//                                                 .putData(imageBytes);
//                                             finalUrl = await storageRef
//                                                 .getDownloadURL();
//                                           }
//                                           final updated = FoodItemModel(
//                                             foodItemUid: food.foodItemUid,
//                                             imageUrl: finalUrl,
//                                             name: name,
//                                             prepTimeMinutes: prepTimeMinutes,
//                                             calories: calories,
//                                             description: description,
//                                             price: price,
//                                             category: category,
//                                             isCompo: isCompo,
//                                             isTodayOffer: isTodayOffer,
//                                             isHalfAvailable: isHalfAvailable,
//                                             halfPrice: halfPrice,
//                                             isBestSeller: isBestSeller,
//                                           );
//                                           await foodService
//                                               .editFoodItem(updated);
//                                         },
//                                       );
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.deepBlue,
//                                       foregroundColor: AppColors.pureWhite,
//                                       minimumSize: const Size(60, 32),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(16),
//                                       ),
//                                     ),
//                                     child: const Text("Edit",
//                                         style: TextStyle(fontSize: 12)),
//                                   ),
//                                 ),
//                               ),
//                               // Delete
//                               Expanded(
//                                 flex: 2,
//                                 child: Center(
//                                   child: ElevatedButton(
//                                     onPressed: () async {
//                                       await foodService
//                                           .deleteFoodItem(food.foodItemUid);
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                       foregroundColor: AppColors.pureWhite,
//                                       minimumSize: const Size(60, 32),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(16),
//                                       ),
//                                     ),
//                                     child: const Text("Delete",
//                                         style: TextStyle(fontSize: 12)),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// //────────────────────────────────────────────────────────────
// // 🔹 Helper header cell widget for readability
// //────────────────────────────────────────────────────────────
// class _HeaderCell extends StatelessWidget {
//   final String label;
//   final int flex;
//   const _HeaderCell(this.label, {this.flex = 1});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: flex,
//       child: Center(
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Colors.white70,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/web_color.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_header.dart';
import 'package:mera_web/features/foods/presentation/widgets/food_item_body.dart';

// ignore: must_be_immutable
class FoodItemsScreen extends StatelessWidget {
  TextEditingController foodNameController = TextEditingController();

  FoodItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 🔹 Header – Add Food Item Button
              FoodItemHeader(foodNameController: foodNameController),
              const SizedBox(height: 10),

              // 🔹 Body – Table & List of Food Items
              FoodItemBody(),
            ],
          ),
        ),
      ),
    );
  }
}
