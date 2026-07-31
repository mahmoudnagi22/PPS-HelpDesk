import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_text_styles.dart';

class HelpDeskApp extends StatelessWidget {
  const HelpDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'PPS HelpDesk',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const _DashboardPlaceholder(),
        );
      },
    );
  }
}

class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PPS HelpDesk')),
      body: Center(
        child: Text('Tickets Dashboard', style: AppTextStyles.heading1),
      ),
    );
  }
}
