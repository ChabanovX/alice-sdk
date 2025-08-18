// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/material.dart';

/// Менеджер для управления позицией виджетов относительно BottomSheet
class BottomSheetManager {
  static final BottomSheetManager _instance = BottomSheetManager._internal();
  factory BottomSheetManager() => _instance;
  BottomSheetManager._internal();

  /// Notifier для высоты модального BottomSheet
  final ValueNotifier<double> modalBottomSheetHeight =
      ValueNotifier<double>(0.0);

  /// Notifier для высоты обычного bottomSheet в Scaffold
  final ValueNotifier<double> scaffoldBottomSheetHeight =
      ValueNotifier<double>(0.0);

  /// Notifier для режима отображения модального BottomSheet
  final ValueNotifier<bool> isModalFullscreen = ValueNotifier<bool>(true);

  /// Устанавливает высоту модального BottomSheet
  void setModalBottomSheetHeight(double height) {
    modalBottomSheetHeight.value = height;
  }

  /// Сбрасывает высоту модального BottomSheet
  void resetModalBottomSheetHeight() {
    modalBottomSheetHeight.value = 0.0;
    isModalFullscreen.value = true; // Сбрасываем и режим
  }

  /// Устанавливает высоту обычного bottomSheet в Scaffold
  void setScaffoldBottomSheetHeight(double height) {
    scaffoldBottomSheetHeight.value = height;
  }

  /// Устанавливает режим отображения модального BottomSheet
  void setModalDisplayMode(bool isFullscreen) {
    isModalFullscreen.value = isFullscreen;
  }
}
