import '../../../../core/constants/enums.dart';
import '../../domain/entities/ticket_entity.dart';

sealed class TicketState {
  const TicketState();
}

class TicketInitial extends TicketState {
  const TicketInitial();
}

class TicketLoading extends TicketState {
  const TicketLoading();
}

class TicketLoaded extends TicketState {
  const TicketLoaded({
    required this.tickets,
    this.searchQuery = '',
    this.statusFilter,
    this.priorityFilter,
    this.sortAscending = false,
  });

  final List<TicketEntity> tickets;
  final String searchQuery;
  final TicketStatus? statusFilter;
  final TicketPriority? priorityFilter;
  final bool sortAscending;

  List<TicketEntity> get visibleTickets {
    var result = tickets.where((ticket) {
      final matchesQuery =
          searchQuery.isEmpty ||
          ticket.subject.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus =
          statusFilter == null || ticket.status == statusFilter;
      final matchesPriority =
          priorityFilter == null || ticket.priority == priorityFilter;
      return matchesQuery && matchesStatus && matchesPriority;
    }).toList();

    result.sort(
      (a, b) => sortAscending
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt),
    );

    return result;
  }

  TicketLoaded copyWith({
    List<TicketEntity>? tickets,
    String? searchQuery,
    TicketStatus? Function()? statusFilter,
    TicketPriority? Function()? priorityFilter,
    bool? sortAscending,
  }) {
    return TicketLoaded(
      tickets: tickets ?? this.tickets,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      priorityFilter: priorityFilter != null
          ? priorityFilter()
          : this.priorityFilter,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

class TicketError extends TicketState {
  const TicketError(this.message);

  final String message;
}
