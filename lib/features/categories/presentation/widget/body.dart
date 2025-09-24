import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';
import 'package:mera_web/features/categories/models/category_model.dart';
import 'package:mera_web/features/categories/presentation/widget/add_dilalog_widget.dart';
import 'package:mera_web/features/categories/presentation/widget/confiorm_dilog.dart';
import 'package:mera_web/features/categories/provider/pick_image.dart';
import 'package:mera_web/features/categories/services/category_sevices.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  TextEditingController catagorynameController = TextEditingController();

  Body({super.key, required this.catagorynameController});
  double sidebarWidth = 250; // Change this to your actual sidebar width

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
            child: StreamBuilder<List<CategoryModel>>(
                stream: context.read<CategorySevices>().fetchCatagories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No categories found"),
                    );
                  }

                  final categories = snapshot.data!;

                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width > 600
                          ? 600
                          : MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[400]!, width: 1),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text('Image',
                                      style: CustomTextStyles.header),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Name',
                                      style: CustomTextStyles.header),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Edit',
                                    style: CustomTextStyles.header,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Delete',
                                    style: CustomTextStyles.header,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // List
                          ListView.builder(
                            itemCount: categories.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final value = categories[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Image
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey[200],
                                          image: DecorationImage(
                                            image: NetworkImage(value.imageUrl),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Name
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          value.name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    // Edit Button
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            catagorynameController =
                                                TextEditingController(
                                                    text: value.name);
                                            custemAddDialog(
                                                context: context,
                                                oldImage: value.imageUrl,
                                                controller:
                                                    catagorynameController,
                                                onpressed: () async {
                                                  final newImage = context
                                                      .read<
                                                          ImageProviderModel>()
                                                      .pickedImage;
                                                  final updatedCatagory = CategoryModel(
                                                      categoryUid:
                                                          value.categoryUid,
                                                      imageUrl: newImage != null
                                                          ? await context
                                                                  .read<
                                                                      CategorySevices>()
                                                                  .sendImageToCloudinary(
                                                                      newImage) ??
                                                              value.imageUrl
                                                          : value.imageUrl,
                                                      name:
                                                          catagorynameController
                                                              .text);
                                                  // ignore: use_build_context_synchronously
                                                  context
                                                      .read<CategorySevices>()
                                                      .editCategory(
                                                          updatedCatagory,
                                                          value.imageUrl);
                                                  // ignore: use_build_context_synchronously
                                                  if (Navigator.canPop(
                                                      // ignore: use_build_context_synchronously
                                                      context)) {
                                                    catagorynameController
                                                        .clear();
                                                    // ignore: use_build_context_synchronously
                                                    context
                                                        .read<
                                                            ImageProviderModel>()
                                                        .clearImage();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
                                                  }
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(60, 32),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Delete Button
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            customDeleteDilog(context, () {
                                              context
                                                  .read<CategorySevices>()
                                                  .deleteCategory(value);
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(60, 32),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text(
                                            'Delete',
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
                }),
          ),
        ),
      ),
    );
  }
}
