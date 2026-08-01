import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/enums.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../domain/entities/ticket_entity.dart';
import '../../cubit/ticket_cubit.dart';
import '../../cubit/ticket_state.dart';
import '../utils/handle_ticket_result.dart';
import '../utils/pending_action.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/ticket_details_body.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({super.key, required this.ticket});

  final TicketEntity ticket;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketCubit>(),
      child: _TicketDetailsForm(ticket: ticket),
    );
  }
}

class _TicketDetailsForm extends StatefulWidget {
  const _TicketDetailsForm({required this.ticket});

  final TicketEntity ticket;

  @override
  State<_TicketDetailsForm> createState() => _TicketDetailsFormState();
}

class _TicketDetailsFormState extends State<_TicketDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;

  late TicketStatus _status;
  late TicketPriority _priority;
  PendingAction? _pendingAction;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.ticket.subject);
    _descriptionController = TextEditingController(
      text: widget.ticket.description,
    );
    _status = widget.ticket.status;
    _priority = widget.ticket.priority;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.ticket.copyWith(
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _status,
      priority: _priority,
    );

    setState(() => _pendingAction = PendingAction.save);
    context.read<TicketCubit>().updateTicket(updated);
  }

  Future<void> _delete() async {
    final confirmed = await showDeleteConfirmationDialog(context);
    if (confirmed == true && mounted) {
      setState(() => _pendingAction = PendingAction.delete);
      context.read<TicketCubit>().deleteTicket(widget.ticket.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Details')),
      body: BlocConsumer<TicketCubit, TicketState>(
        listener: (context, state) => handleTicketDetailsResult(
          context: context,
          state: state,
          pendingAction: _pendingAction,
          onError: () => setState(() => _pendingAction = null),
        ),
        builder: (context, state) {
          final isBusy = state is TicketLoading && _pendingAction != null;

          return TicketDetailsBody(
            formKey: _formKey,
            ticket: widget.ticket,
            subjectController: _subjectController,
            descriptionController: _descriptionController,
            status: _status,
            priority: _priority,
            onStatusChanged: (value) => setState(() => _status = value),
            onPriorityChanged: (value) => setState(() => _priority = value),
            isSaving: isBusy && _pendingAction == PendingAction.save,
            isDeleting: isBusy && _pendingAction == PendingAction.delete,
            onSave: isBusy ? null : _save,
            onDelete: isBusy ? null : _delete,
          );
        },
      ),
    );
  }
}
