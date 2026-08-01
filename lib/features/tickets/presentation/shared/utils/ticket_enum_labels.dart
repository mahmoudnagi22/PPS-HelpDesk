import '../../../../../core/constants/enums.dart';

String ticketStatusLabel(TicketStatus status) {
  switch (status) {
    case TicketStatus.open:
      return 'Open';
    case TicketStatus.inProgress:
      return 'In Progress';
    case TicketStatus.closed:
      return 'Closed';
  }
}

String ticketPriorityLabel(TicketPriority priority) {
  switch (priority) {
    case TicketPriority.low:
      return 'Low';
    case TicketPriority.medium:
      return 'Medium';
    case TicketPriority.high:
      return 'High';
  }
}

String ticketCategoryLabel(TicketCategory category) {
  switch (category) {
    case TicketCategory.technical:
      return 'Technical';
    case TicketCategory.billing:
      return 'Billing';
    case TicketCategory.general:
      return 'General';
  }
}
