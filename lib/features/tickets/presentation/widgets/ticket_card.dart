import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/ticket_entity.dart';
import 'priority_badge.dart';
import 'status_chip.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket, this.onTap});

  final TicketEntity ticket;
  final VoidCallback? onTap;

  String get _shortId {
    final id = ticket.id;
    return '#${id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _shortId,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  DateFormatter.toReadableDate(ticket.createdAt),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(ticket.subject, style: AppTextStyles.body),
            SizedBox(height: 8.h),
            Row(
              children: [
                StatusChip(status: ticket.status),
                SizedBox(width: 8.w),
                PriorityBadge(priority: ticket.priority),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
