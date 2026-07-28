import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/header.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustemAppbar(isBlackk: false),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///page title
                Header(title: "Payment method".toUpperCase()),
                Gap(13),

                //master card
                CreditCardWidget(
                  //Logic part
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardName,
                  cvvCode: cvvCode,
                  showBackView: isShow,
                  isHolderNameVisible: true,
                  onCreditCardWidgetChange: (v) {},
                  //color part
                  cardBgColor: Colors.grey.shade800,
                ),

                //form
                CreditCardForm(
                  formKey: key,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardName,
                  cvvCode: cvvCode,
                  onCreditCardModelChange: onCreditCardModelChange,
                ),

                //buttom
                Gap(90),

                Button(
                  isSvgg: true,
                  title: "Add Card".toUpperCase(),
                  onTap: () {
                    if (key.currentState!.validate()) {
                      final data = {
                        'number': cardNumber,
                        'name': cardName,
                        'date ': expiryDate,
                        'cvv': cvvCode,
                      };
                      //maybe problem
                      Navigator.pop(context, data);
                    }
                  },
                ),
                Gap(70),
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
