import 'package:flutter/material.dart';
import 'app_loading.dart';
import 'app_empty_state.dart';
import 'app_error_state.dart';
import '../errors/failures.dart';

class AppPaginationView<T> extends StatefulWidget {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? emptyWidget;
  final EdgeInsets? padding;

  const AppPaginationView({
    Key? key,
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    this.failure,
    required this.onRefresh,
    required this.onLoadMore,
    required this.itemBuilder,
    this.emptyWidget,
    this.padding,
  }) : super(key: key);

  @override
  State<AppPaginationView<T>> createState() => _AppPaginationViewState<T>();
}

class _AppPaginationViewState<T> extends State<AppPaginationView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!widget.isLoading && !widget.isLoadingMore && widget.hasMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.items.isEmpty) {
      return const AppLoading();
    }

    if (widget.failure != null && widget.items.isEmpty) {
      return AppErrorState(
        failure: widget.failure,
        onRetry: widget.onRefresh,
      );
    }

    if (widget.items.isEmpty) {
      return widget.emptyWidget ??
          AppEmptyState(
            onAction: widget.onRefresh,
            actionText: 'Retry',
          );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding ?? const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return widget.itemBuilder(context, widget.items[index], index);
        },
      ),
    );
  }
}
