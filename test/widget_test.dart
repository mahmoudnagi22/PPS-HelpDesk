import 'package:flutter_test/flutter_test.dart';

import 'package:pps_helpe_desk/app.dart';
import 'package:pps_helpe_desk/core/services/service_locator.dart';
import 'package:pps_helpe_desk/features/tickets/domain/entities/ticket_entity.dart';
import 'package:pps_helpe_desk/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:pps_helpe_desk/features/tickets/presentation/cubit/ticket_cubit.dart';

class _FakeTicketRepository implements TicketRepository {
  @override
  Future<List<TicketEntity>> getTickets() async => [];

  @override
  Future<void> createTicket(TicketEntity ticket) async {}

  @override
  Future<void> updateTicket(TicketEntity ticket) async {}

  @override
  Future<void> deleteTicket(String id) async {}
}

void main() {
  setUp(() {
    sl.registerFactory<TicketCubit>(
      () => TicketCubit(_FakeTicketRepository()),
    );
  });

  tearDown(() => sl.reset());

  testWidgets('HelpDeskApp renders the dashboard summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HelpDeskApp());
    await tester.pumpAndSettle();

    expect(find.text('PPS HelpDesk'), findsOneWidget);
    expect(find.text('Total Tickets'), findsOneWidget);
    expect(find.text('No tickets yet'), findsOneWidget);
  });
}
