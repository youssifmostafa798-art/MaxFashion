import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/data/providers/address_provider.dart';
import 'package:max/features/checkout/presentation/add_address.dart';
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
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(10.h),
                Text(
                  '\ud83d\uddd1\ufe0f',
                  style: TextStyle(fontSize: 40.w),
                ),
                Gap(16.h),
                Text(
                  'Delete Address?',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    fontFamily: 'Tenor_Sans',
                  ),
                ),
                Gap(8.h),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'Tenor_Sans',
                  ),
                ),
                Gap(24.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colorScheme.onSurface,
                                fontFamily: 'Tenor_Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(addressProvider.notifier)
                              .remove(address.id);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'DELETE',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontFamily: 'Tenor_Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(10.h),
              ],
            ),
          ),
        );
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
      appBar: const CustemAppbar(showSearchBar: false),
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
                  child: Button(
                    isSvgg: false,
                    title: 'Add Address',
                    onTap: _addAddress,
                  ),
                ),
              ],
            ),
    );
  }
}
