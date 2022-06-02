import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trailer_tracking/components/style.dart';
import 'package:rxdart/rxdart.dart';

class DemoTheme {
  final String name;
  final ThemeData data;

  const DemoTheme(this.name, this.data);
}

class ThemeBloc {
  final Stream<ThemeData> themeDataStream;
  final Sink<DemoTheme> selectedTheme;

  factory ThemeBloc() {
    final selectedTheme = PublishSubject<DemoTheme>();
    final themeDataStream = selectedTheme.distinct().map((theme) => theme.data);
    selectedTheme.close();
    return ThemeBloc._(themeDataStream, selectedTheme);
  }


  const ThemeBloc._(this.themeDataStream, this.selectedTheme);

  DemoTheme initialTheme(String colorMode) {
    if ("DARK" == colorMode) {
      return DemoTheme(
          'dark',
          ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: colorStyle.background,
              backgroundColor: colorStyle.blackBackground,
              dividerColor: colorStyle.iconColorDark,
              accentColor: colorStyle.primaryColor,
              primaryColor: colorStyle.primaryColor,
              hintColor: colorStyle.fontSecondaryColorDark,
              buttonColor: colorStyle.primaryColor,
              canvasColor: colorStyle.grayBackground,
              cardColor: colorStyle.grayBackground,
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: colorStyle.fontColorDark,
                selectionHandleColor: colorStyle.fontColorDarkTitle,
              ),),);
    } else {
      return DemoTheme(
          'light',
          ThemeData(
            brightness: Brightness.light,
            accentColor: colorStyle.primaryColor,
            primaryColor: colorStyle.primaryColor,
            backgroundColor: colorStyle.whiteBacground,
            buttonColor: colorStyle.primaryColor,
            cardColor: colorStyle.cardColorLight,
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: colorStyle.fontColorLight,
              selectionHandleColor: colorStyle.iconColorDark,
            ),
            scaffoldBackgroundColor: Color(0xFFFDFDFD),
            canvasColor: colorStyle.whiteBacground,
            dividerColor: colorStyle.iconColorLight,
            hintColor: colorStyle.fontSecondaryColorLight,
          ));
    }
  }
}
