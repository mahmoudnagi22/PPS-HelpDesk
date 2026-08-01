import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/ticket_cubit.dart';

class TicketSearchBar extends StatelessWidget {
  const TicketSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: AppTextField(
        hintText: 'Search tickets...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        onChanged: (query) => context.read<TicketCubit>().searchTickets(query),
      ),
    );
  }
}
