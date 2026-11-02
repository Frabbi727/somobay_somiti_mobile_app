import 'package:flutter/material.dart';

/// The society's logo (assets/images/logo.jpg), clipped to a circle.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset('assets/images/logo.jpg', width: size, height: size, fit: BoxFit.cover),
    );
  }
}
