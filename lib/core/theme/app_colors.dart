import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === DARK THEME === (tokens.jsx THEMES.dark 기준)
  static const darkBg       = Color(0xFF0E1116);
  static const darkSurface  = Color(0xFF161A22);
  static const darkSurface2 = Color(0xFF1E232E);
  static const darkSurface3 = Color(0xFF272D3A);
  static const darkBorder   = Color(0x0FFFFFFF);  // rgba(255,255,255,0.06)
  static const darkBorder2  = Color(0x1FFFFFFF);  // rgba(255,255,255,0.12)
  static const darkText     = Color(0xFFE7ECF3);
  static const darkTextDim  = Color(0xFF9AA3B2);
  static const darkTextMute = Color(0xFF5F6878);
  static const darkLime     = Color(0xFFB6F36C);
  static const darkLimeDeep = Color(0xFF7CC23A);
  static const darkAmber    = Color(0xFFF2B355);
  static const darkRose     = Color(0xFFF2768A);
  static const darkBlue     = Color(0xFF7AB8FF);

  // === LIGHT THEME === (tokens.jsx THEMES.light 기준)
  static const lightBg       = Color(0xFFF7F8FA);
  static const lightSurface  = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF0F2F5);
  static const lightSurface3 = Color(0xFFE5E8ED);
  static const lightBorder   = Color(0x14141923);  // rgba(20,25,35,0.08)
  static const lightBorder2  = Color(0x28141923);  // rgba(20,25,35,0.16)
  static const lightText     = Color(0xFF101521);
  static const lightTextDim  = Color(0xFF5C6677);
  static const lightTextMute = Color(0xFF9098A6);
  static const lightLime     = Color(0xFF5DA02A);
  static const lightLimeDeep = Color(0xFF3F7818);
  static const lightAmber    = Color(0xFFC77A1B);
  static const lightRose     = Color(0xFFD4475F);
  static const lightBlue     = Color(0xFF2D7CD6);

  // 난이도 색상 (다크 기준)
  static const diff1 = Color(0xFF7CC23A);  // 쉬움 - lime
  static const diff2 = Color(0xFFF2B355);  // 보통 - amber
  static const diff3 = Color(0xFFF2768A);  // 어려움 - rose
}
