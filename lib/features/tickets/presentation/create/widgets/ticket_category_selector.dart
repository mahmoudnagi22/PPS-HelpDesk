import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../../core/widgets/app_custom_dropdown.dart';
import '../../shared/utils/ticket_enum_labels.dart';

class TicketCategorySelector extends StatelessWidget {
  const TicketCategorySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TicketCategory value;
  final ValueChanged<TicketCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.heading2),
        SizedBox(height: 8.h),
        AppCustomDropdown<TicketCategory>(
          value: value,
          items: TicketCategory.values,
          itemLabelBuilder: ticketCategoryLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
