import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      fontFamily: 'GlacialIndifference',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
    );
  }

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xff7146e4),
    onPrimary: Color(0xfffefefe),
    secondary: Color(0xffd3c7eb),
    onSecondary: Color(0xff1a110d),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xfffefefe),
    onSurface: Color(0xff1a110d),
    brightness: Brightness.light,
  );
}

ButtonStyle primaryButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(AppTheme.lightColorScheme.surface),
  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  )),
  foregroundColor: WidgetStateProperty.all(AppTheme.lightColorScheme.onSurface),
  textStyle: WidgetStateProperty.all(const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  )),
);

ButtonStyle secondaryButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(AppTheme.lightColorScheme.secondary),
  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  )),
  textStyle: WidgetStateProperty.all(const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  )),
);

ButtonStyle borderButtonStyle = ButtonStyle(
  shadowColor: WidgetStateProperty.all(Colors.transparent),
  backgroundColor: WidgetStateProperty.all(Colors.transparent),
  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
  shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      side: BorderSide(
        color: AppTheme.lightColorScheme.surface,
        width: 1,
      ))),
  foregroundColor: WidgetStateProperty.all(AppTheme.lightColorScheme.surface),
  textStyle: WidgetStateProperty.all(const TextStyle(
    fontSize: 16,
  )),
);

InputDecoration authTextFieldDecoration = InputDecoration(
  border: const OutlineInputBorder(),
  filled: true,
  fillColor: AppTheme.lightColorScheme.surface.withOpacity(0.5),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppTheme.lightColorScheme.surface),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppTheme.lightColorScheme.surface),
    borderRadius: BorderRadius.circular(8),
  ),
  labelStyle: TextStyle(
    color: AppTheme.lightColorScheme.surface,
  ),
  hintStyle: TextStyle(
    color: AppTheme.lightColorScheme.surface,
  ),
);
