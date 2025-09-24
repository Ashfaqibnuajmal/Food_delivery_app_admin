import 'package:flutter/material.dart';
import 'package:mera_web/core/widgets/cutom_snackbar.dart';
import 'package:mera_web/features/categories/presentation/widget/add_dilalog_widget.dart';
import 'package:mera_web/features/categories/provider/pick_image.dart';
import 'package:mera_web/features/categories/services/category_sevices.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  final TextEditingController catagorynameController;
  const Header({super.key, required this.catagorynameController});

  @override
  // Widget build(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () => categoryCustomAddDialog(context),
  //     child: const Text("Add Category"),
  //   );
  // }
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Categories",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          ElevatedButton(
              onPressed: () => categoryCustomAddDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 10, // Shadow depth
                shadowColor: Colors.black.withOpacity(0.3), // Shadow color
              ),
              child: const Text(
                "Add Category",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  categoryCustomAddDialog(BuildContext context) {
    custemAddDialog(
        context: context,
        controller: catagorynameController,
        onpressed: () async {
          final imageProvider = context.read<ImageProviderModel>();
          final image = imageProvider.pickedImage;
          final name = catagorynameController.text.trim();
          if (name.isEmpty || image == null) {
            return customSnackbar(context, "Pick a photo", Colors.red);
          }
          await context.read<CategorySevices>().addCategory(name, image);
          // ignore: use_build_context_synchronously
          if (Navigator.canPop(context)) {
            catagorynameController.clear();
            imageProvider.clearImage();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        });
  }
}
