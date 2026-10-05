import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

class AppLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoading({
    Key? key,
    this.size = 36.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
        ),
      ),
    );
  }
}

class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }
}

class AppSkeletonCard extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const AppSkeletonCard({
    Key? key,
    this.height = 80.0,
    this.width,
    this.borderRadius = AppDimensions.radius12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: height,
        width: width ?? double.infinity,
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
