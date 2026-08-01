import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class EnumChoiceRow<T> extends StatelessWidget {
  const EnumChoiceRow({
    super.key,
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
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
