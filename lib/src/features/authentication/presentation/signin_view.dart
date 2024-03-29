import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../utils/colors.dart';
import '../../core/error_handling/logger.dart';
import '../../core/error_handling/snackbar_controller.dart';
import '../domain/auth_controller.dart';
import '../domain/form_controller.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends ConsumerState<SignInView> {
  late bool isNotVisible;
  late bool isFieldsEnabled;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final Logger _logger;

  @override
  void initState() {
    super.initState();
    isNotVisible = true;
    isFieldsEnabled = true;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _logger = getLogger(SignInView);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    snackbarDisplayer(context, ref);
    _logger.d('build');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              AppLocalizations.of(context)!.signIn,
              style: const TextStyle(fontSize: 46),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 11,
            ),
            Consumer(
              builder: (
                final BuildContext context,
                final WidgetRef ref,
                final Widget? child,
              ) {
                return TextField(
                  controller: _emailController,
                  enabled: isFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterEmail,
                    errorText: ref.watch(
                      emailControllerProvider.select(
                        (final FieldItemState value) => value.errorText,
                      ),
                    ),
                  ),
                  onChanged: (final String value) => ref
                      .read(
                        emailControllerProvider.notifier,
                      )
                      .onEmailChange(value),
                );
              },
            ),
            const SizedBox(
              height: 26,
            ),
            Consumer(
              builder: (
                final BuildContext context,
                final WidgetRef ref,
                final Widget? child,
              ) {
                return TextField(
                  controller: _passwordController,
                  obscureText: isNotVisible,
                  enabled: isFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterPassword,
                    errorText: ref.watch(
                      passwordControllerProvider.select(
                        (final FieldItemState value) => value.errorText,
                      ),
                    ),
                    suffixIcon: child,
                  ),
                  onChanged: (final String value) => ref
                      .read(passwordControllerProvider.notifier)
                      .onPasswordChange(value),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () {
                    setState(() => isNotVisible = !isNotVisible);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    !isNotVisible ? Icons.visibility_off : Icons.visibility,
                    color: detailColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            Consumer(
              builder: (
                final BuildContext context,
                final WidgetRef ref,
                final Widget? child,
              ) =>
                  ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isFieldsEnabled = false;
                  });
                  await ref.read(authControllerProvider).signInUser();
                  setState(() {
                    isFieldsEnabled = true;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: child,
              ),
              child: Text(AppLocalizations.of(context)!.signIn),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {
                context.go('/recover-password');
                ref
                  ..invalidate(emailControllerProvider)
                  ..invalidate(passwordControllerProvider);
              },
              child: Text(
                AppLocalizations.of(context)!.recoverPassword,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.noAccount,
                  style: const TextStyle(fontSize: 16),
                ),
                Consumer(
                  builder: (
                    final BuildContext context,
                    final WidgetRef ref,
                    final Widget? child,
                  ) =>
                      TextButton(
                    onPressed: () async {
                      if (context.mounted) {
                        context.go('/signup');
                      }
                      ref
                        ..invalidate(emailControllerProvider)
                        ..invalidate(passwordControllerProvider);
                    },
                    child: child!,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.signUp,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
