import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PetFitApp extends StatelessWidget {
  const PetFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetFit AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
