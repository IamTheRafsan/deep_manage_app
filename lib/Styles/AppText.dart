import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:deep_manage_app/Styles/Color.dart';

class AppText{

    static TextStyle AppBarHeading(){
      return TextStyle(
        fontSize: 22,
        color: color.buttonTextPrimaryColor,
        fontWeight: FontWeight.w500
      );
    }

    static TextStyle buttonText(){
      return TextStyle(
        fontSize: 16,
        color: color.buttonTextPrimaryColor,
        );
    }

    static TextStyle buttonSecondaryText(){
      return TextStyle(
        fontSize: 16,
        color: color.buttonTextSecondaryColor,
      );
    }

    static TextStyle HeadingText(){
      return TextStyle(
        fontSize: 24,
        color: color.primaryColor,
        fontWeight: FontWeight.w700,
      );
    }

    static TextStyle HeadingTextWhite(){
      return TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );
    }

    static TextStyle SubHeadingText(){
      return TextStyle(
        fontSize: 16,
        color: color.primaryColor,
        fontWeight: FontWeight.w600,
      );
    }

    static TextStyle BodyText(){
      return TextStyle(
        fontSize: 14,
        color: color.primaryColor,
      );
    }

    static TextStyle BodyTextBold(){
      return TextStyle(
        fontSize: 14,
        color: color.primaryColor,
        fontWeight: FontWeight.w600
      );
    }

    static TextStyle InputText(){
      return TextStyle(
        fontSize: 16,
        color: color.inputTextColor,
      );
    }

}