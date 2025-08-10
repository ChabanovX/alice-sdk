# Yandex PRO — тема приложения

## Что внутри
- `lib/theme.dart` — тема Material 3:
  - `MainColors` — цвета 1:1 с макетом Figma (Semantic/Text, Control Main, Alice Main и т. д.).
  - `AppLayoutTokens` — spacing/radius/elevation.
  - `AppShadows` — тени из макета (красная 30% y=2 blur=5; чёрная 12% y=8 blur=20).
  - `AppStateLayers` — непрозрачности состояний (hover/focus/pressed/…).
  - `lightTheme` и `darkTheme` — полностью настроенные `ThemeData`.

- `assets/fonts` — файлы шрифтов `YandexSansText`.
- `pubspec.yaml` — подключение шрифтов под семейством `YandexSansText`.

## Как использовать тему в вашем приложении
Подключите тему в корневом `MaterialApp`:
```dart
import 'package:flutter/material.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const Placeholder(),
    );
  }
}
```

## Настройка шрифтов
Семейство по умолчанию — `YandexSansText`. Все стили из `TextTheme` настроены на Regular (w400). Вы можете локально выбрать толщину:
```dart
const Text('Medium title', style: TextStyle(fontFamily: 'YandexSansText', fontWeight: FontWeight.w500));
```

## Динамические цвета / High‑contrast
По умолчанию выключены. Если нужно — создайте фабрики `lightHcTheme`/`darkHcTheme` и/или добавьте Dynamic Color (Android 12+).

## QA‑чек‑лист
- Приложение собирается и `flutter analyze` без предупреждений

## Структура токенов
- Цвета: `MainColors`
- Геометрия: `AppLayoutTokens`
- Тени: `AppShadows`
- Состояния: `AppStateLayers`
