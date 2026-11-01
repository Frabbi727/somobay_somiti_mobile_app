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
///
/// Controlled field: the `value` argument is the source of truth. The picker calls [onChanged] when
/// the user chooses, and the parent must feed that choice back as `value` (e.g. an `Obx` passing the
/// Rx selection). On every rebuild the field shows `value`; a `value` of null, such as when a parent
/// choice changes, clears the field and its validation error. A choice the parent does not feed back
/// is reverted on the next rebuild.
class AppSearchablePicker<T> extends FormField<T> {
  AppSearchablePicker({
    super.key,
    required String label,
    required this.items,
    required this.itemLabel,
    required this.searchTerms,
    required this.onChanged,
    T? value,
    this.keyPrefix = 'picker',
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
                  key: Key('${keyPrefix}_field'),
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

  /// Prefix of the keys `<prefix>_field` and `<prefix>_search`; give each picker on a screen its own.
  final String keyPrefix;
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
    // The Form must not be notified during a build, so the field follows after this frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      // `value` is the source of truth: whenever it differs from what the field shows (a parent reset,
      // or a choice the parent did not accept), the field follows it and drops any stale error.
      if (widget.initialValue != value) {
        reset();
      }
      // The sheet lives in another route, so it is refreshed here too, not during the build.
      _sheetSetState?.call(() {});
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
                      key: Key('${widget.keyPrefix}_search'),
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
