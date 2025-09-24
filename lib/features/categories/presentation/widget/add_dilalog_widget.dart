import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mera_web/core/functions/image_functions.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/core/widgets/customtextfield.dart';
import 'package:mera_web/features/categories/provider/pick_image.dart';
import 'package:provider/provider.dart';

custemAddDialog({
  required BuildContext context,
  String? oldImage,
  required TextEditingController controller,
  required void Function() onpressed,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final imageProvider = Provider.of<ImageProviderModel>(context);

      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(
            horizontal: 100, vertical: 50), // More space
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 20),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Makes dialog adapt to content size
            children: [
              // Image Picker Container
              GestureDetector(
                onTap: () async {
                  try {
                    final image = await pickImage();
                    imageProvider.setImage(image);
                  } catch (e) {
                    log(e.toString());
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
                          ? Image.network(oldImage, fit: BoxFit.contain)
                          : const Center(
                              child: Text(
                                "Click here to add image!",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Name TextField
              CustemTextFIeld(
                hintText: "Enter category name",
                controller: controller,
              ),
              const SizedBox(height: 20),

              // Add Category Button
              ElevatedButton(
                onPressed: onpressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add Category",
                  style: CustomTextStyles.addCategory,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
