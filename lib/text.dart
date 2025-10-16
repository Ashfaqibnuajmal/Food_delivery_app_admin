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
