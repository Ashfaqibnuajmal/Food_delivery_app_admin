import 'package:flutter/material.dart';
import 'package:mera_web/core/theme/textstyle.dart';

customDeleteDilog(BuildContext context, VoidCallback? onPress) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Delete icon in red circle
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53E3E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Delete',
                style: CustomTextStyles.deleteTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to delete this item?',
                style: CustomTextStyles.deleteMessage,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // NO button
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E5E5),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('NO', style: CustomTextStyles.yesORno),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // YES button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53E3E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('YES', style: CustomTextStyles.yesORno),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
