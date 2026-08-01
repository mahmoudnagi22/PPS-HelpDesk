import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/ticket_entity.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';
import '../widgets/priority_badge.dart';
import '../widgets/status_chip.dart';

String _statusLabel(TicketStatus status) {
  switch (status) {
    case TicketStatus.open:
      return 'Open';
    case TicketStatus.inProgress:
      return 'In Progress';
    case TicketStatus.closed:
      return 'Closed';
  }
}

String _priorityLabel(TicketPriority priority) {
  switch (priority) {
    case TicketPriority.low:
      return 'Low';
    case TicketPriority.medium:
      return 'Medium';
    case TicketPriority.high:
      return 'High';
  }
}

enum _PendingAction { save, delete }

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
  _PendingAction? _pendingAction;

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

    setState(() => _pendingAction = _PendingAction.save);
    context.read<TicketCubit>().updateTicket(updated);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Ticket'),
        content: const Text('Are you sure you want to delete this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _pendingAction = _PendingAction.delete);
      context.read<TicketCubit>().deleteTicket(widget.ticket.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Details')),
      body: BlocConsumer<TicketCubit, TicketState>(
        listener: (context, state) {
          if (_pendingAction == null) return;

          if (state is TicketLoaded) {
            final message = _pendingAction == _PendingAction.save
                ? 'Ticket updated successfully'
                : 'Ticket deleted successfully';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
            Navigator.pop(context);
          } else if (state is TicketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
            setState(() => _pendingAction = null);
          }
        },
        builder: (context, state) {
          final isBusy = state is TicketLoading && _pendingAction != null;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${widget.ticket.id}',
                        style: AppTextStyles.heading2,
                      ),
                      Text(
                        DateFormatter.toReadableDate(widget.ticket.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      StatusChip(status: _status),
                      SizedBox(width: 8.w),
                      PriorityBadge(priority: _priority),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text('Subject', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _subjectController,
                    validator: (value) =>
                        Validators.requiredField(value, 'Subject'),
                  ),
                  SizedBox(height: 20.h),
                  Text('Description', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    validator: (value) =>
                        Validators.requiredField(value, 'Description'),
                  ),
                  SizedBox(height: 20.h),
                  Text('Status', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  _ChoiceRow<TicketStatus>(
                    values: TicketStatus.values,
                    selected: _status,
                    labelBuilder: _statusLabel,
                    onSelected: (value) => setState(() => _status = value),
                  ),
                  SizedBox(height: 20.h),
                  Text('Priority', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  _ChoiceRow<TicketPriority>(
                    values: TicketPriority.values,
                    selected: _priority,
                    labelBuilder: _priorityLabel,
                    onSelected: (value) => setState(() => _priority = value),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Save Changes',
                      isLoading:
                          isBusy && _pendingAction == _PendingAction.save,
                      onPressed: isBusy ? null : _save,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isBusy ? null : _confirmDelete,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child:
                          isBusy && _pendingAction == _PendingAction.delete
                          ? SizedBox(
                              height: 18.h,
                              width: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.danger,
                                ),
                              ),
                            )
                          : const Text('Delete Ticket'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
    super.key,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: values.map((value) {
        final isSelected = value == selected;
        return ChoiceChip(
          label: Text(labelBuilder(value)),
          selected: isSelected,
          onSelected: (_) => onSelected(value),
          labelStyle: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.surface : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
      }).toList(),
    );
  }
}
