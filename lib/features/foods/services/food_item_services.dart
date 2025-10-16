import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mera_web/features/foods/model/food_item_model.dart';

class FoodItemServices extends ChangeNotifier {
  final foodItemCollection = FirebaseFirestore.instance.collection("FoodItems");

  // 🔹 Cloudinary credentials (same as your category service)
  static const cloudName = "dsuwmcmw4";
  static const cloudPreset = "flutter_uploads";
  static const cloudApiKey = "837695524881733";
  static const cloudApiSecretKey = "BMxWLGuxc0qhl2QAlwmLsXXS3k0";

  //──────────────────────────────────────────────
  // 🔸 Check if a food item with the same name exists
  //──────────────────────────────────────────────
  Future<bool> isFoodItemExist(String name) async {
    final nameLower = name.toLowerCase();
    try {
      final snapshot = await foodItemCollection.get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final itemName = (data['name'] ?? '') as String;
        if (itemName.toLowerCase() == nameLower) {
          return true;
        }
      }
      return false;
    } catch (e) {
      log("Error checking food item existence: $e");
      return false;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Add new food item (upload image + save Firestore)
  //──────────────────────────────────────────────
  Future<void> addFoodItem(String name, Uint8List image) async {
    try {
      final exists = await isFoodItemExist(name);
      if (exists) {
        throw Exception("Food Item with the name $name already exists!");
      }

      final imageUrl = await sendImageToCloudinary(image);
      if (imageUrl != null) {
        final docRef = foodItemCollection.doc();
        final foodItem = FoodItemModel(
          foodItemId: docRef.id,
          name: name,
          imageUrl: imageUrl,
        );
        await foodItemCollection.doc(docRef.id).set(foodItem.toMap());
        log("✅ FoodItem added: ${foodItem.toMap()}");
      } else {
        throw Exception("Image upload failed!");
      }
    } catch (e) {
      log("❌ Error adding food item: $e");
      rethrow;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Edit food item (replace image if updated)
  //──────────────────────────────────────────────
  Future<void> editFoodItem(
      FoodItemModel foodItem, String oldImageUrl, Uint8List? newImage) async {
    try {
      String finalImageUrl = foodItem.imageUrl;

      // if a new image picked, replace on Cloudinary
      if (newImage != null) {
        await _deleteImageFromCloudinary(oldImageUrl);
        final uploaded = await sendImageToCloudinary(newImage);
        if (uploaded != null) finalImageUrl = uploaded;
      }

      final updatedItem = FoodItemModel(
        foodItemId: foodItem.foodItemId,
        name: foodItem.name,
        imageUrl: finalImageUrl,
      );

      await foodItemCollection
          .doc(foodItem.foodItemId)
          .update(updatedItem.toMap());
      log("📝 Food item updated: ${foodItem.foodItemId}");
    } catch (e) {
      log("❌ Error updating food item: $e");
      rethrow;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Delete food item + image from Cloudinary
  //──────────────────────────────────────────────
  Future<void> deleteFoodItem(FoodItemModel foodItem) async {
    try {
      await _deleteImageFromCloudinary(foodItem.imageUrl);
      await foodItemCollection.doc(foodItem.foodItemId).delete();
      log("🗑️ Food item deleted: ${foodItem.foodItemId}");
    } catch (e) {
      log("❌ Error deleting food item: $e");
      rethrow;
    }
  }

  //──────────────────────────────────────────────
  // 🔸 Fetch all food items in realtime
  //──────────────────────────────────────────────
  Stream<List<FoodItemModel>> fetchFoodItems() {
    return foodItemCollection.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => FoodItemModel.fromMap(doc.data()))
              .toList(),
        );
  }

  //──────────────────────────────────────────────
  // 🔹 Upload image to Cloudinary
  //──────────────────────────────────────────────
  Future<String?> sendImageToCloudinary(Uint8List image) async {
    try {
      final url =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = cloudPreset
        ..files.add(http.MultipartFile.fromBytes(
          "file",
          image,
          filename: "food_item_${DateTime.now().millisecondsSinceEpoch}",
        ));
      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final secureUrl = jsonDecode(res.body)["secure_url"];
        log("✅ Image uploaded to Cloudinary.");
        return secureUrl;
      } else {
        log("❌ Cloudinary upload failed: ${response.statusCode}");
      }
    } catch (e) {
      log("Error sending image to Cloudinary: $e");
    }
    return null;
  }

  //──────────────────────────────────────────────
  // 🔹 Delete image from Cloudinary
  //──────────────────────────────────────────────
  Future<void> _deleteImageFromCloudinary(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final fileName = uri.pathSegments.last.split('.').first;
      final url = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudName/resources/image/upload");
      final headers = {
        "Authorization":
            "Basic ${base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecretKey'))}",
        "Content-Type": "application/json",
      };
      final body = jsonEncode({"public_id": "$cloudPreset/$fileName"});

      final response = await http.delete(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        log("🗑️ Image deleted from Cloudinary: $fileName");
      } else {
        log("❌ Failed to delete image: ${response.statusCode}");
      }
    } catch (e) {
      log("Error deleting image from Cloudinary: $e");
    }
  }
}
