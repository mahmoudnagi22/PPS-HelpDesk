import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';
import '../widgets/ticket_card.dart';
import '../widgets/ticket_filter_bar.dart';
import '../widgets/ticket_search_bar.dart';
import 'create_ticket_screen.dart';
import 'ticket_details_screen.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketCubit>()..loadTickets(),
      child: const _TicketListView(),
    );
  }
}

class _TicketListView extends StatelessWidget {
  const _TicketListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support Tickets')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            const TicketSearchBar(),
            const TicketFilterBar(),
            SizedBox(height: 4.h),
            Expanded(
              child: BlocBuilder<TicketCubit, TicketState>(
                builder: (context, state) {
                  return switch (state) {
                    TicketInitial() || TicketLoading() =>
                      const LoadingIndicator(),
                    TicketError(:final message) => EmptyState(
                      message: message,
                      icon: Icons.error_outline,
                    ),
                    TicketLoaded() when state.visibleTickets.isEmpty =>
                      const EmptyState(message: 'No tickets found'),
                    TicketLoaded() => ListView.builder(
                      itemCount: state.visibleTickets.length,
                      itemBuilder: (context, index) {
                        final ticket = state.visibleTickets[index];
                        return TicketCard(
                          ticket: ticket,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TicketDetailsScreen(ticket: ticket),
                              ),
                            );
                            if (context.mounted) {
                              context.read<TicketCubit>().loadTickets();
                            }
                          },
                        );
                      },
                    ),
                  };
                },
              ),
            ),
          ],
        ),
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
