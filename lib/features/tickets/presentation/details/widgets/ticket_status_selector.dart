import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/enums.dart';
import '../../shared/utils/ticket_enum_labels.dart';
import '../../shared/widgets/enum_choice_row.dart';

class TicketStatusSelector extends StatelessWidget {
  const TicketStatusSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TicketStatus value;
  final ValueChanged<TicketStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: AppTextStyles.heading2),
        SizedBox(height: 8.h),
        EnumChoiceRow<TicketStatus>(
          values: TicketStatus.values,
          selected: value,
          labelBuilder: ticketStatusLabel,
          onSelected: onChanged,
        ),
      ],
    );
  }
}
