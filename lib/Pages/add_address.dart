import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:max/Compenents/custem_appbar.dart';
import 'package:max/Compenents/custem_bottom.dart';

import 'package:max/Compenents/custem_text_field.dart';

import 'package:max/core/header.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key, this.editData});
  final dynamic editData;
  @override
  State<AddAddress> createState() => _AddAddressState();
}

// variable
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

  //save the old data
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
      appBar: CustemAppbar(isBlackk: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Header(title: "Add Shipping Address"),
              //input data
              Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustemTextField(
                              hint: "First Name",
                              controller: firstNameController,
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            child: CustemTextField(
                              hint: "Last Name",
                              controller: lastNameController,
                            ),
                          ),
                        ],
                      ),

                      Gap(30),
                      CustemTextField(
                        hint: "Address",
                        controller: addressController,
                      ),

                      Gap(30),
                      CustemTextField(hint: "City", controller: cityController),

                      Gap(30),
                      Row(
                        children: [
                          Expanded(
                            child: CustemTextField(
                              hint: "State",
                              controller: stateController,
                            ),
                          ),
                          Gap(30),
                          Expanded(
                            child: CustemTextField(
                              hint: "ZIP Code",
                              controller: zipController,
                            ),
                          ),
                        ],
                      ),

                      Gap(30),
                      CustemTextField(
                        hint: "Phone Number",
                        controller: phoneController,
                      ),
                    ],
                  ),
                ),
              ),

              Gap(210),
              // add data and save
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
              Gap(70),
            ],
          ),
        ),
      ),
    );
  }
}
