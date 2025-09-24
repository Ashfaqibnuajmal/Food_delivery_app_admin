import 'package:flutter/material.dart';

customAlertDialog(BuildContext context, VoidCallback? onpress) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Delete"),
            content: const Text("are you sure you want ot delete this"),
            actions: [
              ElevatedButton(
                  onPressed: onpress, child: const Text("Delete it")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context);
                  },
                  child: const Text("No"))
            ],
          ));
}
