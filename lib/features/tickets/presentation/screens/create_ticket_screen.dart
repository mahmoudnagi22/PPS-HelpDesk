import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/ticket_entity.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';

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

String _categoryLabel(TicketCategory category) {
  switch (category) {
    case TicketCategory.technical:
      return 'Technical';
    case TicketCategory.billing:
      return 'Billing';
    case TicketCategory.general:
      return 'General';
  }
}

class CreateTicketScreen extends StatelessWidget {
  const CreateTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketCubit>(),
      child: const _CreateTicketForm(),
    );
  }
}

class _CreateTicketForm extends StatefulWidget {
  const _CreateTicketForm();

  @override
  State<_CreateTicketForm> createState() => _CreateTicketFormState();
}

class _CreateTicketFormState extends State<_CreateTicketForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  TicketPriority _priority = TicketPriority.low;
  TicketCategory _category = TicketCategory.technical;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final id =
        '#TICK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final ticket = TicketEntity(
      id: id,
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      category: _category,
      status: TicketStatus.open,
      createdAt: DateTime.now(),
    );

    context.read<TicketCubit>().createTicket(ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Ticket')),
      body: BlocConsumer<TicketCubit, TicketState>(
        listener: (context, state) {
          if (state is TicketLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ticket created successfully')),
            );
            Navigator.pop(context);
          } else if (state is TicketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is TicketLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _subjectController,
                    hintText: 'Brief summary of the issue',
                    validator: (value) =>
                        Validators.requiredField(value, 'Subject'),
                  ),
                  SizedBox(height: 20.h),
                  Text('Description', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  AppTextField(
                    controller: _descriptionController,
                    hintText: 'Describe the issue in detail',
                    maxLines: 5,
                    validator: (value) =>
                        Validators.requiredField(value, 'Description'),
                  ),
                  SizedBox(height: 20.h),
                  Text('Priority', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  _EnumDropdown<TicketPriority>(
                    value: _priority,
                    values: TicketPriority.values,
                    labelBuilder: _priorityLabel,
                    onChanged: (value) => setState(() => _priority = value),
                  ),
                  SizedBox(height: 20.h),
                  Text('Category', style: AppTextStyles.heading2),
                  SizedBox(height: 8.h),
                  _EnumDropdown<TicketCategory>(
                    value: _category,
                    values: TicketCategory.values,
                    labelBuilder: _categoryLabel,
                    onChanged: (value) => setState(() => _category = value),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Submit Ticket',
                      isLoading: isSubmitting,
                      onPressed: isSubmitting ? null : _submit,
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

class _EnumDropdown<T> extends StatelessWidget {
  const _EnumDropdown({
    required this.value,
    required this.values,
    required this.labelBuilder,
    required this.onChanged,
    super.key,
  });

  final T value;
  final List<T> values;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: values
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            ),
          )
          .toList(),
      onChanged: (item) {
        if (item != null) onChanged(item);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
