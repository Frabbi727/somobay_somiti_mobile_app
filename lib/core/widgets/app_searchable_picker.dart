import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/localization/translation_keys.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../errors/failures.dart';
import '../utils/bangla_number_util.dart';
import 'app_empty_state.dart';
import 'app_error_state.dart';

/// A form field that opens a bottom sheet with a search box and the list of [items].
/// Search is a case-insensitive "contains" on any of [searchTerms]; Bangla digits match English ones.
class AppSearchablePicker<T> extends FormField<T> {
  AppSearchablePicker({
    super.key,
    required String label,
    required this.items,
    required this.itemLabel,
    required this.searchTerms,
    required this.onChanged,
    T? value,
    String? hint,
    bool isRequired = false,
    super.enabled = true,
    this.isLoading = false,
    this.failure,
    this.onRetry,
    super.validator,
  }) : super(
          initialValue: value,
          builder: (field) {
            final state = field as _AppSearchablePickerState<T>;
            final selected = field.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(label, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 13)),
                    if (isRequired) Text(' *', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: AppDimensions.space8),
                InkWell(
                  key: const Key('picker_field'),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  onTap: field.widget.enabled ? state.openSheet : null,
                  child: InputDecorator(
                    isEmpty: false,
                    decoration: InputDecoration(
                      enabled: field.widget.enabled,
                      errorText: field.errorText,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: isLoading
                          ? const Padding(padding: EdgeInsets.all(14), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)))
                          : const Icon(Icons.arrow_drop_down_rounded),
                    ),
                    child: Text(
                      selected == null ? (hint ?? TranslationKeys.geoSelect.tr) : itemLabel(selected),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(color: selected == null || !field.widget.enabled ? AppColors.textHint : AppColors.textPrimary),
                    ),
                  ),
                ),
              ],
            );
          },
        );

  final List<T> items;
  final String Function(T item) itemLabel;

  /// Every name an item can be found by (for places: the Bangla and the English name).
  final List<String> Function(T item) searchTerms;
  final ValueChanged<T?> onChanged;

  // `enabled` (inherited) is false until the parent choice is made.

  final bool isLoading;
  final Failure? failure;
  final VoidCallback? onRetry;

  /// Whether [item] matches [query]; an empty query matches everything.
  bool matches(T item, String query) {
    final needle = _normalize(query);
    if (needle.isEmpty) {
      return true;
    }
    return searchTerms(item).any((term) => _normalize(term).contains(needle));
  }

  static String _normalize(String text) => BanglaNumberUtil.toEnglish(text).trim().toLowerCase();

  @override
  FormFieldState<T> createState() => _AppSearchablePickerState<T>();
}

class _AppSearchablePickerState<T> extends FormFieldState<T> {
  StateSetter? _sheetSetState;
  final TextEditingController _searchController = TextEditingController();

  @override
  AppSearchablePicker<T> get widget => super.widget as AppSearchablePicker<T>;

  @override
  void didUpdateWidget(covariant AppSearchablePicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A parent change can reset the choice (value: null) or replace the list (retry finished).
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != value) {
      setValue(widget.initialValue);
    }
    // The sheet lives in another route, so it is refreshed after this build, not during it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sheetSetState?.call(() {});
      }
    });
  }

  Future<void> openSheet() async {
    _searchController.clear();
    var query = '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radius16))),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          _sheetSetState = setSheetState;
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    child: TextField(
                      key: const Key('picker_search'),
                      controller: _searchController,
                      autofocus: false,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: TranslationKeys.geoSearchHint.tr,
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      ),
                      onChanged: (text) => setSheetState(() => query = text),
                    ),
                  ),
                  Expanded(child: _body(sheetContext, query)),
                ],
              ),
            ),
          );
        },
      ),
    );

    _sheetSetState = null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext sheetContext, String query) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.failure != null) {
      return AppErrorState(failure: widget.failure, onRetry: widget.onRetry);
    }
    if (widget.items.isEmpty) {
      return AppEmptyState(title: TranslationKeys.geoEmptyList.tr, icon: Icons.location_off_outlined);
    }

    final shown = widget.items.where((item) => widget.matches(item, query)).toList();
    if (shown.isEmpty) {
      return AppEmptyState(title: TranslationKeys.geoNoMatch.tr, icon: Icons.search_off_rounded);
    }

    return ListView.builder(
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final item = shown[index];
        return ListTile(
          title: Text(widget.itemLabel(item), style: AppTextStyles.bodyMedium),
          selected: item == value,
          onTap: () {
            didChange(item);
            widget.onChanged(item);
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }
}
