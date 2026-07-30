import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';

import 'package:max/core/widgets/custem_text_field.dart';

import 'package:max/core/widgets/header.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key, this.editData});
  final dynamic editData;
  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final phoneController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.editData != null) {
      firstNameController.text = widget.editData['first'] ?? "";
      lastNameController.text = widget.editData['last'] ?? "";
      addressController.text = widget.editData['address'] ?? "";
      cityController.text = widget.editData['city'] ?? "";
      stateController.text = widget.editData['state'] ?? "";
      zipController.text = widget.editData['zip'] ?? "";
      phoneController.text = widget.editData['phone'] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustemAppbar(isBlackk: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            children: [
              const Header(title: "Add Shipping Address"),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Gap(30.h),
                    CustemTextField(
                      hint: "Address",
                      controller: addressController,
                    ),

                    Gap(30.h),
                    CustemTextField(hint: "City", controller: cityController),

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
                      hint: "Phone Number",
                      controller: phoneController,
                    ),
                  ],
                ),
              ),

              Gap(100.h),
              Button(
                isSvgg: false,
                title: "Add now".toUpperCase(),
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    return;
                  } else {
                    final data = {
                      'first': firstNameController.text,
                      'last': lastNameController.text,
                      'address': addressController.text,
                      'city': cityController.text,
                      'phone': phoneController.text,
                      'zip': zipController.text,
                      'state': stateController.text,
                    };

                    Navigator.pop(context, data);
                  }
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
