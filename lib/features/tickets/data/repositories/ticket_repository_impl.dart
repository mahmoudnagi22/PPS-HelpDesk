import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_local_data_source.dart';
import '../models/ticket_model.dart';

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(this._localDataSource);

  final TicketLocalDataSource _localDataSource;

  @override
  Future<List<TicketEntity>> getTickets() async {
    final models = await _localDataSource.getTickets();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createTicket(TicketEntity ticket) async {
    await _localDataSource.saveTicket(TicketModel.fromEntity(ticket));
  }

  @override
  Future<void> updateTicket(TicketEntity ticket) async {
    await _localDataSource.saveTicket(TicketModel.fromEntity(ticket));
  }

  @override
  Future<void> deleteTicket(String id) async {
    await _localDataSource.deleteTicket(id);
  }
}
