import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  const ResponsiveScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1024;

    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 800 : (isTablet ? 600 : size.width),
        ),
        child: child,
      ),
    );
  }
}
