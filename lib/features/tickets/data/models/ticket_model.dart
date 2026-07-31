import 'package:hive/hive.dart';

import '../../../../core/constants/enums.dart';
import '../../domain/entities/ticket_entity.dart';

part 'ticket_model.g.dart';

@HiveType(typeId: 0)
class TicketModel extends HiveObject {
  TicketModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.priorityIndex,
    required this.categoryIndex,
    required this.statusIndex,
    required this.createdAtIso,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subject;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int priorityIndex;

  @HiveField(4)
  final int categoryIndex;

  @HiveField(5)
  final int statusIndex;

  @HiveField(6)
  final String createdAtIso;

  TicketEntity toEntity() {
    return TicketEntity(
      id: id,
      subject: subject,
      description: description,
      priority: TicketPriority.values[priorityIndex],
      category: TicketCategory.values[categoryIndex],
      status: TicketStatus.values[statusIndex],
      createdAt: DateTime.parse(createdAtIso),
    );
  }

  static TicketModel fromEntity(TicketEntity entity) {
    return TicketModel(
      id: entity.id,
      subject: entity.subject,
      description: entity.description,
      priorityIndex: entity.priority.index,
      categoryIndex: entity.category.index,
      statusIndex: entity.status.index,
      createdAtIso: entity.createdAt.toIso8601String(),
    );
  }
}
