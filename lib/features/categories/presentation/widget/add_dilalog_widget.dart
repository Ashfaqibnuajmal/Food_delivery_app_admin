import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mera_web/core/functions/image_functions.dart';
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
        // ignore: non_constant_identifier_names
        final ImageProvider = Provider.of<ImageProviderModel>(context);
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          insetPadding: const EdgeInsets.all(150),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        final image = await pickImage();
                        ImageProvider.setImage(image);
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueGrey, width: 2),
                          color: Colors.grey[200]),
                      height: 250,
                      width: 250,
                      child: ImageProvider.pickedImage != null
                          ? Image.memory(
                              ImageProvider.pickedImage!,
                              fit: BoxFit.cover,
                            )
                          : oldImage != null
                              ? Image.network(oldImage, fit: BoxFit.cover)
                              : const Center(
                                  child: Text(
                                    "Click here to add image!.",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CustemTextFIeld(
                        label: "Categoryname",
                        hintText: "Categoryname",
                        controller: controller),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: onpressed, child: const Text("Add category"))
                ],
              ),
            ),
          ),
        );
      });
}
