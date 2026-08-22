import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthState {
  final String? userId;
  const FakeAuthState(this.userId);
}

class FakeAuthNotifier extends StateNotifier<FakeAuthState> {
  FakeAuthNotifier() : super(const FakeAuthState(null));

  void signIn(String id) => state = FakeAuthState(id);
}

class LoadState {
  final List<String> items;
  final bool isLoading;
  const LoadState({this.items = const [], this.isLoading = false});
}

class FakeOrdersNotifier extends StateNotifier<LoadState> {
  final String? userId;
  static final List<String?> constructionLog = [];

  FakeOrdersNotifier(this.userId) : super(const LoadState()) {
    constructionLog.add(userId);
    _load();
  }

  Future<void> _load() async {
    if (userId == null) {
      state = const LoadState();
      return;
    }
    state = const LoadState(isLoading: true);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (!mounted) return;
    state = LoadState(items: ['order-1', 'order-2']);
  }
}

final fakeAuthProvider =
    StateNotifierProvider<FakeAuthNotifier, FakeAuthState>((ref) {
  return FakeAuthNotifier();
});

final fakeUserIdProvider = Provider<String?>((ref) {
  return ref.watch(fakeAuthProvider).userId;
});

final fakeOrdersProvider =
    StateNotifierProvider<FakeOrdersNotifier, LoadState>((ref) {
  final userId = ref.watch(fakeUserIdProvider);
  return FakeOrdersNotifier(userId);
});

void main() {
  setUp(() => FakeOrdersNotifier.constructionLog.clear());

  test('notifier created before auth resolves is recreated when user arrives',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // UI starts listening BEFORE auth has restored (userId null).
    final sub = container.listen(fakeOrdersProvider, (_, _) {});
    expect(FakeOrdersNotifier.constructionLog, [null]);

    // Auth session restoration completes.
    container.read(fakeAuthProvider.notifier).signIn('user-A');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(FakeOrdersNotifier.constructionLog, [null, 'user-A']);
    final state = container.read(fakeOrdersProvider);
    expect(state.items, ['order-1', 'order-2']);
    sub.close();
  });

  test('provider read only once (no listener) still rebuilds on next read',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final first = container.read(fakeOrdersProvider);
    expect(first.items, isEmpty);

    container.read(fakeAuthProvider.notifier).signIn('user-B');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final second = container.read(fakeOrdersProvider);
    expect(second.items, ['order-1', 'order-2']);
    expect(FakeOrdersNotifier.constructionLog, [null, 'user-B']);
  });
}
