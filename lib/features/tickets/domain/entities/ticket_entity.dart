import '../../../../core/constants/enums.dart';

class TicketEntity {
  const TicketEntity({
    required this.id,
    required this.subject,
    required this.description,
    required this.priority,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String subject;
  final String description;
  final TicketPriority priority;
  final TicketCategory category;
  final TicketStatus status;
  final DateTime createdAt;

  TicketEntity copyWith({
    String? id,
    String? subject,
    String? description,
    TicketPriority? priority,
    TicketCategory? category,
    TicketStatus? status,
    DateTime? createdAt,
  }) {
    return TicketEntity(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TicketEntity &&
        other.id == id &&
        other.subject == subject &&
        other.description == description &&
        other.priority == priority &&
        other.category == category &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      subject,
      description,
      priority,
      category,
      status,
      createdAt,
    );
  }
}
