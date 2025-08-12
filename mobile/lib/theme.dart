import 'package:flutter/material.dart';

// =====================
// Main colors
// Main colors
// =====================
class MainColors {
  // Semantic/Text
  static const Color semanticText = Color(0xFF000000);
  // Text Miror (keep spelling as in Figma)
  static const Color textMiror = Color(0xFF908F8F);
  // Text
  static const Color text = Color(0xFF21201F);

  // Semantic/Background
  static const Color semanticBackground = Color(0xFFFFFFFF);
  // Semantic/Control Miror (keep spelling)
  static const Color semanticControlMiror = Color(0xFFF5F4F2);
  // Semantic/Background Mirror
  static const Color semanticBackgroundMirror = Color(0xFFEFEEEE);
  // Semantic/Line
  static const Color semanticLine = Color(0xFFBFC0C0);

  // Control Main (Primary)
  static const Color controlMain = Color(0xFFFCE000);
  // Alice Main (Secondary)
  static const Color aliceMain = Color(0xFFF1C214);
  // Badge
  static const Color badge = Color(0xFFFC5230);
  // Cash (Tertiary)
  static const Color cash = Color(0xFFC81EFA);

  // Effects Badge / Notification / Button (all white surfaces)
  static const Color effectsBadge = Color(0xFFFFFFFF);
  static const Color effectsNotification = Color(0xFFFFFFFF);
  static const Color effectsButton = Color(0xFFFFFFFF);

  // Error palette (Material default, not specified in Figma)
  static const Color error = Color(0xFFB3261E);
  static const Color onErrorHighContrast = Colors.white;
}

// (Упрощено по PR) Убраны ThemeExtension-токены: layout/shadows/state layers

// =====================
// Utilities
// =====================
Color _onColorFor(Color background) {
  // Choose black or white based on luminance for sufficient contrast
  return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

// =====================
// ColorSchemes
// =====================
ColorScheme _buildLightColorScheme() {
  const primary = MainColors.controlMain; // taxi yellow
  const secondary = MainColors.aliceMain;
  const tertiary = MainColors.cash;
  return ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: _onColorFor(primary),
    primaryContainer: const Color(0xFFFFF170),
    onPrimaryContainer: Colors.black,
    secondary: secondary,
    onSecondary: _onColorFor(secondary),
    secondaryContainer: const Color(0xFFFFE089),
    onSecondaryContainer: Colors.black,
    tertiary: tertiary,
    onTertiary: _onColorFor(tertiary),
    tertiaryContainer: const Color(0xFFE9C6FF),
    onTertiaryContainer: Colors.black,
    error: MainColors.error,
    onError: MainColors.onErrorHighContrast,
    errorContainer: const Color(0xFFF9DEDC),
    onErrorContainer: const Color(0xFF410E0B),
    surface: MainColors.semanticBackground,
    onSurface: MainColors.text,
    surfaceDim: MainColors.semanticControlMiror,
    surfaceBright: MainColors.semanticBackground,
    surfaceContainerLowest: MainColors.semanticBackground,
    surfaceContainerLow: MainColors.semanticControlMiror,
    surfaceContainer: MainColors.semanticBackgroundMirror,
    surfaceContainerHigh: MainColors.semanticControlMiror,
    surfaceContainerHighest: MainColors.semanticBackground,
    outline: MainColors.semanticLine,
    outlineVariant: const Color(0xFFE3E3E3),
    shadow: Colors.black.withValues(alpha: 0.12),
    scrim: Colors.black.withValues(alpha: 0.32),
    inverseSurface: const Color(0xFF121212),
    onInverseSurface: Colors.white,
    inversePrimary: const Color(0xFF745900),
    surfaceTint: primary,
  );
}

// Тёмная тема исключена согласно замечаниям PR

// =====================
// Text theme (M3-tuned)
// =====================
TextTheme _textTheme(Brightness brightness) {
  final base = brightness == Brightness.dark
      ? Typography.material2021().white
      : Typography.material2021().black;

  // Apply YandexSansText family to all styles
  final applied = base.apply(fontFamily: 'YandexSansText');

  return applied.copyWith(
    displayLarge: applied.displayLarge?.copyWith(
      letterSpacing: -0.25,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: applied.displayMedium?.copyWith(
      letterSpacing: -0.25,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: applied.displaySmall?.copyWith(
      letterSpacing: -0.15,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: applied.headlineLarge?.copyWith(
      letterSpacing: -0.15,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: applied.headlineMedium?.copyWith(
      letterSpacing: -0.15,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: applied.headlineSmall?.copyWith(
      letterSpacing: -0.1,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: applied.titleLarge?.copyWith(fontWeight: FontWeight.w400),
    titleMedium: applied.titleMedium?.copyWith(fontWeight: FontWeight.w400),
    titleSmall: applied.titleSmall?.copyWith(fontWeight: FontWeight.w400),
    bodyLarge: applied.bodyLarge?.copyWith(
      height: 1.25,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: applied.bodyMedium?.copyWith(
      height: 1.25,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: applied.bodySmall?.copyWith(
      height: 1.25,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: applied.labelLarge?.copyWith(fontWeight: FontWeight.w400),
    labelMedium: applied.labelMedium?.copyWith(fontWeight: FontWeight.w400),
    labelSmall: applied.labelSmall?.copyWith(fontWeight: FontWeight.w400),
  );
}

// =====================
// Components
// =====================
ThemeData _buildTheme(ColorScheme scheme, {required bool isDark}) {
  const radiusS = 8.0;
  const radiusM = 12.0;

  final base = ThemeData(
    useMaterial3: true,
    brightness: scheme.brightness,
    colorScheme: scheme,
    textTheme: _textTheme(scheme.brightness),
    splashFactory: InkRipple.splashFactory,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dividerColor: scheme.outlineVariant,
    disabledColor: MainColors.textMiror.withValues(alpha: 0.38),
    scaffoldBackgroundColor: scheme.surface,
    canvasColor: isDark ? scheme.surface : MainColors.semanticBackground,
    extensions: const <ThemeExtension<dynamic>>[],
  );

  // Shape scale
  final roundedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radiusM),
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: scheme.surfaceTint,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: scheme.surface,
      elevation: 0,
      surfaceTintColor: scheme.surfaceTint,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return base.textTheme.labelMedium?.copyWith(
          color: selected
              ? scheme.onSurface
              : scheme.onSurface.withValues(alpha: 0.74),
        );
      }),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary.withValues(alpha: 0.2),
      selectedIconTheme: IconThemeData(color: scheme.primary),
      unselectedIconTheme: IconThemeData(
        color: scheme.onSurface.withValues(alpha: 0.74),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: scheme.onSurface,
      unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.74),
      overlayColor: WidgetStateProperty.all(
        scheme.onSurface.withValues(alpha: 0.04),
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      modalBackgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      showDragHandle: true,
      dragHandleColor: scheme.outline,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurface,
      textColor: scheme.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS),
      ),
      selectedColor: scheme.primary,
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      shadowColor: (isDark ? Colors.black : Colors.black).withValues(
        alpha: 0.12,
      ),
      elevation: 1,
      surfaceTintColor: scheme.surfaceTint,
      shape: roundedShape,
      margin: const EdgeInsets.all(8),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
      ),
      contentTextStyle: base.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurface,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: base.textTheme.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
      actionTextColor: scheme.inversePrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: base.textTheme.labelMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
      decoration: ShapeDecoration(
        color: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 8,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      refreshBackgroundColor: scheme.surfaceContainerHighest,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return scheme.surfaceContainerHigh;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return scheme.outlineVariant;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return scheme.surfaceContainerHigh;
      }),
      checkColor: WidgetStateProperty.all(_onColorFor(scheme.primary)),
      side: BorderSide(color: scheme.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return scheme.onSurfaceVariant;
      }),
    ),
    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: scheme.surfaceContainerLow,
      selectedColor: scheme.primary.withValues(alpha: 0.16),
      checkmarkColor: scheme.onPrimary,
      disabledColor: scheme.surfaceContainerLow.withValues(alpha: 0.5),
      labelStyle: base.textTheme.labelLarge,
      shadowColor: (isDark ? Colors.black : Colors.black).withValues(
        alpha: 0.12,
      ),
      side: BorderSide(color: scheme.outlineVariant),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: _onColorFor(scheme.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      extendedPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(roundedShape),
        elevation: WidgetStateProperty.all(1),
        backgroundColor: WidgetStateProperty.all(
          scheme.surfaceContainerHighest,
        ),
        foregroundColor: WidgetStateProperty.all(scheme.onSurface),
        overlayColor: WidgetStateProperty.all(
          scheme.onSurface.withValues(alpha: 0.08),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(roundedShape),
        backgroundColor: WidgetStateProperty.all(scheme.primary),
        foregroundColor: WidgetStateProperty.all(_onColorFor(scheme.primary)),
        overlayColor: WidgetStateProperty.all(
          _onColorFor(scheme.primary).withValues(alpha: 0.08),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(roundedShape),
        side: WidgetStateProperty.all(BorderSide(color: scheme.outline)),
        foregroundColor: WidgetStateProperty.all(scheme.onSurface),
        overlayColor: WidgetStateProperty.all(
          scheme.onSurface.withValues(alpha: 0.04),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(scheme.primary),
        overlayColor: WidgetStateProperty.all(
          scheme.primary.withValues(alpha: 0.08),
        ),
        shape: WidgetStateProperty.all(roundedShape),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      hintStyle: base.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurface.withValues(alpha: 0.6),
      ),
      labelStyle: base.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurface.withValues(alpha: 0.8),
      ),
      prefixIconColor: scheme.onSurfaceVariant,
      suffixIconColor: scheme.onSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(scheme.surface),
        surfaceTintColor: WidgetStateProperty.all(scheme.surfaceTint),
        elevation: WidgetStateProperty.all(3),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: base.textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
    ),
    iconTheme: IconThemeData(
      color: isDark ? scheme.onSurface : MainColors.semanticText,
    ),
    badgeTheme: BadgeThemeData(
      backgroundColor: MainColors.badge,
      textColor: _onColorFor(MainColors.badge),
      largeSize: 22,
      smallSize: 18,
      alignment: AlignmentDirectional.topEnd,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceContainerLow,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? _onColorFor(scheme.primary)
              : scheme.onSurface,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.outlineVariant,
          ),
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      headerBackgroundColor: scheme.surface,
      headerForegroundColor: scheme.onSurface,
      dayForegroundColor: WidgetStateProperty.all(scheme.onSurface),
      todayBackgroundColor: WidgetStateProperty.all(
        scheme.primary.withValues(alpha: 0.16),
      ),
      todayForegroundColor: WidgetStateProperty.all(scheme.onSurface),
      rangePickerHeaderForegroundColor: scheme.onSurface,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: scheme.surface,
      hourMinuteColor: scheme.surfaceContainerHighest,
      hourMinuteTextColor: scheme.onSurface,
      dialHandColor: scheme.primary,
      dialBackgroundColor: scheme.surfaceContainer,
    ),
  );
}

/// Публичная фабрика светлой темы (если потребуется интеграция с ThemeData)
ThemeData get lightTheme =>
    _buildTheme(_buildLightColorScheme(), isDark: false);
// Расширение API для удобного доступа: context.colors / context.textStyles
class AppColors {
  const AppColors();

  Color get semanticText => MainColors.semanticText;
  Color get textMiror => MainColors.textMiror;
  Color get text => MainColors.text;
  Color get semanticBackground => MainColors.semanticBackground;
  Color get semanticControlMiror => MainColors.semanticControlMiror;
  Color get semanticBackgroundMirror => MainColors.semanticBackgroundMirror;
  Color get semanticLine => MainColors.semanticLine;
  Color get controlMain => MainColors.controlMain;
  Color get aliceMain => MainColors.aliceMain;
  Color get badge => MainColors.badge;
  Color get cash => MainColors.cash;
  Color get effectsBadge => MainColors.effectsBadge;
  Color get effectsNotification => MainColors.effectsNotification;
  Color get effectsButton => MainColors.effectsButton;
}

class AppTextStyles {
  const AppTextStyles();

  TextStyle get title => const TextStyle(
    fontFamily: 'YandexSansText',
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  TextStyle get body => const TextStyle(
    fontFamily: 'YandexSansText',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get caption => const TextStyle(
    fontFamily: 'YandexSansText',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  TextStyle get medium => const TextStyle(
    fontFamily: 'YandexSansText',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
    height: 1.0625,
  );

  TextStyle get mediumBig => const TextStyle(
    fontFamily: 'YandexSansText',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
    height: 1.15,
  );

  TextStyle get regular => const TextStyle(
    fontFamily: 'YandexSansText',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.0625,
  );

  TextStyle get bold => const TextStyle(
    fontFamily: 'YandexSansText',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0625,
  );
}

extension AppThemeContext on BuildContext {
  AppColors get colors => const AppColors();
  AppTextStyles get textStyles => const AppTextStyles();
}
