import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/ticket_entity.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';
import '../widgets/priority_badge.dart';
import '../widgets/status_chip.dart';
import '../widgets/ticket_summary_card.dart';
import 'create_ticket_screen.dart';
import 'ticket_details_screen.dart';
import 'ticket_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketCubit>()..loadTickets(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PPS HelpDesk')),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          return switch (state) {
            TicketInitial() || TicketLoading() => const LoadingIndicator(),
            TicketError(:final message) => EmptyState(
              message: message,
              icon: Icons.error_outline,
            ),
            TicketLoaded() => _DashboardContent(state: state),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
          );
          if (context.mounted) {
            context.read<TicketCubit>().loadTickets();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});

  final TicketLoaded state;

  @override
  Widget build(BuildContext context) {
    final tickets = state.tickets;
    final recentTickets = state.visibleTickets.take(5).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryGrid(tickets: tickets),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Tickets', style: AppTextStyles.heading2),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TicketListScreen(),
                    ),
                  );
                  if (context.mounted) {
                    context.read<TicketCubit>().loadTickets();
                  }
                },
                child: const Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (recentTickets.isEmpty)
            const EmptyState(message: 'No tickets yet')
          else
            Column(
              children: recentTickets
                  .map((ticket) => _RecentTicketTile(ticket: ticket))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.tickets});

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

class _RecentTicketTile extends StatelessWidget {
  const _RecentTicketTile({required this.ticket});

  final TicketEntity ticket;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TicketDetailsScreen(ticket: ticket)),
        );
        if (context.mounted) {
          context.read<TicketCubit>().loadTickets();
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.15)),
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
