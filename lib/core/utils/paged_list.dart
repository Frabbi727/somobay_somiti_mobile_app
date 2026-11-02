import 'package:get/get.dart';
import '../errors/failures.dart';
import '../models/pagination_model.dart';

/// One page from a repository, as every paginated member endpoint returns it.
typedef PageResult<T> = ({Failure? failure, List<T> items, PaginationMeta? meta});

/// Loads a paginated API list page by page (20 per page, as the backend sends). Holds the items
/// and loading/error state as Rx values so a controller can expose it to the view directly.
class PagedList<T> {
  final Future<PageResult<T>> Function(int page) load;

  final items = <T>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final _failure = Rxn<Failure>();

  int _page = 0;
  int _lastPage = 1;

  PagedList(this.load);

  Failure? get failure => _failure.value;

  bool get hasMore => _page < _lastPage;

  Future<void> refresh() async {
    isLoading.value = true;
    _failure.value = null;
    final result = await load(1);
    isLoading.value = false;

    if (result.failure != null) {
      _failure.value = result.failure;
      return;
    }

    items.assignAll(result.items);
    _page = 1;
    _lastPage = result.meta?.lastPage ?? 1;
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoading.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    final result = await load(_page + 1);
    isLoadingMore.value = false;

    if (result.failure != null) {
      _failure.value = result.failure;
      return;
    }

    items.addAll(result.items);
    _page++;
    _lastPage = result.meta?.lastPage ?? _page;
  }
}
