import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';

enum ButtonVariant { primary, secondary, outlined, danger, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final double height;
  final ButtonVariant variant;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.variant = ButtonVariant.primary,
  }) : super(key: key);

  const AppButton.primary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? width,
    double height = AppDimensions.buttonHeight,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          isDisabled: isDisabled,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          width: width,
          height: height,
          variant: ButtonVariant.primary,
        );

  const AppButton.outlined({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? width,
    double height = AppDimensions.buttonHeight,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          isDisabled: isDisabled,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          width: width,
          height: height,
          variant: ButtonVariant.outlined,
        );

  const AppButton.danger({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? width,
    double height = AppDimensions.buttonHeight,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          isDisabled: isDisabled,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          width: width,
          height: height,
          variant: ButtonVariant.danger,
        );

  @override
  Widget build(BuildContext context) {
    final effectiveDisabled = isDisabled || isLoading || onPressed == null;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = effectiveDisabled ? AppColors.primaryLight.withOpacity(0.5) : AppColors.primary;
        foregroundColor = Colors.white;
        break;
      case ButtonVariant.secondary:
        backgroundColor = effectiveDisabled ? AppColors.secondaryContainer.withOpacity(0.5) : AppColors.secondaryContainer;
        foregroundColor = AppColors.secondaryDark;
        break;
      case ButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = effectiveDisabled ? AppColors.textHint : AppColors.primary;
        borderSide = BorderSide(
          color: effectiveDisabled ? AppColors.border : AppColors.primary,
          width: 1.2,
        );
        break;
      case ButtonVariant.danger:
        backgroundColor = effectiveDisabled ? AppColors.error.withOpacity(0.4) : AppColors.error;
        foregroundColor = Colors.white;
        break;
      case ButtonVariant.text:
        backgroundColor = Colors.transparent;
        foregroundColor = effectiveDisabled ? AppColors.textHint : AppColors.primary;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        shape: borderSide != null
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
                side: borderSide,
              )
            : null,
        child: InkWell(
          onTap: effectiveDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: AppDimensions.space8),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.buttonText.copyWith(color: foregroundColor),
                      ),
                      if (suffixIcon != null) ...[
                        const SizedBox(width: AppDimensions.space8),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
