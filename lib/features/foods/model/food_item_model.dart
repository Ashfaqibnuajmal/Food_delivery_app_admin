// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mera_web/features/foods/model/food_item_model.dart';

// class FoodItemCloudService extends ChangeNotifier {
//   final CollectionReference<Map<String, dynamic>> foodItemCollection =
//       FirebaseFirestore.instance.collection("FoodItems");

//   // 🔹 your Cloudinary credentials
//   static const cloudName = "dsuwmcmw4";
//   static const cloudPreset = "flutter_uploads";
//   static const cloudApiKey = "837695524881733";
//   static const cloudApiSecret = "BMxWLGuxc0qhl2QAlwmLsXXS3k0";

//   //──────────────────────────────────────────────
//   // 🔸 ADD FOOD ITEM  (upload image first)
//   //──────────────────────────────────────────────
//   Future<void> addFoodItem(FoodItemModel food, Uint8List imageBytes) async {
//     try {
//       final imageUrl = await _uploadImageToCloudinary(imageBytes);
//       if (imageUrl == null) throw "Image upload failed.";

//       final docRef = foodItemCollection.doc();

//       final newItem = FoodItemModel(
//         foodItemUid: docRef.id,
//         imageUrl: imageUrl,
//         name: food.name,
//         prepTimeMinutes: food.prepTimeMinutes,
//         calories: food.calories,
//         description: food.description,
//         price: food.price,
//         category: food.category,
//         isCompo: food.isCompo,
//         isTodayOffer: food.isTodayOffer,
//         isHalfAvailable: food.isHalfAvailable,
//         halfPrice: food.halfPrice,
//         isBestSeller: food.isBestSeller,
//       );

//       await docRef.set(newItem.toMap());
//       log("✅ Food item added: ${newItem.foodItemUid}");
//       notifyListeners();
//     } catch (e, st) {
//       log("❌ Error adding food item: $e\n$st");
//       rethrow;
//     }
//   }

//   //──────────────────────────────────────────────
//   // 🔸 UPDATE FOOD ITEM (replace old Cloudinary image if new selected)
//   //──────────────────────────────────────────────
//   Future<void> editFoodItem(FoodItemModel updatedFood,
//       {Uint8List? newImageBytes, String? oldImageUrl}) async {
//     try {
//       String finalImageUrl = updatedFood.imageUrl;

//       if (newImageBytes != null) {
//         // delete old image first if exists
//         if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
//           await _deleteImageFromCloudinary(oldImageUrl);
//         }
//         final uploaded = await _uploadImageToCloudinary(newImageBytes);
//         if (uploaded != null) finalImageUrl = uploaded;
//       }

//       final newData = updatedFood.copyWith(imageUrl: finalImageUrl);

//       await foodItemCollection
//           .doc(updatedFood.foodItemUid)
//           .update(newData.toMap());

//       log("📝 Food item updated: ${updatedFood.foodItemUid}");
//       notifyListeners();
//     } catch (e, st) {
//       log("❌ Error editing food item: $e\n$st");
//       rethrow;
//     }
//   }

//   //──────────────────────────────────────────────
//   // 🔸 DELETE FOOD ITEM (+ image)
//   //──────────────────────────────────────────────
//   Future<void> deleteFoodItem(String foodUid, String imageUrl) async {
//     try {
//       await _deleteImageFromCloudinary(imageUrl);
//       await foodItemCollection.doc(foodUid).delete();
//       log("🗑️ Food item deleted: $foodUid");
//       notifyListeners();
//     } catch (e, st) {
//       log("❌ Error deleting food item: $e\n$st");
//       rethrow;
//     }
//   }

//   //──────────────────────────────────────────────
//   // 🔸 STREAM FETCH  (Realtime)
//   //──────────────────────────────────────────────
//   Stream<List<FoodItemModel>> fetchFoodItems() {
//     return foodItemCollection.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data();
//         return FoodItemModel.fromMap({
//           ...data,
//           'foodItemUid': doc.id,
//         });
//       }).toList();
//     });
//   }

//   //──────────────────────────────────────────────
//   // 🔹 PRIVATE: Upload image to Cloudinary
//   //──────────────────────────────────────────────
//   Future<String?> _uploadImageToCloudinary(Uint8List imageBytes) async {
//     try {
//       final url =
//           Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

//       final request = http.MultipartRequest("POST", url)
//         ..fields['upload_preset'] = cloudPreset
//         ..files.add(http.MultipartFile.fromBytes(
//           'file',
//           imageBytes,
//           filename: "food_item_${DateTime.now().millisecondsSinceEpoch}",
//         ));

//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final res = await http.Response.fromStream(response);
//         final body = jsonDecode(res.body);
//         log("✅ Image uploaded to Cloudinary");
//         return body["secure_url"];
//       } else {
//         log("❌ Cloudinary upload failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       log("Cloudinary upload error: $e");
//     }
//     return null;
//   }

//   //──────────────────────────────────────────────
//   // 🔹 PRIVATE: Delete image from Cloudinary
//   //──────────────────────────────────────────────
//   Future<void> _deleteImageFromCloudinary(String imageUrl) async {
//     try {
//       final uri = Uri.parse(imageUrl);
//       final filename = uri.pathSegments.last.split('.').first;
//       final url = Uri.parse(
//           "https://api.cloudinary.com/v1_1/$cloudName/resources/image/upload");
//       final auth = base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecret'));

//       final response = await http.delete(
//         url,
//         headers: {
//           "Authorization": "Basic $auth",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({"public_id": "$cloudPreset/$filename"}),
//       );

//       if (response.statusCode == 200) {
//         log("🗑️ Image deleted from Cloudinary: $filename");
//       } else {
//         log("❌ Failed to delete image: ${response.statusCode}");
//       }
//     } catch (e) {
//       log("Delete image error: $e");
//     }
//   }
// }

// extension FoodItemCopy on FoodItemModel {
//   FoodItemModel copyWith({
//     String? foodItemUid,
//     String? imageUrl,
//     String? name,
//     int? prepTimeMinutes,
//     double? calories,
//     String? description,
//     double? price,
//     String? category,
//     bool? isCompo,
//     bool? isTodayOffer,
//     bool? isHalfAvailable,
//     double? halfPrice,
//     bool? isBestSeller,
//   }) {
//     return FoodItemModel(
//       foodItemUid: foodItemUid ?? this.foodItemUid,
//       imageUrl: imageUrl ?? this.imageUrl,
//       name: name ?? this.name,
//       prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
//       calories: calories ?? this.calories,
//       description: description ?? this.description,
//       price: price ?? this.price,
//       category: category ?? this.category,
//       isCompo: isCompo ?? this.isCompo,
//       isTodayOffer: isTodayOffer ?? this.isTodayOffer,
//       isHalfAvailable: isHalfAvailable ?? this.isHalfAvailable,
//       halfPrice: halfPrice ?? this.halfPrice,
//       isBestSeller: isBestSeller ?? this.isBestSeller,
//     );
//   }
// }
class FoodItemModel {
  final String foodItemId;
  final String name;
  final String imageUrl;

  const FoodItemModel({
    required this.foodItemId,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "foodItemId": foodItemId, // ✅ same key name/case
      "name": name,
      "imageUrl": imageUrl,
    };
  }

  factory FoodItemModel.fromMap(Map<String, dynamic> map) {
    return FoodItemModel(
      foodItemId: map["foodItemId"] ?? "",
      name: map["name"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
    );
  }
}
