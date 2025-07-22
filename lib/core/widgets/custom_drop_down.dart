import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:learn_link/core/widgets/text_widgets.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown({
    super.key,
    required this.onTap,
    required this.value,
    required this.hint,
    required this.label,
    this.color,
    this.labelColor,
    this.borderColor,
    this.iconColor,
    this.prefixIcon,
    this.valueColor,
    this.suffixIcon
  });


  final Callback? onTap;
  final String? value;
  final String? hint;
  final String? label;
  final Color? color;
  final IconData? suffixIcon;
  final Color? borderColor;
  Color? iconColor;
  Color? labelColor;
  Color? valueColor;
  String? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label!=null?  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Texts.textNormal(
                label!,
                size: 12,
                fontWeight: FontWeight.w600
            ),

          ],
        ):SizedBox(),
        label!=null?const SizedBox(
          height: 7,
        ):SizedBox(height: 0,),
        GestureDetector(
            onTap:onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: color??Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: .5,
                      color:borderColor??Colors.grey)

              ),
              height: 45,
              width: 1.sw,
              child: Row(
                children: [
                  prefixIcon!=null? Image.asset(prefixIcon!,height: 20,width: 20,):Container(),
                  prefixIcon!=null? SizedBox(width: 10,):Container(),

                  Expanded(
                    child: Texts.textNormal(
                      textAlign: TextAlign.start,
                      size: 12,
                      (value == null || value!.isEmpty) ? hint! : value!,
                      color: (value == null || value!.isEmpty)
                          ? Colors.grey // or your placeholder color
                          : valueColor??Colors.black,
                    ),
                  ),

                  const SizedBox(width: 10,),
                  suffixIcon==null?Icon(Icons.keyboard_arrow_down_outlined,color: iconColor??Colors.white,size: 18,):Icon(suffixIcon!,color: iconColor??Colors.white,size: 18,)
                ],
              ),
            )),const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}