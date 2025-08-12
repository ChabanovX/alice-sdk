import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Состояния слайд-кнопки
enum SlideActionState {
  /// Дефолтное состояние - круг с обычными тенями
  defaultState,

  /// Состояние при зажатии - круг с primary цветом
  pressedState,

  /// Состояние при растягивании - прямоугольник
  stretchedState,
}

/// Интерактивная слайд-кнопка с тремя состояниями
class SlideActionButton extends StatefulWidget {
  const SlideActionButton({super.key, this.onSlideComplete});

  /// Callback вызывается при завершении слайда
  final VoidCallback? onSlideComplete;

  /// Сбрасывает виджет в дефолтное состояние
  static void reset(GlobalKey key) {
    final state = key.currentState;
    if (state is _SlideActionButtonState) {
      state.reset();
    }
  }

  @override
  State<SlideActionButton> createState() => _SlideActionButtonState();
}

/// Mixin для добавления функциональности сброса
mixin ResetMixin<T extends StatefulWidget> on State<T> {
  void reset();
}

class _SlideActionButtonState extends State<SlideActionButton>
    with TickerProviderStateMixin, ResetMixin {
  SlideActionState _currentState = SlideActionState.defaultState;
  late AnimationController _animationController;
  late AnimationController _stretchController;
  late Animation<double> _stretchAnimation;
  late Animation<double> _colorAnimation;

  double _dragDistance = 0.0;
  bool _isDragging = false;
  Offset _dragStartPosition = Offset.zero;

  static const double _defaultSize = 68.0;
  static const double _maxStretchWidth = 347.0;
  static const double _stretchThreshold =
      100.0; // Порог для активации растягивания

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _stretchController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _stretchAnimation =
        Tween<double>(begin: _defaultSize, end: _maxStretchWidth).animate(
          CurvedAnimation(
            parent: _stretchController,
            curve: Curves.easeOutCubic,
          ),
        );

    _colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stretchController.dispose();
    super.dispose();
  }

  /// Сбрасывает виджет в дефолтное состояние
  void reset() {
    setState(() {
      _currentState = SlideActionState.defaultState;
      _dragDistance = 0.0;
      _isDragging = false;
    });
    _animationController.reset();
    _stretchController.reset();
  }

  void _handleTapDown(TapDownDetails details) {
    // Если виджет заблокирован в состоянии 3, ничего не делаем
    if (_currentState == SlideActionState.stretchedState) return;

    setState(() {
      _currentState = SlideActionState.pressedState;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    // Если виджет заблокирован в состоянии 3, ничего не делаем
    if (_currentState == SlideActionState.stretchedState) return;

    if (_currentState == SlideActionState.pressedState) {
      setState(() {
        _currentState = SlideActionState.defaultState;
      });
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    // Если виджет заблокирован в состоянии 3, ничего не делаем
    if (_currentState == SlideActionState.stretchedState) return;

    if (_currentState == SlideActionState.pressedState) {
      setState(() {
        _currentState = SlideActionState.defaultState;
      });
      _animationController.reverse();
    }
  }

  void _handlePanStart(DragStartDetails details) {
    // Если виджет заблокирован в состоянии 3, ничего не делаем
    if (_currentState == SlideActionState.stretchedState) return;

    setState(() {
      _isDragging = true;
      _currentState = SlideActionState.pressedState;
      _dragStartPosition = details.globalPosition;
      _dragDistance = 0.0;
    });
    _animationController.forward();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    // Если виджет заблокирован в состоянии 3, ничего не делаем
    if (_currentState == SlideActionState.stretchedState) return;
    if (!_isDragging) return;

    // Вычисляем расстояние только по горизонтали от начальной позиции
    final currentX = details.globalPosition.dx;
    final startX = _dragStartPosition.dx;
    final deltaX = currentX - startX;

    // Разрешаем только движение вправо (положительные значения)
    if (deltaX > 0) {
      setState(() {
        _dragDistance = deltaX.clamp(0.0, _stretchThreshold);
      });

      // Анимация растягивания
      final progress = (_dragDistance / _stretchThreshold).clamp(0.0, 1.0);
      _stretchController.value = progress;

      if (progress >= 1.0) {
        setState(() {
          _currentState = SlideActionState.stretchedState;
        });
      }
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    // Если виджет заблокирован в состоянии 3, ничего не делаем
    //if (_currentState == SlideActionState.stretchedState) return;
    if (!_isDragging) return;

    setState(() {
      _isDragging = false;
    });

    if (_currentState == SlideActionState.stretchedState) {
      // Остаемся в растянутом состоянии - виджет заблокирован
      widget.onSlideComplete?.call();
    } else {
      // Возвращаемся в дефолтное состояние только если не достигли состояния 3
      setState(() {
        _currentState = SlideActionState.defaultState;
        _dragDistance = 0.0;
      });
      _animationController.reverse();
      _stretchController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 347,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _animationController,
            _stretchController,
          ]),
          builder: (context, child) {
            final currentWidth = _stretchAnimation.value;
            final isPrimaryColor = _colorAnimation.value;

            Color buttonColor;
            switch (_currentState) {
              case SlideActionState.defaultState:
                buttonColor = colors.surface;
                break;
              case SlideActionState.pressedState:
                buttonColor = Color.lerp(
                  colors.surface,
                  colors.primary,
                  isPrimaryColor,
                )!;
                break;
              case SlideActionState.stretchedState:
                buttonColor = colors.primary;
                break;
            }

            return Align(
              alignment: Alignment.centerLeft, // Выравниваем по левому краю
              child: Container(
                width: currentWidth,
                height: _defaultSize,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(_defaultSize / 2),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      offset: const Offset(0, 8),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Stack(children: [_buildIcon(colors)]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colors) {
    IconData iconData;
    Color iconColor;

    switch (_currentState) {
      case SlideActionState.defaultState:
        iconData = Icons.arrow_forward;
        iconColor = colors.onSurface;
        break;
      case SlideActionState.pressedState:
        iconData = Icons.arrow_forward;
        iconColor = colors.onPrimary;
        break;
      case SlideActionState.stretchedState:
        iconData = Icons.arrow_forward;
        iconColor = colors.onPrimary;
        break;
    }

    if (_currentState == SlideActionState.stretchedState) {
      // Иконка справа с отступом
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: Icon(iconData, size: 40, color: iconColor),
        ),
      );
    } else if (_isDragging && _dragDistance > 0) {
      // Иконка следует за пальцем при перетаскивании
      final progress = (_dragDistance / _stretchThreshold).clamp(0.0, 1.0);

      // Вычисляем позицию иконки от центра до правого края
      final centerPosition = _defaultSize / 2;
      final maxRightPosition =
          _stretchAnimation.value - 34; // 14 + 20 (отступ + половина иконки)
      final iconPosition =
          centerPosition + (maxRightPosition - centerPosition) * progress;

      return Positioned(
        left: iconPosition - 20, // Центрируем иконку (40/2 = 20)
        top: (_defaultSize - 40) / 2,
        child: Icon(iconData, size: 40, color: iconColor),
      );
    } else {
      // Иконка по центру
      return Center(child: Icon(iconData, size: 40, color: iconColor));
    }
  }
}
