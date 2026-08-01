import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../domain/entities/ticket_entity.dart';
import 'recent_ticket_tile.dart';

class RecentTicketsSection extends StatelessWidget {
  const RecentTicketsSection({
    super.key,
    required this.tickets,
    required this.onViewAll,
    required this.onTicketTap,
  });

  final List<TicketEntity> tickets;
  final VoidCallback onViewAll;
  final ValueChanged<TicketEntity> onTicketTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Tickets', style: AppTextStyles.heading2),
            TextButton(onPressed: onViewAll, child: const Text('View All')),
          ],
        ),
        SizedBox(height: 8.h),
        if (tickets.isEmpty)
          const EmptyState(message: 'No tickets yet')
        else
          Column(
            children: tickets
                .map(
                  (ticket) => RecentTicketTile(
                    ticket: ticket,
                    onTap: () => onTicketTap(ticket),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
