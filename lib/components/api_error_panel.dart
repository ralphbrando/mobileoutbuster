import '/auth/custom_auth/auth_util.dart';
import '/app_state.dart';
import '/backend/api_requests/api_calls.dart';
import '/pages/sign_in/sign_in_widget.dart';
import 'package:flutter/material.dart';

class ApiErrorPanel extends StatelessWidget {
  const ApiErrorPanel(
      {super.key, required this.response, required this.onRetry});
  final ApiCallResponse response;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final expired = response.statusCode == 401;
    return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
              expired
                  ? 'Votre session a expiré. Reconnectez-vous.'
                  : 'Chargement impossible. Vérifiez votre connexion et réessayez.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          TextButton(
              onPressed: expired
                  ? () async {
                      await authManager.signOut();
                      FFAppState().token = '';
                      FFAppState().email = '';
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const SignInWidget()),
                          (_) => false);
                    }
                  : onRetry,
              child: Text(expired ? 'Se reconnecter' : 'Réessayer')),
        ]));
  }
}
