import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';

class SubmitTicketButton extends StatelessWidget {
  const SubmitTicketButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        label: 'Submit Ticket',
        isLoading: isLoading,
        onPressed: onPressed,
      ),
    );
  }
}
