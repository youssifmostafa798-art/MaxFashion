import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/auth/data/models/profile_model.dart';
import 'package:max/features/auth/domain/auth_repository_interface.dart';
import 'package:max/features/auth/presentation/providers/auth_providers.dart';
import 'package:max/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:max/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:max/features/profile/presentation/widgets/profile_form_section.dart';

UserModel _userWithGender(String? gender) => UserModel(
      id: 'u1',
      fullName: 'Jane Doe',
      email: 'jane@test.com',
      phoneNumber: '+12345678',
      memberSince: DateTime(2024),
      gender: gender,
    );

class _CapturingAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _CapturingAuthNotifier(UserModel user) : super(AuthState(user: user));

  String? lastSavedGender;

  @override
  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImage,
    String? gender,
    DateTime? dateOfBirth,
    String? country,
    String? bio,
  }) async {
    lastSavedGender = gender;
    state = state.copyWith(user: state.user?.copyWith(gender: gender));
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeAuthRepository implements AuthRepositoryInterface {
  _FakeAuthRepository(this.gender);

  final String? gender;

  ProfileModel get _profile => ProfileModel(
        id: 'u1',
        fullName: 'Jane Doe',
        phoneNumber: '+12345678',
        gender: gender,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

  @override
  Future<ProfileModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? country,
    String? bio,
  }) async =>
      _profile;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Future<void> _pumpHost(
  WidgetTester tester, {
  required Widget child,
  required Locale locale,
  ProviderContainer? container,
}) async {
  final scopedChild = container == null
      ? child
      : UncontrolledProviderScope(container: container, child: child);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: scopedChild,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('AppConstants.genderValues', () {
    test('contain exactly one item per canonical value', () {
      expect(AppConstants.genderValues, [
        'Male',
        'Female',
        'Other',
        'Prefer not to say',
      ]);
      expect(AppConstants.genderValues.toSet().length,
          AppConstants.genderValues.length);
    });
  });

  group('ProfileFormDropdown value/label separation', () {
    testWidgets(
      'canonical value renders localized label (Arabic) without assertion',
      (tester) async {
        await _pumpHost(
          tester,
          locale: const Locale('ar'),
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              final items = [
                DropdownMenuItem(
                  value: AppConstants.genderMale,
                  child: Text(l10n.genderMale),
                ),
                DropdownMenuItem(
                  value: AppConstants.genderFemale,
                  child: Text(l10n.genderFemale),
                ),
              ];
              return Scaffold(
                body: ProfileFormDropdown(
                  value: AppConstants.genderMale,
                  items: items,
                  hint: l10n.genderHint,
                  onChanged: (_) {},
                ),
              );
            },
          ),
        );

        expect(find.text('ذكر'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'legacy non-canonical stored value falls back to hint, never asserts',
      (tester) async {
        await _pumpHost(
          tester,
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              final items = [
                DropdownMenuItem(
                  value: AppConstants.genderMale,
                  child: Text(l10n.genderMale),
                ),
                DropdownMenuItem(
                  value: AppConstants.genderFemale,
                  child: Text(l10n.genderFemale),
                ),
              ];
              return Scaffold(
                body: ProfileFormDropdown(
                  value: 'أنثى',
                  items: items,
                  hint: l10n.genderHint,
                  onChanged: (_) {},
                ),
              );
            },
          ),
        );

        expect(find.text('Select your gender'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('EditProfilePage gender flow', () {
    testWidgets(
      'opens with gender=Male in English and shows canonical label',
      (tester) async {
        final container = ProviderContainer(overrides: [
          authStateProvider
              .overrideWith((ref) => _CapturingAuthNotifier(_userWithGender('Male'))),
          authRepositoryProvider
              .overrideWithValue(_FakeAuthRepository('Male')),
        ]);
        addTearDown(container.dispose);

        await _pumpHost(
          tester,
          locale: const Locale('en'),
          container: container,
          child: const EditProfilePage(),
        );

        expect(find.text('Male'), findsOneWidget);
        expect(container.read(editProfileProvider).gender, 'Male');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'opens with gender=Male in Arabic showing Arabic label, value stays canonical',
      (tester) async {
        final container = ProviderContainer(overrides: [
          authStateProvider
              .overrideWith((ref) => _CapturingAuthNotifier(_userWithGender('Male'))),
          authRepositoryProvider
              .overrideWithValue(_FakeAuthRepository('Male')),
        ]);
        addTearDown(container.dispose);

        await _pumpHost(
          tester,
          locale: const Locale('ar'),
          container: container,
          child: const EditProfilePage(),
        );

        expect(find.text('ذكر'), findsOneWidget);
        expect(find.text('Male'), findsNothing);
        expect(container.read(editProfileProvider).gender, 'Male');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'locale switch EN -> AR -> EN keeps internal value stable',
      (tester) async {
        final container = ProviderContainer(overrides: [
          authStateProvider
              .overrideWith((ref) => _CapturingAuthNotifier(_userWithGender('Male'))),
          authRepositoryProvider
              .overrideWithValue(_FakeAuthRepository('Male')),
        ]);
        addTearDown(container.dispose);

        await _pumpHost(
          tester,
          locale: const Locale('en'),
          container: container,
          child: const EditProfilePage(),
        );
        expect(container.read(editProfileProvider).gender, 'Male');

        await _pumpHost(
          tester,
          locale: const Locale('ar'),
          container: container,
          child: const EditProfilePage(),
        );
        expect(find.text('ذكر'), findsOneWidget);
        expect(container.read(editProfileProvider).gender, 'Male');

        await _pumpHost(
          tester,
          locale: const Locale('en'),
          container: container,
          child: const EditProfilePage(),
        );
        expect(find.text('Male'), findsOneWidget);
        expect(container.read(editProfileProvider).gender, 'Male');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'selecting an option in Arabic stores the CANONICAL value, not localized text',
      (tester) async {
        final container = ProviderContainer(overrides: [
          authStateProvider.overrideWith(
              (ref) => _CapturingAuthNotifier(_userWithGender('Male'))),
          authRepositoryProvider
              .overrideWithValue(_FakeAuthRepository('Male')),
        ]);
        addTearDown(container.dispose);

        await _pumpHost(
          tester,
          locale: const Locale('ar'),
          container: container,
          child: const EditProfilePage(),
        );

        final dropdownFinder = find.byType(DropdownButtonFormField<String>);
        await tester.ensureVisible(dropdownFinder);
        await tester.pumpAndSettle();
        await tester.tap(dropdownFinder);
        await tester.pumpAndSettle();

        await tester.tap(find.text('أنثى').last);
        await tester.pumpAndSettle();

        expect(container.read(editProfileProvider).gender, 'Female');

        final saved = await container.read(editProfileProvider.notifier).save();
        expect(saved, isTrue);
        expect(
          (container.read(authStateProvider.notifier) as _CapturingAuthNotifier)
              .lastSavedGender,
          'Female',
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'user with gender=Female loads correctly in English',
      (tester) async {
        final container = ProviderContainer(overrides: [
          authStateProvider.overrideWith(
              (ref) => _CapturingAuthNotifier(_userWithGender('Female'))),
          authRepositoryProvider
              .overrideWithValue(_FakeAuthRepository('Female')),
        ]);
        addTearDown(container.dispose);

        await _pumpHost(
          tester,
          locale: const Locale('en'),
          container: container,
          child: const EditProfilePage(),
        );

        expect(find.text('Female'), findsOneWidget);
        expect(container.read(editProfileProvider).gender, 'Female');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'legacy Arabic-stored gender does not crash page open (guard path)',
      (tester) async {
        final container = ProviderContainer(overrides: [
          authStateProvider.overrideWith(
              (ref) => _CapturingAuthNotifier(_userWithGender('أنثى'))),
          authRepositoryProvider
              .overrideWithValue(_FakeAuthRepository('أنثى')),
        ]);
        addTearDown(container.dispose);

        await _pumpHost(
          tester,
          locale: const Locale('en'),
          container: container,
          child: const EditProfilePage(),
        );

        expect(find.text('Select your gender'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
