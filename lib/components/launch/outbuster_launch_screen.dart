import 'package:flutter/material.dart';

/// Shared artwork for the initial Flutter frame and the welcome screen.
/// The OS splash uses the same dark background and wordmark while Flutter loads.
class OutbusterLaunchScreen extends StatelessWidget {
  const OutbusterLaunchScreen({super.key, this.onStart});

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08090B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/branding/cinema-background.png',
              fit: BoxFit.cover, excludeFromSemantics: true),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x0008090B), Color(0xCC08090B)],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              final compact = constraints.maxHeight < 460;
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 28, vertical: compact ? 16 : 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (onStart != null) const Spacer(flex: 3),
                        Semantics(
                          label: 'Outbuster, l’autre cinéma',
                          image: true,
                          child: Image.asset('assets/branding/splash-logo.png',
                              width: 340, excludeFromSemantics: true),
                        ),
                        if (onStart != null) ...[
                          const Spacer(flex: 2),
                          const Text(
                            'La plateforme des cinéphiles curieux.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.45,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: compact ? 18 : 30),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: onStart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDFFF00),
                                foregroundColor: const Color(0xFF08090B),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Démarrer',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
