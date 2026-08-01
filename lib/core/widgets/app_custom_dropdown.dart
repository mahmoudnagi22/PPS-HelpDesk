import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppCustomDropdown<T> extends StatelessWidget {
  const AppCustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(10.r),
          style: AppTextStyles.body,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabelBuilder(item)),
                ),
              )
              .toList(),
          onChanged: (item) {
            if (item != null) onChanged(item);
          },
        ),
      ),
    );
  }
}
