import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/app_text_field.dart';

class TicketTextFieldsSection extends StatelessWidget {
  const TicketTextFieldsSection({
    super.key,
    required this.subjectController,
    required this.descriptionController,
    this.subjectHint,
    this.descriptionHint,
  });

  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final String? subjectHint;
  final String? descriptionHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subject', style: AppTextStyles.heading2),
        SizedBox(height: 8.h),
        AppTextField(
          controller: subjectController,
          hintText: subjectHint,
          validator: (value) => Validators.requiredField(value, 'Subject'),
        ),
        SizedBox(height: 20.h),
        Text('Description', style: AppTextStyles.heading2),
        SizedBox(height: 8.h),
        AppTextField(
          controller: descriptionController,
          hintText: descriptionHint,
          maxLines: 5,
          validator: (value) =>
              Validators.requiredField(value, 'Description'),
        ),
      ],
    );
  }
}
