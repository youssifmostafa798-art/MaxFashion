import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:max/Compenents/custem_text.dart';
import 'package:max/core/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(20),
        Center(
          child: CustemText(
            text: title.toUpperCase(),
            color: AppColors.primary,
            size: 18,
            spacing: 7,
          ),
        ),
        Gap(10),
        Image.asset(
          'assets/svgs/line.png',
          width: 150,
          height: 15,
          color: Colors.black,
        ),
        Gap(20),
      ],
    );
  }
}
