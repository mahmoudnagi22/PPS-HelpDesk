import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/enums.dart';
import '../../../domain/entities/ticket_entity.dart';
import '../../shared/widgets/ticket_text_fields_section.dart';
import 'ticket_details_actions.dart';
import 'ticket_details_header.dart';
import 'ticket_priority_selector.dart';
import 'ticket_status_selector.dart';

class TicketDetailsBody extends StatelessWidget {
  const TicketDetailsBody({
    super.key,
    required this.formKey,
    required this.ticket,
    required this.subjectController,
    required this.descriptionController,
    required this.status,
    required this.priority,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.isSaving,
    required this.isDeleting,
    required this.onSave,
    required this.onDelete,
  });

  final GlobalKey<FormState> formKey;
  final TicketEntity ticket;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final TicketStatus status;
  final TicketPriority priority;
  final ValueChanged<TicketStatus> onStatusChanged;
  final ValueChanged<TicketPriority> onPriorityChanged;
  final bool isSaving;
  final bool isDeleting;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TicketDetailsHeader(
              ticketId: ticket.id,
              createdAt: ticket.createdAt,
              status: status,
              priority: priority,
            ),
            SizedBox(height: 20.h),
            TicketTextFieldsSection(
              subjectController: subjectController,
              descriptionController: descriptionController,
            ),
            SizedBox(height: 20.h),
            TicketStatusSelector(value: status, onChanged: onStatusChanged),
            SizedBox(height: 20.h),
            TicketPrioritySelector(
              value: priority,
              onChanged: onPriorityChanged,
            ),
            SizedBox(height: 32.h),
            TicketDetailsActions(
              isSaving: isSaving,
              isDeleting: isDeleting,
              onSave: onSave,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
