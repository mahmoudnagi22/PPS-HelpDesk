import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/enums.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';

class TicketFilterBar extends StatelessWidget {
  const TicketFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TicketCubit>().state;
    if (state is! TicketLoaded) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChoiceChip(
                    label: 'All',
                    selected: state.statusFilter == null,
                    onSelected: () =>
                        context.read<TicketCubit>().filterByStatus(null),
                  ),
                  SizedBox(width: 8.w),
                  _StatusChoiceChip(
                    label: 'Open',
                    selected: state.statusFilter == TicketStatus.open,
                    onSelected: () => context
                        .read<TicketCubit>()
                        .filterByStatus(TicketStatus.open),
                  ),
                  SizedBox(width: 8.w),
                  _StatusChoiceChip(
                    label: 'In Progress',
                    selected: state.statusFilter == TicketStatus.inProgress,
                    onSelected: () => context
                        .read<TicketCubit>()
                        .filterByStatus(TicketStatus.inProgress),
                  ),
                  SizedBox(width: 8.w),
                  _StatusChoiceChip(
                    label: 'Closed',
                    selected: state.statusFilter == TicketStatus.closed,
                    onSelected: () => context
                        .read<TicketCubit>()
                        .filterByStatus(TicketStatus.closed),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              state.sortAscending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: AppColors.primary,
            ),
            tooltip: state.sortAscending ? 'Oldest first' : 'Newest first',
            onPressed: () => context
                .read<TicketCubit>()
                .sortByDate(ascending: !state.sortAscending),
          ),
        ],
      ),
    );
  }
}

class _StatusChoiceChip extends StatelessWidget {
  const _StatusChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: AppTextStyles.caption.copyWith(
        color: selected ? AppColors.surface : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}
