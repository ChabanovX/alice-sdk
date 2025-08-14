import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';

/// Состояния слайд-кнопки
enum SlideActionState {
  /// Начальное состояние - желтый круг с текстом
  idle,
  
  /// Состояние свайпа - анимация удлинения
  swiping,
  
  /// Завершенное состояние - полностью удлиненный слайдер
  completed,
  
  /// Состояние анимации завершения - текст исчезает, появляется стрелочка
  completionAnimation,
}

/// Интерактивная слайд-кнопка с анимацией удлинения
class SlideActionButton extends StatefulWidget {
  const SlideActionButton({
    super.key,
    this.onSlideComplete,
    this.text = 'На месте',
    this.icon = Icons.arrow_forward,
  });

  /// Callback вызывается при завершении слайда
  final VoidCallback? onSlideComplete;
  
  /// Текст кнопки
  final String text;
  
  /// Иконка кнопки
  final IconData icon;

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

class _SlideActionButtonState extends State<SlideActionButton>
    with TickerProviderStateMixin {
  
  SlideActionState _currentState = SlideActionState.idle;
  
  // Контроллеры анимации
  late AnimationController _slideController;
  late AnimationController _completionAnimationController;
  
  // Анимации
  late Animation<double> _slideProgress;
  late Animation<double> _textOpacity;
  late Animation<double> _checkmarkOpacity;
  
  // Переменные для свайпа
  bool _isDragging = false;
  Offset _dragStartPosition = Offset.zero;
  
  // Константы
  static const double _buttonHeight = 68.0;
  static const double _buttonWidth = 347.0;
  static const double _thumbSize = 68.0;
  static const double _completionThreshold = 0.75; // 75% для автодоведения
  static const double _autoCompleteThreshold = 0.85; // 85% для автодоведения
  
  // Новые цвета
  static const Color _yellowColor = Color(0xFFFCE000);
  static const Color _backgroundColor = Color(0xFF21201F);
  static const Color _arrowColor = Color(0xFF000000);

  @override
  void initState() {
    super.initState();
    
    // Инициализация контроллеров анимации
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _completionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Увеличиваем время для задержки
      vsync: this,
    );
    
    // Настройка анимаций
    _slideProgress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Анимация исчезновения текста
    _textOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _completionAnimationController,
      curve: const Interval(0.0, 0.2, curve: Curves.easeInOut),
    ));
    
    // Анимация появления стрелочки (тик) - появляется, задерживается, исчезает
    _checkmarkOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _completionAnimationController,
      curve: const Interval(0.3, 0.5, curve: Curves.easeInOut),
    ));
    
    // Слушаем завершение анимации завершения
    _completionAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Возвращаемся в начальное положение
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _resetToIdle();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _completionAnimationController.dispose();
    super.dispose();
  }

  /// Сбрасывает виджет в начальное состояние
  void reset() {
    setState(() {
      _currentState = SlideActionState.idle;
      _isDragging = false;
    });
    _slideController.reset();
    _completionAnimationController.reset();
  }

  void _handlePanStart(DragStartDetails details) {
    if (_currentState == SlideActionState.completed || 
        _currentState == SlideActionState.completionAnimation) return;
    
    setState(() {
      _isDragging = true;
      _currentState = SlideActionState.swiping;
      _dragStartPosition = details.globalPosition;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_currentState == SlideActionState.completed || 
        _currentState == SlideActionState.completionAnimation) return;
    if (!_isDragging) return;

    final currentX = details.globalPosition.dx;
    final startX = _dragStartPosition.dx;
    final deltaX = currentX - startX;

    // Разрешаем только движение вправо
    if (deltaX > 0) {
      final maxDistance = _buttonWidth - _thumbSize;
      final clampedDistance = deltaX.clamp(0.0, maxDistance);
      
      final progress = clampedDistance / maxDistance;
      _slideController.value = progress;

      // Автодоведение при достижении 85%
      if (progress >= _autoCompleteThreshold && _currentState != SlideActionState.completed) {
        _completeSlide();
      }
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging) return;
    
    setState(() {
      _isDragging = false;
    });

    final progress = _slideController.value;
    
    if (progress >= _completionThreshold) {
      // Завершаем слайд если прошли порог
      _completeSlide();
    } else {
      // Возвращаемся в начальное состояние
      _resetToIdle();
    }
  }

  void _completeSlide() {
    setState(() {
      _currentState = SlideActionState.completed;
    });
    
    // Анимация завершения слайда
    _slideController.forward();
    
    // Тактильный отклик
    HapticFeedback.mediumImpact();
    
    // Вызываем callback
    widget.onSlideComplete?.call();
    
    // Запускаем анимацию завершения
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _currentState = SlideActionState.completionAnimation;
        });
        _completionAnimationController.forward();
      }
    });
  }

  void _resetToIdle() {
    setState(() {
      _currentState = SlideActionState.idle;
    });
    
    _slideController.reverse();
    _completionAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _buttonWidth,
      height: _buttonHeight,
      child: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _slideController,
            _completionAnimationController,
          ]),
          builder: (context, child) {
            return _buildButton();
          },
        ),
      ),
    );
  }

  Widget _buildButton() {
    final slideProgress = _slideProgress.value;
    
    // Вычисляем ширину желтого слайдера (как сыр)
    final sliderWidth = _thumbSize + (slideProgress * (_buttonWidth - _thumbSize));
    
    // Позиция ползунка (всегда справа от желтого слайдера)
    final thumbPosition = sliderWidth - _thumbSize;
    
    // Позиция текста (по центру желтого слайдера)
    final textPosition = sliderWidth / 2;

    return Stack(
      children: [
        // Желтый слайдер (как сыр)
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: sliderWidth,
            height: _buttonHeight,
            decoration: BoxDecoration(
              color: _yellowColor,
              borderRadius: BorderRadius.circular(_buttonHeight / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ),
        
        // Ползунок (круг с иконкой)
        Positioned(
          left: thumbPosition,
          top: 0,
          child: Container(
            width: _thumbSize,
            height: _thumbSize,
            decoration: BoxDecoration(
              color: _yellowColor,
              shape: BoxShape.circle,
              // Убираем тень
            ),
            child: Icon(
              widget.icon,
              color: _arrowColor,
              size: 40, // Размер стрелочки 40x40
            ),
          ),
        ),
        
        // Текст "На месте" - показываем только в состояниях idle и swiping
        if (slideProgress > 0.1 && _currentState != SlideActionState.completionAnimation)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                widget.text,
                style: context.textStyles.title.copyWith(
                  color: _backgroundColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        
        // Анимированный текст (исчезает)
        if (_currentState == SlideActionState.completionAnimation)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: _textOpacity.value,
              child: Center(
                child: Text(
                  widget.text,
                  style: context.textStyles.title.copyWith(
                    color: _backgroundColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        
        // Анимированная стрелочка (тик) - появляется, задерживается, исчезает
        if (_currentState == SlideActionState.completionAnimation)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Opacity(
                opacity: _checkmarkOpacity.value,
                child: const Icon(
                  Icons.check,
                  color: _backgroundColor,
                  size: 40,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
