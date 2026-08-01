import 'package:flutter/material.dart';

import '../../../../../core/services/app_toast.dart';
import '../../cubit/ticket_state.dart';
import 'pending_action.dart';

void handleTicketDetailsResult({
  required BuildContext context,
  required TicketState state,
  required PendingAction? pendingAction,
  required VoidCallback onError,
}) {
  if (pendingAction == null) return;

  if (state is TicketLoaded) {
    AppToast.success(
      pendingAction == PendingAction.save
          ? 'Ticket updated successfully'
          : 'Ticket deleted successfully',
    );
    Navigator.pop(context);
  } else if (state is TicketError) {
    AppToast.danger(state.message);
    onError();
  }
}
