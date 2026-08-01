import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/enums.dart';
import '../../../../../core/services/app_toast.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../domain/entities/ticket_entity.dart';
import '../../cubit/ticket_cubit.dart';
import '../../cubit/ticket_state.dart';
import '../../shared/utils/ticket_id_generator.dart';
import '../../shared/widgets/ticket_text_fields_section.dart';
import '../widgets/submit_ticket_button.dart';
import '../widgets/ticket_category_selector.dart';
import '../widgets/ticket_priority_selector.dart';

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

    final ticket = TicketEntity(
      id: generateTicketId(),
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
            AppToast.success('Ticket created successfully');
            Navigator.pop(context);
          } else if (state is TicketError) {
            AppToast.danger(state.message);
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
                  TicketTextFieldsSection(
                    subjectController: _subjectController,
                    descriptionController: _descriptionController,
                    subjectHint: 'Brief summary of the issue',
                    descriptionHint: 'Describe the issue in detail',
                  ),
                  SizedBox(height: 20.h),
                  TicketPrioritySelector(
                    value: _priority,
                    onChanged: (value) => setState(() => _priority = value),
                  ),
                  SizedBox(height: 20.h),
                  TicketCategorySelector(
                    value: _category,
                    onChanged: (value) => setState(() => _category = value),
                  ),
                  SizedBox(height: 32.h),
                  SubmitTicketButton(
                    isLoading: isSubmitting,
                    onPressed: isSubmitting ? null : _submit,
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
