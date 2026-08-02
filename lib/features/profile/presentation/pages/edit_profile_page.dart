import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/widgets/custom_text.dart';
import 'package:max/features/profile/presentation/providers/edit_profile_provider.dart';
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

  bool _isInitialized = false;

  static const _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    _countryController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _syncControllers(EditProfileState state) {
    if (!_isInitialized) {
      _firstNameController.text = state.firstName;
      _lastNameController.text = state.lastName;
      _emailController.text = state.email;
      _phoneController.text = state.phoneNumber;
      _countryController.text = state.country ?? '';
      _updateDobController(state.dateOfBirth);
      _isInitialized = true;
    }
  }

  void _updateDobController(DateTime? date) {
    if (date != null) {
      _dobController.text =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(editProfileProvider);

    _syncControllers(state);

    ref.listen<EditProfileState>(editProfileProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red.shade400,
          ),
        );
        ref.read(editProfileProvider.notifier).clearError();
      }
    });

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
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: CustomText(
            text: 'EDIT PROFILE',
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
                  imagePath: state.profileImagePath,
                  onTap: () =>
                      ref.read(editProfileProvider.notifier).pickImage(),
                  radius: 55,
                ),
                Gap(30.h),
                ProfileFormSection(
                  title: 'PERSONAL INFORMATION',
                  children: [
                    ProfileFormField(
                      controller: _firstNameController,
                      hint: 'Enter your first name',
                      label: 'FIRST NAME',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        if (value.trim().length > 50) {
                          return 'First name must be 50 characters or less';
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateFirstName(value),
                    ),
                    ProfileFormField(
                      controller: _lastNameController,
                      hint: 'Enter your last name',
                      label: 'LAST NAME',
                      validator: (value) {
                        if (value != null && value.trim().length > 50) {
                          return 'Last name must be 50 characters or less';
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateLastName(value),
                    ),
                    ProfileFormField(
                      controller: _emailController,
                      hint: 'Your email address',
                      label: 'EMAIL',
                      readOnly: true,
                    ),
                    ProfileFormField(
                      controller: _phoneController,
                      hint: 'Enter your phone number',
                      label: 'PHONE NUMBER',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\(\)\s]')),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final cleaned =
                              value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
                          if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleaned)) {
                            return 'Please enter a valid phone number';
                          }
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updatePhoneNumber(value),
                    ),
                    GestureDetector(
                      onTap: () => _pickDate(
                          ref.read(editProfileProvider.notifier)),
                      child: AbsorbPointer(
                        child: ProfileFormField(
                          controller: _dobController,
                          hint: 'Select your date of birth',
                          label: 'DATE OF BIRTH (OPTIONAL)',
                          suffixIcon: Icons.calendar_today_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(30.h),
                ProfileFormSection(
                  title: 'ADDITIONAL INFO',
                  children: [
                    ProfileFormDropdown(
                      value: state.gender,
                      items: _genders,
                      hint: 'Select your gender',
                      label: 'GENDER (OPTIONAL)',
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateGender(value),
                    ),
                    ProfileFormField(
                      controller: _countryController,
                      hint: 'Enter your country',
                      label: 'COUNTRY (OPTIONAL)',
                      validator: (value) {
                        if (value != null && value.trim().length > 50) {
                          return 'Country must be 50 characters or less';
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(editProfileProvider.notifier)
                          .updateCountry(
                              value.trim().isEmpty ? null : value),
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
                  text: 'SAVE CHANGES',
                  size: 15,
                  color: colorScheme.surface,
                ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(ColorScheme colorScheme) {
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
            text: 'CANCEL',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: Colors.green.shade600,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
