// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipebook/core/assets/svg_img.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/bottom_tos.dart';

class QrCodeScanButton extends StatelessWidget {
  const QrCodeScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bottomTos(context);
      },
      child: Container(
        height: 50.w,
        width: 50.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(SvgImg.qr, height: 35, width: 35),
        ),
      ),
    );
  }
}
