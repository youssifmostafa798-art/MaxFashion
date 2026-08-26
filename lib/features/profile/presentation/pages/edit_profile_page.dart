import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/errors/app_error_messages.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/dialog/success_dialog.dart';
import 'package:max/core/widgets/dialog/app_confirmation_dialog.dart';
import 'package:max/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:max/features/profile/presentation/widgets/profile_form_section.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _countryController;
  late final TextEditingController _bioController;

  bool _isInitialized = false;
  String? _lastSyncedUserId;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    _countryController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _countryController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _syncControllers(EditProfileState state) {
    final currentUserId = ref.read(authStateProvider).user?.id;
    if (currentUserId != _lastSyncedUserId) {
      _isInitialized = false;
    }
    if (!_isInitialized) {
      _firstNameController.text = state.firstName;
      _lastNameController.text = state.lastName;
      _emailController.text = state.email;
      _phoneController.text = state.phoneNumber;
      _countryController.text = state.country ?? '';
      _bioController.text = state.bio ?? '';
      _updateDobController(state.dateOfBirth);
      _lastSyncedUserId = currentUserId;
      _isInitialized = true;
    }
  }

  void _updateDobController(DateTime? date) {
    if (date != null) {
      _dobController.text = DateFormatter.formatDateNumeric(
        date,
        locale: Localizations.localeOf(context).languageCode,
      );
    } else {
      _dobController.clear();
    }
  }

  Future<void> _pickDate(EditProfileNotifier notifier) async {
    final now = DateTime.now();
    final currentDob = ref.read(editProfileProvider).dateOfBirth;
    final initial = currentDob ?? DateTime(now.year - 25, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      notifier.updateDateOfBirth(picked);
      _updateDobController(picked);
    }
  }

  Future<bool> _onWillPop() async {
    final state = ref.read(editProfileProvider);
    if (!state.hasChanges) return true;
    final l10n = AppLocalizations.of(context)!;

    final result = await AppConfirmationDialog.show(
      context: context,
      title: l10n.discardChanges,
      message: l10n.unsavedChangesMessage,
      icon: Icons.warning_amber_rounded,
      confirmLabel: l10n.discardButton,
      isDestructive: true,
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(editProfileProvider);

    _syncControllers(state);

    ref.listen<EditProfileState>(editProfileProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppErrorMessages.resolve(l10n, next.error)),
            backgroundColor: AppColors.errorRed400,
          ),
        );
        ref.read(editProfileProvider.notifier).clearError();
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final genderItems = [
      DropdownMenuItem(
        value: AppConstants.genderMale,
        child: Text(l10n.genderMale),
      ),
      DropdownMenuItem(
        value: AppConstants.genderFemale,
        child: Text(l10n.genderFemale),
      ),
      DropdownMenuItem(
        value: AppConstants.genderOther,
        child: Text(l10n.genderOther),
      ),
      DropdownMenuItem(
        value: AppConstants.genderPreferNotToSay,
        child: Text(l10n.genderPreferNotToSay),
      ),
    ];

    return PopScope(
      canPop: !state.hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
              color: colorScheme.onSurface,
            ),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: CustomText(
            text: l10n.editProfileTitle,
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ProfileAvatar(
                  avatarUrl: state.avatarUrl,
                  onTap: state.isAvatarLoading
                      ? null
                      : () =>
                            ref.read(editProfileProvider.notifier).pickImage(),
                  radius: 55,
                  showCameraIcon: true,
                ),
                if (state.isAvatarLoading) ...[
                  Gap(12.h),
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
                if (state.avatarUrl != null &&
                    state.avatarUrl!.isNotEmpty &&
                    !state.isAvatarLoading) ...[
                  Gap(8.h),
                  GestureDetector(
                    onTap: () =>
                        ref.read(editProfileProvider.notifier).removeAvatar(),
                    child: CustomText(
                      text: l10n.removePhoto,
                      size: 13,
                      color: AppColors.errorRed400,
                    ),
                  ),
                ],
                Gap(30.h),
                ProfileFormSection(
                  title: l10n.personalInformation,
                  children: [
                    ProfileFormField(
                      controller: _firstNameController,
                      hint: l10n.firstNameHint,
                      label: l10n.firstNameLabel,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.firstNameRequired;
                        }
                        if (value.trim().length > 50) {
                          return l10n.firstNameMaxLength;
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateFirstName(value),
                    ),
                    ProfileFormField(
                      controller: _lastNameController,
                      hint: l10n.lastNameHint,
                      label: l10n.lastNameLabel,
                      validator: (value) {
                        if (value != null && value.trim().length > 50) {
                          return l10n.lastNameMaxLength;
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateLastName(value),
                    ),
                    ProfileFormField(
                      controller: _emailController,
                      hint: l10n.emailAddressHint,
                      label: l10n.emailLabel,
                      readOnly: true,
                    ),
                    ProfileFormField(
                      controller: _phoneController,
                      hint: l10n.phoneHint,
                      label: l10n.phoneLabel,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9+\-\(\)\s]'),
                        ),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final cleaned = value.replaceAll(
                            RegExp(r'[\s\-\(\)]'),
                            '',
                          );
                          if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleaned)) {
                            return l10n.invalidPhone;
                          }
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updatePhoneNumber(value),
                    ),
                    GestureDetector(
                      onTap: () =>
                          _pickDate(ref.read(editProfileProvider.notifier)),
                      child: AbsorbPointer(
                        child: ProfileFormField(
                          controller: _dobController,
                          hint: l10n.dobHint,
                          label: l10n.dobLabel,
                          suffixIcon: Icons.calendar_today_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(30.h),
                ProfileFormSection(
                  title: l10n.additionalInfo,
                  children: [
                    ProfileFormDropdown(
                      value: state.gender,
                      items: genderItems,
                      hint: l10n.genderHint,
                      label: l10n.genderLabel,
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateGender(value),
                    ),
                    ProfileFormField(
                      controller: _countryController,
                      hint: l10n.countryHintProfile,
                      label: l10n.countryLabel,
                      validator: (value) {
                        if (value != null && value.trim().length > 50) {
                          return l10n.countryMaxLength;
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateCountry(value.trim().isEmpty ? null : value),
                    ),
                    ProfileFormField(
                      controller: _bioController,
                      hint: l10n.bioHint,
                      label: l10n.bioLabel,
                      maxLines: 3,
                      validator: (value) {
                        if (value != null && value.trim().length > 200) {
                          return l10n.bioMaxLength;
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateBio(value),
                    ),
                  ],
                ),
                Gap(40.h),
                _buildSaveButton(colorScheme, state),
                Gap(14.h),
                _buildCancelButton(colorScheme),
                Gap(40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ColorScheme colorScheme, EditProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: state.isLoading ? null : () => _save(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: state.isLoading
              ? colorScheme.onSurface.withValues(alpha: 0.5)
              : colorScheme.onSurface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: state.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    color: colorScheme.surface,
                  ),
                )
              : CustomText(
                  text: l10n.saveChanges,
                  size: 15,
                  color: colorScheme.surface,
                ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Center(
          child: CustomText(
            text: l10n.cancel,
            size: 15,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(editProfileProvider.notifier);
    final success = await notifier.save();

    if (success && mounted) {
      final l10n = AppLocalizations.of(context)!;
      showSuccessDialog(
        context: context,
        title: l10n.profileUpdated,
        message: l10n.profileUpdatedMessage,
        icon: Icons.check_circle_rounded,
        onDismissed: () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    }
  }
}
