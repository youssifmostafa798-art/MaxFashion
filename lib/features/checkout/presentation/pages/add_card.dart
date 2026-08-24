import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/core/theme/app_colors.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardName = '';
  String cvvCode = '';
  bool isShow = false;

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAppbar(),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(title: l10n.paymentMethodLabel.toUpperCase()),
                Gap(13.h),

                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardName,
                  cvvCode: cvvCode,
                  showBackView: isShow,
                  isHolderNameVisible: true,
                  onCreditCardWidgetChange: (v) {},
                  cardBgColor: AppColors.cardGrey800,
                ),

                CreditCardForm(
                  formKey: key,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardName,
                  cvvCode: cvvCode,
                  onCreditCardModelChange: onCreditCardModelChange,
                ),

                Gap(90.h),

                CustomButton(
                  isSvg: true,
                  title: l10n.addCardButton.toUpperCase(),
                  onTap: () {
                    if (key.currentState!.validate()) {
                      final data = {
                        'number': cardNumber,
                        'name': cardName,
                        'date': expiryDate,
                        'cvv': cvvCode,
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
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel data) {
    setState(() {
      cardNumber = data.cardNumber;
      cardName = data.cardHolderName;
      cvvCode = data.cvvCode;
      expiryDate = data.expiryDate;
      isShow = data.isCvvFocused;
    });
  }
}
