import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../models/message.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isNewMessage;

  const MessageBubble({
    super.key,
    required this.message,
    this.isNewMessage = false,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isNewMessage) {
      _startAnimation();
    } else {
      _slideController.value = 1.0;
      _fadeController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _fadeController]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Align(
              alignment: widget.message.isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.message.isMe ? context.colors.controlMain : context.colors.semanticControlMiror,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.message.hasAction) ...[
                      GestureDetector(
                        onTap: () {
                          widget.message.onActionStateChanged?.call(!widget.message.isPaused);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.colors.semanticLine.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.message.isPaused ? Icons.volume_up : Icons.pause,
                                size: 16,
                                color: context.colors.text,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.message.isPaused ? 'Озвучить' : 'Остановить',
                                style: context.textStyles.mediumSmall.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      widget.message.text,
                      style: context.textStyles.body.copyWith(
                        color: widget.message.isMe ? context.colors.semanticText : context.colors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(widget.message.timestamp),
                      style: context.textStyles.caption.copyWith(
                        color: widget.message.isMe 
                            ? context.colors.semanticText.withOpacity(0.6) 
                            : context.colors.textMiror,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}