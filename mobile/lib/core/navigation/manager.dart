import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/detailed_voice_settings/presentation/presentation.dart';
import '../../features/navigation/navigation.dart';
import '../../features/profile/presentation/presentation.dart';
import '../../features/settings/presentation/presentation.dart';

part 'router.dart';
part 'routes.dart';
part 'sub_navigator.dart';

class NavigationManager {
  NavigationManager._();

  /// Ключи навигаторов приложения
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Ключи навигаторов приложения
  static final GlobalKey<NavigatorState> navigatorKeyProfilePage =
      GlobalKey<NavigatorState>();

  static final scaffoldKeyProfilePage = GlobalKey();

  /// Состояние главного навигатора
  static NavigatorState? get rootNavigator => navigatorKey.currentState;

  /// Состояние навигатора страницы профиля
  static NavigatorState? get profileNavigator =>
      navigatorKeyProfilePage.currentState;

  /// Контекст главного навигатора
  static BuildContext get context => rootNavigator!.context;

  /// Функция перехода на экран
  /// [navigator] параметр для саб-навигатора
  /// [arguments] параметр аргумента
  /// [isReplace] параметр для очищения стека экранов
  static Future<Object?>? pushNamed(
    String routeName, {
    NavigatorState? navigator,
    Object? arguments,
    bool isReplace = false,
  }) async {
    final navigatorToPush = navigator ?? rootNavigator;
    return Future.delayed(Duration.zero, () async {
      if (isReplace) {
        return await navigatorToPush?.pushNamedAndRemoveUntil(
          routeName,
          (route) => false,
        );
      } else {
        return await navigatorToPush?.pushNamed(
          routeName,
          arguments: arguments,
        );
      }
    });
  }

  /// Функция возврата на предыдущий экран
  /// [navigator] параметр для саб-навигатора
  /// [result] возвращаемый результат
  static Future<void> pop<T extends Object>({
    NavigatorState? navigator,
    T? result,
    bool isFirst = false,
  }) async {
    final navigatorToPop = navigator ?? rootNavigator;
    return Future.delayed(Duration.zero, () {
      if (navigatorToPop != null) {
        if (isFirst) {
          return navigatorToPop.popUntil((route) => route.isFirst);
        } else {
          return navigatorToPop.pop(result);
        }
      }
    });
  }
}
