import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../../core/widgets/app_custom_dropdown.dart';
import '../../shared/utils/ticket_enum_labels.dart';

class TicketPrioritySelector extends StatelessWidget {
  const TicketPrioritySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TicketPriority value;
  final ValueChanged<TicketPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority', style: AppTextStyles.heading2),
        SizedBox(height: 8.h),
        AppCustomDropdown<TicketPriority>(
          value: value,
          items: TicketPriority.values,
          itemLabelBuilder: ticketPriorityLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
