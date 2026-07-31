import '../entities/ticket_entity.dart';

abstract class TicketRepository {
  Future<List<TicketEntity>> getTickets();

  Future<void> createTicket(TicketEntity ticket);

  Future<void> updateTicket(TicketEntity ticket);

  Future<void> deleteTicket(String id);
}
