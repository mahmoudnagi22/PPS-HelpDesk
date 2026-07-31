import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/enums.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/ticket_repository.dart';
import 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  TicketCubit(this._repository) : super(const TicketInitial());

  final TicketRepository _repository;

  Future<void> loadTickets() async {
    emit(const TicketLoading());
    try {
      final tickets = await _repository.getTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (error) {
      emit(TicketError(error.toString()));
    }
  }

  Future<void> createTicket(TicketEntity ticket) async {
    try {
      await _repository.createTicket(ticket);
      await loadTickets();
    } catch (error) {
      emit(TicketError(error.toString()));
    }
  }

  Future<void> updateTicket(TicketEntity ticket) async {
    try {
      await _repository.updateTicket(ticket);
      await loadTickets();
    } catch (error) {
      emit(TicketError(error.toString()));
    }
  }

  Future<void> deleteTicket(String id) async {
    try {
      await _repository.deleteTicket(id);
      await loadTickets();
    } catch (error) {
      emit(TicketError(error.toString()));
    }
  }

  void searchTickets(String query) {
    final currentState = state;
    if (currentState is TicketLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  void filterByStatus(TicketStatus? status) {
    final currentState = state;
    if (currentState is TicketLoaded) {
      emit(currentState.copyWith(statusFilter: () => status));
    }
  }

  void filterByPriority(TicketPriority? priority) {
    final currentState = state;
    if (currentState is TicketLoaded) {
      emit(currentState.copyWith(priorityFilter: () => priority));
    }
  }

  void sortByDate({required bool ascending}) {
    final currentState = state;
    if (currentState is TicketLoaded) {
      emit(currentState.copyWith(sortAscending: ascending));
    }
  }
}
