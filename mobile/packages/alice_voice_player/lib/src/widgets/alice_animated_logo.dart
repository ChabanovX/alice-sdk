import 'package:flutter/material.dart';

import '../alice_voice_player.dart';
import '../models/playback_state.dart';

/// An animated logo widget that responds to Alice Voice Assistant playback state
/// 
/// This widget automatically connects to the Alice Voice Assistant instance
/// and animates based on the current playback state and amplitude.
/// 
/// Features:
/// - Automatic pulsing animation based on audio amplitude
/// - Customizable logo image and colors
/// - Smooth transitions between states
/// - Optional glow effect during playback
/// - Configurable size and animation parameters
/// 
/// Example:
/// ```dart
/// AliceAnimatedLogo(
///   logoPath: 'assets/images/alice.png',
///   size: 100,
///   glowColor: Colors.blue,
/// )
/// ```
class AliceAnimatedLogo extends StatefulWidget {
  /// Creates an animated Alice logo widget
  const AliceAnimatedLogo({
    super.key,
    this.logoPath = 'assets/images/alice.png',
    this.size = 80.0,
    this.glowColor = Colors.blue,
    this.backgroundColor = Colors.transparent,
    this.animationDuration = const Duration(milliseconds: 100),
    this.pulseIntensity = 0.3,
    this.showGlow = true,
    this.showRipple = true,
    this.alice,
  });

  /// Path to the logo image asset
  final String logoPath;

  /// Size of the logo (width and height)
  final double size;

  /// Color of the glow effect during playback
  final Color glowColor;

  /// Background color of the widget
  final Color backgroundColor;

  /// Duration of amplitude-based animations
  final Duration animationDuration;

  /// Intensity of the pulse effect (0.0 to 1.0)
  final double pulseIntensity;

  /// Whether to show glow effect during playback
  final bool showGlow;

  /// Whether to show ripple effect during playback
  final bool showRipple;

  /// Optional Alice Voice Assistant instance
  /// If not provided, will use the default singleton
  final AliceVoiceAssistant? alice;

  @override
  State<AliceAnimatedLogo> createState() => _AliceAnimatedLogoState();
}

class _AliceAnimatedLogoState extends State<AliceAnimatedLogo>
    with TickerProviderStateMixin {
  late AliceVoiceAssistant _alice;
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  
  PlaybackState _currentState = PlaybackState.initial;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _alice = widget.alice ?? AliceVoiceAssistant();
    _initializeAnimations();
    _startListening();
  }

  void _initializeAnimations() {
    // Pulse animation for amplitude response
    _pulseController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0 + widget.pulseIntensity,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Ripple animation for playback indication
    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  void _startListening() {
    if (_isListening) return;
    
    _alice.playbackState.listen((state) {
      if (!mounted) return;
      
      setState(() {
        _currentState = state;
      });
      
      _updateAnimations(state);
    });
    
    _isListening = true;
  }

  void _updateAnimations(PlaybackState state) {
    if (state.isPlaying) {
      // Start ripple animation if not already running
      if (widget.showRipple && !_rippleController.isAnimating) {
        _rippleController.repeat();
      }
      
      // Update pulse based on amplitude
      final targetScale = 1.0 + (state.amplitude * widget.pulseIntensity);
      _pulseController.animateTo(
        (targetScale - 1.0) / widget.pulseIntensity,
        duration: widget.animationDuration,
      );
    } else {
      // Stop animations when not playing
      _rippleController.stop();
      _rippleController.reset();
      _pulseController.animateTo(0.0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple effect
          if (widget.showRipple && _currentState.isPlaying)
            _buildRippleEffect(),
          
          // Main logo with pulse and glow
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.backgroundColor,
                    boxShadow: widget.showGlow && _currentState.isPlaying
                        ? [
                            BoxShadow(
                              color: widget.glowColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: widget.glowColor.withOpacity(0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      widget.logoPath,
                      width: widget.size,
                      height: widget.size,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: Icon(
                            Icons.mic,
                            size: widget.size * 0.5,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Error indicator
          if (_currentState.error != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRippleEffect() {
    return AnimatedBuilder(
      animation: _rippleAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size + (_rippleAnimation.value * widget.size * 0.5),
          height: widget.size + (_rippleAnimation.value * widget.size * 0.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.glowColor.withOpacity(
                (1.0 - _rippleAnimation.value) * 0.3,
              ),
              width: 2.0,
            ),
          ),
        );
      },
    );
  }
}

/// A more advanced animated logo with customizable wave patterns
/// 
/// This widget provides additional visual effects like sound waves
/// and more sophisticated animations.
class AliceAnimatedLogoAdvanced extends StatefulWidget {
  /// Creates an advanced animated Alice logo widget
  const AliceAnimatedLogoAdvanced({
    super.key,
    this.logoPath = 'assets/images/alice.png',
    this.size = 120.0,
    this.waveColor = Colors.blue,
    this.backgroundColor = Colors.transparent,
    this.showSoundWaves = true,
    this.waveCount = 3,
    this.alice,
  });

  /// Path to the logo image asset
  final String logoPath;

  /// Size of the logo (width and height)
  final double size;

  /// Color of the sound waves
  final Color waveColor;

  /// Background color of the widget
  final Color backgroundColor;

  /// Whether to show sound wave animation
  final bool showSoundWaves;

  /// Number of sound wave circles
  final int waveCount;

  /// Optional Alice Voice Assistant instance
  final AliceVoiceAssistant? alice;

  @override
  State<AliceAnimatedLogoAdvanced> createState() => _AliceAnimatedLogoAdvancedState();
}

class _AliceAnimatedLogoAdvancedState extends State<AliceAnimatedLogoAdvanced>
    with TickerProviderStateMixin {
  late AliceVoiceAssistant _alice;
  late AnimationController _waveController;
  late List<Animation<double>> _waveAnimations;
  
  PlaybackState _currentState = PlaybackState.initial;

  @override
  void initState() {
    super.initState();
    _alice = widget.alice ?? AliceVoiceAssistant();
    _initializeAnimations();
    _startListening();
  }

  void _initializeAnimations() {
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _waveAnimations = List.generate(
      widget.waveCount,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _waveController,
        curve: Interval(
          index / widget.waveCount,
          1.0,
          curve: Curves.easeOut,
        ),
      )),
    );
  }

  void _startListening() {
    _alice.playbackState.listen((state) {
      if (!mounted) return;
      
      setState(() {
        _currentState = state;
      });
      
      if (state.isPlaying && widget.showSoundWaves) {
        _waveController.repeat();
      } else {
        _waveController.stop();
        _waveController.reset();
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sound waves
          if (widget.showSoundWaves && _currentState.isPlaying)
            ..._buildSoundWaves(),
          
          // Main logo
          Container(
            width: widget.size * 0.6,
            height: widget.size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.backgroundColor,
              boxShadow: _currentState.isPlaying
                  ? [
                      BoxShadow(
                        color: widget.waveColor.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
            child: ClipOval(
              child: Image.asset(
                widget.logoPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Icon(
                      Icons.record_voice_over,
                      size: widget.size * 0.3,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSoundWaves() {
    return _waveAnimations.map((animation) {
      
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final progress = animation.value;
          final opacity = (1.0 - progress) * 0.3;
          final scale = 0.6 + (progress * 0.4);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.waveColor.withOpacity(opacity),
                  width: 2.0,
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}
