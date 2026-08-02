import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/core/widgets/custem_text_field.dart';
import 'package:max/core/widgets/header.dart';
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

  String _selectedLabel = 'Home';
  final _formkey = GlobalKey<FormState>();

  static const _labels = ['Home', 'Work', 'Other'];

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
      _selectedLabel = a.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing ? 'Edit Address' : 'Add Address';
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustemAppbar(),
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
                    CustemText(
                      text: 'ADDRESS LABEL',
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                      spacing: 2,
                    ),
                    Gap(10.h),
                    Row(
                      children: _labels.map((label) {
                        final isSelected = _selectedLabel == label;
                        return Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedLabel = label),
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
                                label,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isSelected
                                      ? colorScheme.surface
                                      : colorScheme.onSurface,
                                  fontFamily: 'Tenor_Sans',
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Gap(30.h),
                    CustemTextField(
                      hint: "Street Address",
                      controller: streetController,
                    ),
                    Gap(30.h),
                    CustemTextField(
                      hint: "Apartment, Suite, etc. (optional)",
                      controller: apartmentController,
                    ),
                    Gap(30.h),
                    CustemTextField(
                      hint: "City",
                      controller: cityController,
                    ),
                    Gap(30.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustemTextField(
                            hint: "State",
                            controller: stateController,
                          ),
                        ),
                        Gap(30.w),
                        Expanded(
                          child: CustemTextField(
                            hint: "ZIP Code",
                            controller: zipController,
                          ),
                        ),
                      ],
                    ),
                    Gap(30.h),
                    CustemTextField(
                      hint: "Country",
                      controller: countryController,
                    ),
                  ],
                ),
              ),
              Gap(60.h),
              Button(
                isSvgg: false,
                title: (widget.isEditing ? "Update" : "Add now").toUpperCase(),
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
                    label: _selectedLabel,
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
}
