import 'package:flutter_test/flutter_test.dart';

import 'package:pps_helpe_desk/app.dart';

void main() {
  testWidgets('HelpDeskApp renders the dashboard placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HelpDeskApp());

    expect(find.text('Tickets Dashboard'), findsOneWidget);
  });
}
