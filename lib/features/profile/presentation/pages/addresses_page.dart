import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/confirm_delete_dialog.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/data/providers/address_provider.dart';
import 'package:max/features/checkout/presentation/pages/add_address.dart';
import 'package:max/features/profile/presentation/widgets/address_card.dart';
import 'package:max/features/profile/presentation/widgets/empty_addresses.dart';

class AddressesPage extends ConsumerStatefulWidget {
  const AddressesPage({super.key});

  @override
  ConsumerState<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends ConsumerState<AddressesPage> {
  void _addAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAddress()),
    );
    if (result != null && result is AddressModel) {
      ref.read(addressProvider.notifier).add(result);
    }
  }

  void _editAddress(AddressModel address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddAddress(editAddress: address)),
    );
    if (result != null && result is AddressModel) {
      ref.read(addressProvider.notifier).update(result);
    }
  }

  void _deleteAddress(AddressModel address) {
    showConfirmDeleteDialog(
      context: context,
      emoji: '\ud83d\uddd1\ufe0f',
      title: 'Delete Address?',
      onDelete: () {
        ref.read(addressProvider.notifier).remove(address.id);
      },
    );
  }

  void _setDefault(AddressModel address) {
    ref.read(addressProvider.notifier).setDefault(address.id);
  }

  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(addressProvider);

    return Scaffold(
      appBar: const CustomAppbar(showSearchBar: false),
      body: addresses.isEmpty
          ? EmptyAddresses(onAdd: _addAddress)
          : Column(
              children: [
                const Header(title: 'Addresses'),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 10.h,
                    ),
                    itemCount: addresses.length,
                    separatorBuilder: (_, _) => Gap(14.h),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return AddressCard(
                        address: address,
                        onEdit: () => _editAddress(address),
                        onDelete: () => _deleteAddress(address),
                        onSetDefault: () => _setDefault(address),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 30.h),
                  child: CustomButton(
                    isSvg: false,
                    title: 'Add Address',
                    onTap: _addAddress,
                  ),
                ),
              ],
            ),
    );
  }
}
