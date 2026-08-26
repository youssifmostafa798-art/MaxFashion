import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/custom_text_field.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/data/models/address_model.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key, this.editAddress});
  final AddressModel? editAddress;

  bool get isEditing => editAddress != null;

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final streetController = TextEditingController();
  final apartmentController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final zipController = TextEditingController();

  String? _selectedLabel;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    streetController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.editAddress != null) {
      final a = widget.editAddress!;
      streetController.text = a.street;
      apartmentController.text = a.apartment ?? '';
      cityController.text = a.city;
      stateController.text = a.state;
      countryController.text = a.country;
      zipController.text = a.zip;
      _selectedLabel = _normalizeLabel(a.label);
    }
  }

  String _normalizeLabel(String label) {
    final lower = label.toLowerCase();
    if (lower == 'home' || lower == '\u0627\u0644\u0645\u0646\u0632\u0644') {
      return AppConstants.addressLabelHome;
    }
    if (lower == 'work' || lower == '\u0627\u0644\u0639\u0645\u0644') {
      return AppConstants.addressLabelWork;
    }
    if (lower == 'other' || lower == '\u0623\u062e\u0631\u0649') {
      return AppConstants.addressLabelOther;
    }
    return AppConstants.addressLabelHome;
  }

  String _displayLabel(AppLocalizations l10n, String canonicalLabel) {
    switch (canonicalLabel) {
      case AppConstants.addressLabelHome:
        return l10n.homeLabel;
      case AppConstants.addressLabelWork:
        return l10n.workLabel;
      case AppConstants.addressLabelOther:
        return l10n.otherLabel;
      default:
        return l10n.homeLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.isEditing ? l10n.editAddressTitle : l10n.addAddressTitle;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            children: [
              Header(title: title),
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20.h),
                    CustomText(
                      text: l10n.addressLabelSection,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                      spacing: 2,
                    ),
                    Gap(10.h),
                    Row(
                      children: [
                        _buildLabelChip(
                          AppConstants.addressLabelHome,
                          _displayLabel(l10n, AppConstants.addressLabelHome),
                          colorScheme,
                        ),
                        _buildLabelChip(
                          AppConstants.addressLabelWork,
                          _displayLabel(l10n, AppConstants.addressLabelWork),
                          colorScheme,
                        ),
                        _buildLabelChip(
                          AppConstants.addressLabelOther,
                          _displayLabel(l10n, AppConstants.addressLabelOther),
                          colorScheme,
                        ),
                      ],
                    ),
                    Gap(30.h),
                    CustomTextField(
                      hint: l10n.streetAddressHint,
                      controller: streetController,
                    ),
                    Gap(30.h),
                    CustomTextField(
                      hint: l10n.apartmentHint,
                      controller: apartmentController,
                    ),
                    Gap(30.h),
                    CustomTextField(
                      hint: l10n.cityHint,
                      controller: cityController,
                    ),
                    Gap(30.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hint: l10n.stateHint,
                            controller: stateController,
                          ),
                        ),
                        Gap(30.w),
                        Expanded(
                          child: CustomTextField(
                            hint: l10n.zipCodeHint,
                            controller: zipController,
                          ),
                        ),
                      ],
                    ),
                    Gap(30.h),
                    CustomTextField(
                      hint: l10n.countryHint,
                      controller: countryController,
                    ),
                  ],
                ),
              ),
              Gap(60.h),
              CustomButton(
                isSvg: false,
                title: (widget.isEditing ? l10n.updateButton : l10n.addNowButton).toUpperCase(),
                onTap: () {
                  if (!_formkey.currentState!.validate()) return;

                  final address = AddressModel(
                    id: widget.editAddress?.id ?? AddressModel.generateId(),
                    street: streetController.text.trim(),
                    apartment: apartmentController.text.trim().isEmpty
                        ? null
                        : apartmentController.text.trim(),
                    city: cityController.text.trim(),
                    state: stateController.text.trim(),
                    country: countryController.text.trim(),
                    zip: zipController.text.trim(),
                    label: _selectedLabel ?? AppConstants.addressLabelHome,
                    isDefault: widget.editAddress?.isDefault ?? false,
                  );

                  Navigator.pop(context, address);
                },
              ),
              Gap(70.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelChip(String canonicalValue, String displayText, ColorScheme colorScheme) {
    final isSelected = (_selectedLabel ?? AppConstants.addressLabelHome) == canonicalValue;
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.w),
      child: GestureDetector(
        onTap: () => setState(() => _selectedLabel = canonicalValue),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.onSurface
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? colorScheme.onSurface
                  : colorScheme.outline,
            ),
          ),
          child: Text(
            displayText,
            style: TextStyle(
              fontSize: AppTextStyles.fontSize13,
              color: isSelected
                  ? colorScheme.surface
                  : colorScheme.onSurface,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
