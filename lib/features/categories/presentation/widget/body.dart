import 'dart:developer';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - (13.0 * 2),
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
                      child: Text("Error${snapshot.error}"),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No catagories found"),
                    );
                  }
                  return DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text("Logo")),
                        DataColumn(label: Text("Catagory Name")),
                        DataColumn(label: Text("Action"))
                      ],
                      rows: snapshot.data!.map((value) {
                        return DataRow(cells: [
                          DataCell(Image.network(
                            value.imageUrl,
                            width: 50,
                            height: 50,
                          )),
                          DataCell(Text(value.name)),
                          DataCell(Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  catagorynameController =
                                      TextEditingController(text: value.name);
                                  custemAddDialog(
                                      context: context,
                                      oldImage: value.imageUrl,
                                      controller: catagorynameController,
                                      onpressed: () async {
                                        final newImage = context
                                            .read<ImageProviderModel>()
                                            .pickedImage;
                                        final updatedCatagory = CategoryModel(
                                            categoryUid: value.categoryUid,
                                            imageUrl: newImage != null
                                                ? await context
                                                        .read<CategorySevices>()
                                                        .sendImageToCloudinary(
                                                            newImage) ??
                                                    value.imageUrl
                                                : value.imageUrl,
                                            name: catagorynameController.text);
                                        context
                                            .read<CategorySevices>()
                                            .editCategory(updatedCatagory,
                                                value.imageUrl);
                                        if (Navigator.canPop(context)) {
                                          catagorynameController.clear();
                                          context
                                              .read<ImageProviderModel>()
                                              .clearImage();
                                          Navigator.pop(context);
                                        }
                                      });
                                },
                                child: const Text("edit"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    customAlertDialog(context, () {
                                      context
                                          .read<CategorySevices>()
                                          .deleteCategory(value);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          ))
                        ]);
                      }).toList());
                }),
          ),
        ),
      ),
    );
  }
}
