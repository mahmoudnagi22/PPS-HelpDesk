import 'package:hive/hive.dart';

import '../models/ticket_model.dart';

abstract class TicketLocalDataSource {
  Future<List<TicketModel>> getTickets();

  Future<void> saveTicket(TicketModel model);

  Future<void> deleteTicket(String id);
}

class TicketLocalDataSourceImpl implements TicketLocalDataSource {
  TicketLocalDataSourceImpl(this._box);

  final Box<TicketModel> _box;

  @override
  Future<List<TicketModel>> getTickets() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveTicket(TicketModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteTicket(String id) async {
    await _box.delete(id);
  }
}
