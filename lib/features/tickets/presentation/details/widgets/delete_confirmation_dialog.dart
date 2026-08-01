import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Ticket'),
      content: const Text('Are you sure you want to delete this ticket?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ),
  );
}
