import '/components/launch/outbuster_launch_screen.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/main.dart';
import '/pages/sign_in/sign_in_widget.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});
  static String routeName = 'Onboarding';
  static String routePath = '/onboarding';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && FFAppState().token.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NavBarPage(initialPage: 'Home')));
      }
    });
  }

  @override
  Widget build(BuildContext context) => OutbusterLaunchScreen(
        onStart: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignInWidget())),
      );
}
