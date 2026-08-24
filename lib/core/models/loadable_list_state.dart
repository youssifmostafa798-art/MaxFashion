class LoadableListState<T> {
  final List<T> items;
  final bool isLoading;
  final String? error;

  const LoadableListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get length => items.length;

  LoadableListState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return LoadableListState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  static Future<LoadableListState<T>> load<T>({
    required Future<List<T>> Function() loader,
    String? errorMessage,
  }) async {
    try {
      final items = await loader();
      return LoadableListState(items: items);
    } catch (_) {
      return LoadableListState(
        error: errorMessage,
      );
    }
  }
}
