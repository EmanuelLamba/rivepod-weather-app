import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/core/notifications/domain/notifications_controller.dart';
import 'routing/app_router.dart';
import 'utils/colors.dart' as colors;
import 'utils/decorated_input_border.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.watch(notificationsControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Riverpod Weather App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: colors.primaryColor,
        fontFamily: 'OpenSans',
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.fromLTRB(30, 16, 40, 16),
          filled: true,
          fillColor: colors.primaryColor900,
          border: DecoratedInputBorder(
            shadow: const BoxShadow(
              color: Color(0xFFC0C0C0),
              blurRadius: 15,
              offset: Offset(0, 3),
            ),
            child: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.read(routerProvider),
    );
  }
}
