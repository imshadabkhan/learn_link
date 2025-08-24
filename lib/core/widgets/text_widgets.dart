import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';




class Texts {
  static textBold(String label,
      {double? size, Color? color, FontWeight? fontWeight, textAlign,int? maxlines,TextOverflow? overFlow}) {
    return Text(
      label,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxlines??1,
      overflow: overFlow,
      style: TextStyle(

        fontSize: size ?? 28,
        fontFamily: "LeagueSpartan",
        fontWeight: fontWeight ?? FontWeight.bold,


        color: color ?? Colors.black,
      ),
    );
  }

  static textNormal(String label,
      { var maxLines,double? size, Color? color, String? fontFamily, textAlign, overflow,var decoration,var fontWeight,var textBaseline}) {
    return Text(
      label,
      maxLines: maxLines??3,
      style: TextStyle(

        decoration: decoration,

          textBaseline: textBaseline,
          fontSize: size ?? 18.0,
          fontWeight: fontWeight??FontWeight.w400,
          fontFamily: "Montserrat",
          color: color ?? Colors.black,
          overflow: overflow),
      textAlign: textAlign ?? TextAlign.center,

    );
  }

  static textMedium(String label,
      {double? size, Color? color, String? fontFamily, fontWeight}) {
    return Text(
      label,
      style: TextStyle(
          fontWeight: fontWeight??FontWeight.w600,
          fontSize: size ?? 18.0,
          fontFamily: "Montserrat",

          color: color ?? Colors.black),
    );
  }

  static textUrbanistCenter(String label,
      {double? size,
      Color? color,
      FontWeight? fontWeight,
      String? fontFamily}) {
    return Text(
      label,
      style: TextStyle(
        fontSize: size ?? 18.0,
        fontFamily: fontFamily ?? "InstrumentSansRegular",
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  static textBlock(String label,
      {double? size,
      Color? color,
      FontWeight? fontWeight,
      String? fontFamily,
      var overflow,
      int? maxline,
      var align,
      var decoration
      }) {
    return Text(
      label,
      style: TextStyle(
decoration: decoration,

          fontSize: size ?? 18.0,
          fontFamily: fontFamily ?? "PoppinsRegular",
          fontWeight: fontWeight ?? FontWeight.bold,
          color: color ?? Colors.black,

      ),
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: align ?? TextAlign.start,
      maxLines: maxline ?? 1,
    );
  }

  static textUnderlineBlock(String label,
      {double? size,
      Color? color,
      FontWeight? fontWeight,
      String? fontFamily,
      var overflow,
      int? maxline,
      bool? underline}) {
    return Text(
      label,
      style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: size ?? 18.0,
          fontFamily: fontFamily ?? "InstrumentSansRegular",
          fontWeight: fontWeight ?? FontWeight.bold,
          color: color ?? Colors.black),
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxline ?? 1,
    );
  }
}
