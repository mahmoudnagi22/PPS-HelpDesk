String generateTicketId() {
  return '#TICK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
}
