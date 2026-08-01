import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/enums.dart';
import '../../../domain/entities/ticket_entity.dart';
import 'ticket_summary_card.dart';

class DashboardSummarySection extends StatelessWidget {
  const DashboardSummarySection({super.key, required this.tickets});

  final List<TicketEntity> tickets;

  @override
  Widget build(BuildContext context) {
    final total = tickets.length;
    final open = tickets
        .where((ticket) => ticket.status == TicketStatus.open)
        .length;
    final inProgress = tickets
        .where((ticket) => ticket.status == TicketStatus.inProgress)
        .length;
    final closed = tickets
        .where((ticket) => ticket.status == TicketStatus.closed)
        .length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.4,
      children: [
        TicketSummaryCard(
          title: 'Total Tickets',
          count: total,
          icon: Icons.confirmation_number_outlined,
          color: AppColors.secondary,
        ),
        TicketSummaryCard(
          title: 'Open',
          count: open,
          icon: Icons.mark_email_unread_outlined,
          color: AppColors.primary,
        ),
        TicketSummaryCard(
          title: 'In Progress',
          count: inProgress,
          icon: Icons.autorenew,
          color: AppColors.warning,
        ),
        TicketSummaryCard(
          title: 'Closed',
          count: closed,
          icon: Icons.check_circle_outline,
          color: AppColors.success,
        ),
      ],
    );
  }
}
