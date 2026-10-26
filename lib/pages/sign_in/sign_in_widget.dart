import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/main.dart';
import 'package:flutter/material.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});
  static String routeName = 'SignIn';
  static String routePath = '/signIn';
  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _showPassword = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final response = await LoginCall.call(
          email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      final body = response.jsonBody;
      final data = body is Map ? body['data'] : null;
      final token = data is Map ? data['token']?.toString() : null;
      final uid = data is Map ? data['user_id']?.toString() : null;
      if (!response.succeeded ||
          body is! Map ||
          body['success'] != true ||
          token == null ||
          token.trim().isEmpty ||
          uid == null ||
          uid.isEmpty) {
        setState(() => _error = response.statusCode == -1
            ? 'Connexion impossible. Vérifiez votre connexion internet et réessayez.'
            : response.statusCode == 401 || response.statusCode == 422
                ? 'Email ou mot de passe incorrect.'
                : 'Connexion impossible pour le moment. Veuillez réessayer.');
        return;
      }
      await authManager.signIn(authenticationToken: token, authUid: uid);
      FFAppState().token = token;
      FFAppState().email = data['email']?.toString() ?? _email.text.trim();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => NavBarPage(initialPage: 'Home')),
          (_) => false);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Connexion impossible. Veuillez réessayer.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    InputDecoration decoration(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Theme(
                data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(primary: theme.primary)),
                child: AutofillGroup(
                    child: Form(
                        key: _formKey,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Text('Connexion', style: theme.headlineMedium),
                          const SizedBox(height: 8),
                          Text('Connectez-vous à votre compte Outbuster.',
                              textAlign: TextAlign.center,
                              style: theme.bodyMedium),
                          const SizedBox(height: 28),
                          TextFormField(
                              key: const Key('sign-in-email'),
                              controller: _email,
                              enabled: !_busy,
                              autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              autocorrect: false,
                              decoration:
                                  decoration('Email', Icons.email_outlined),
                              validator: (value) =>
                                  RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                          .hasMatch(value?.trim() ?? '')
                                      ? null
                                      : 'Saisissez un email valide.'),
                          const SizedBox(height: 20),
                          TextFormField(
                              key: const Key('sign-in-password'),
                              controller: _password,
                              enabled: !_busy,
                              obscureText: !_showPassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _submit(),
                              decoration: decoration(
                                      'Mot de passe', Icons.lock_outline)
                                  .copyWith(
                                      suffixIcon: IconButton(
                                          tooltip: _showPassword
                                              ? 'Masquer le mot de passe'
                                              : 'Afficher le mot de passe',
                                          onPressed: () => setState(() =>
                                              _showPassword = !_showPassword),
                                          icon: Icon(_showPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility))),
                              validator: (value) => (value ?? '').isEmpty
                                  ? 'Saisissez votre mot de passe.'
                                  : null),
                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            Semantics(
                                liveRegion: true,
                                child: Text(_error!,
                                    style: TextStyle(color: theme.error)))
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                  onPressed: _busy ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primary,
                                      foregroundColor: Colors.black),
                                  child: _busy
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2))
                                      : const Text('Connexion'))),
                        ]))))),
      ))),
    );
  }
}
