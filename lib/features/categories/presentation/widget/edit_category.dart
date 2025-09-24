import 'package:flutter/material.dart';

Future<void> showEditCategoryDialog(
  BuildContext context,
  String currentName,
  void Function(String newName) onSave,
) async {
  final nameController = TextEditingController(text: currentName);
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit category"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Category name"),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty) {
                    onSave(newName);
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"))
          ],
        );
      });
}
