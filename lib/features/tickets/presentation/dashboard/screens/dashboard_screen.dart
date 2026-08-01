import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/services/service_locator.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../../domain/entities/ticket_entity.dart';
import '../../cubit/ticket_cubit.dart';
import '../../cubit/ticket_state.dart';
import '../../create/screens/create_ticket_screen.dart';
import '../../details/screens/ticket_details_screen.dart';
import '../../list/screens/ticket_list_screen.dart';
import '../widgets/dashboard_summary_section.dart';
import '../widgets/recent_tickets_section.dart';

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

  Future<void> _openCreateTicket(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
    );
    if (context.mounted) {
      context.read<TicketCubit>().loadTickets();
    }
  }

  Future<void> _openTicketList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TicketListScreen()),
    );
    if (context.mounted) {
      context.read<TicketCubit>().loadTickets();
    }
  }

  Future<void> _openTicketDetails(
    BuildContext context,
    TicketEntity ticket,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TicketDetailsScreen(ticket: ticket)),
    );
    if (context.mounted) {
      context.read<TicketCubit>().loadTickets();
    }
  }

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
            TicketLoaded() => SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardSummarySection(tickets: state.tickets),
                  SizedBox(height: 24.h),
                  RecentTicketsSection(
                    tickets: state.visibleTickets.take(5).toList(),
                    onViewAll: () => _openTicketList(context),
                    onTicketTap: (ticket) =>
                        _openTicketDetails(context, ticket),
                  ),
                ],
              ),
            ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateTicket(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
