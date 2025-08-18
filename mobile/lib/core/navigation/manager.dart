import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/chat_page/presentation/presentation.dart';
import '../../features/detailed_voice_settings/presentation/presentation.dart';
import '../../features/navigation/navigation.dart';
import '../../features/orders/presentation/bloc/orders_bloc.dart';
import '../../features/orders/presentation/ui/ui.dart';
import '../../features/profile/presentation/presentation.dart';
import '../../features/settings/presentation/presentation.dart';
import '../../widgets/bottom_sheet/measured_bottom_sheet.dart';
import 'bottom_sheet_manager.dart';

part 'router.dart';
part 'routes.dart';
part 'sub_navigator.dart';

/// Опции выбора навигатора для отображения BottomSheet
enum BottomSheetNavigator {
  /// Главный навигатор (поверх всех экранов включая bottom navigation bar)
  root,

  /// Навигатор страницы заказов
  orders,

  /// Навигатор страницы чатов
  chat,

  /// Навигатор страницы профиля
  profile,
}

/// Режим отображения BottomSheet
enum BottomSheetDisplayMode {
  /// На весь экран (поверх bottom navigation bar)
  fullscreen,

  /// Над bottom navigation bar
  aboveNavigationBar,
}

class NavigationManager {
  NavigationManager._();

  /// Ключи навигаторов приложения
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Ключи навигаторов приложения
  static final GlobalKey<NavigatorState> navigatorKeyProfilePage =
      GlobalKey<NavigatorState>();

  /// Ключи навигаторов приложения
  static final GlobalKey<NavigatorState> navigatorKeyChatPage =
      GlobalKey<NavigatorState>();

  /// Ключи навигаторов приложения
  static final GlobalKey<NavigatorState> navigatorKeyOrdersPage =
      GlobalKey<NavigatorState>();

  static final scaffoldKeyProfilePage = GlobalKey();

  /// Состояние главного навигатора
  static NavigatorState? get rootNavigator => navigatorKey.currentState;

  /// Состояние навигатора страницы профиля
  static NavigatorState? get profileNavigator =>
      navigatorKeyProfilePage.currentState;

  static NavigatorState? get chatNavigator => navigatorKeyChatPage.currentState;

  /// Состояние навигатора страницы заказов
  static NavigatorState? get ordersNavigator =>
      navigatorKeyOrdersPage.currentState;

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

  /// Функция отображает модельный экран
  /// [widget] дочерний виджет для отображения
  /// [navigator] выбор навигатора для отображения BottomSheet
  /// [displayMode] режим отображения (на весь экран или над navigation bar)
  ///
  static Future<T?> showBottomSheet<T>(
    Widget widget, {
    BottomSheetNavigator navigator = BottomSheetNavigator.root,
    BottomSheetDisplayMode displayMode = BottomSheetDisplayMode.fullscreen,
  }) {
    // Выбираем нужный контекст навигатора
    late final BuildContext targetContext;
    late final bool useRootNavigator;

    switch (navigator) {
      case BottomSheetNavigator.root:
        targetContext = context;
        useRootNavigator = true;
        break;
      case BottomSheetNavigator.orders:
        targetContext = ordersNavigator?.context ?? context;
        useRootNavigator = false;
        break;
      case BottomSheetNavigator.chat:
        targetContext = chatNavigator?.context ?? context;
        useRootNavigator = false;
        break;
      case BottomSheetNavigator.profile:
        targetContext = profileNavigator?.context ?? context;
        useRootNavigator = false;
        break;
    }

    final media = MediaQuery.of(targetContext);

    // Рассчитываем высоту в зависимости от режима отображения
    double maxHeight;
    var paddingTop = media.padding.top;

    if (displayMode == BottomSheetDisplayMode.fullscreen) {
      // На весь экран - отнимаем только верхний safe area
      if (paddingTop == 0) {
        paddingTop =
            WidgetsBinding.instance.platformDispatcher.views.first.padding.top /
                2;
      }
      maxHeight = media.size.height - paddingTop;
    } else {
      // Над navigation bar - отнимаем дополнительно высоту navigation bar (82px)
      const bottomNavigationHeight = 82.0;
      final bottomPadding = media.padding.bottom;

      if (paddingTop == 0) {
        paddingTop =
            WidgetsBinding.instance.platformDispatcher.views.first.padding.top /
                2;
      }
      maxHeight = media.size.height -
          paddingTop -
          bottomNavigationHeight -
          bottomPadding;
    }

    // Передаем информацию о режиме отображения в BottomSheetManager
    BottomSheetManager().setModalDisplayMode(
      displayMode == BottomSheetDisplayMode.fullscreen,
    );

    final future = showModalBottomSheet<T>(
      isScrollControlled: true,
      useRootNavigator: useRootNavigator,
      context: targetContext,
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: media.size.width,
      ),
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) => MeasuredBottomSheet(
        child: Padding(
          padding: EdgeInsets.only(
            top: 4,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(child: widget),
        ),
      ),
    );

    // Дополнительная защита - сбрасываем высоту при закрытии
    future.whenComplete(() {
      BottomSheetManager().resetModalBottomSheetHeight();
    });

    return future;
  }
}
