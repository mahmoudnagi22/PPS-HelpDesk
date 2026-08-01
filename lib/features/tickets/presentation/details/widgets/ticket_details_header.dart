import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../shared/widgets/priority_badge.dart';
import '../../shared/widgets/status_chip.dart';

class TicketDetailsHeader extends StatelessWidget {
  const TicketDetailsHeader({
    super.key,
    required this.ticketId,
    required this.createdAt,
    required this.status,
    required this.priority,
  });

  final String ticketId;
  final DateTime createdAt;
  final TicketStatus status;
  final TicketPriority priority;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(ticketId, style: AppTextStyles.heading2),
            Text(
              DateFormatter.toReadableDate(createdAt),
              style: AppTextStyles.caption,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            StatusChip(status: status),
            SizedBox(width: 8.w),
            PriorityBadge(priority: priority),
          ],
        ),
      ],
    );
  }
}
