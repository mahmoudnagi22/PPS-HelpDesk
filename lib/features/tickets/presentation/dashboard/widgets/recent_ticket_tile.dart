import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../domain/entities/ticket_entity.dart';
import '../../shared/widgets/priority_badge.dart';
import '../../shared/widgets/status_chip.dart';

class RecentTicketTile extends StatelessWidget {
  const RecentTicketTile({super.key, required this.ticket, this.onTap});

  final TicketEntity ticket;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.subject, style: AppTextStyles.body),
            SizedBox(height: 6.h),
            Row(
              children: [
                StatusChip(status: ticket.status),
                SizedBox(width: 8.w),
                PriorityBadge(priority: ticket.priority),
                const Spacer(),
                Text(
                  DateFormatter.toReadableDate(ticket.createdAt),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
