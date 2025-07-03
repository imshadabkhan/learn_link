

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? label;
  final Widget? icon;
  final double? iconGap;
  final Function? onTap;
  final Color? color;
  final Color? textColor;
  final double? padding;
  final double? radius; final double? fontSize;
  final TextStyle? textStyle;
 final Color? borderColor;
 var borderWidth;
  final Color? backgroundColor;
   CustomButton({
    super.key,
    this.label,
     this.backgroundColor,
    this.icon,
    this.iconGap,
    this.onTap,this.fontSize,
    this.color,
    this.textColor,
    this.padding,
    this.radius,
    this.height,
    this.width,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius ?? 8),
          border: Border.all(color: borderColor??Colors.transparent,width: borderWidth ??.6),
          // color: color ?? ColorConstants.secondaryColor,
        ),
        padding: EdgeInsets.all(padding ?? (icon != null ? 12.0 : 12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            icon != null
                ? SizedBox(width: iconGap ?? 10)
                : const SizedBox.shrink(),
            Flexible(
              child: AutoSizeText(
                label ?? "Continue".tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize:fontSize??14,color: textColor??Colors.white, fontFamily:"PlusJakartaSansRegular",fontWeight: FontWeight.bold
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
