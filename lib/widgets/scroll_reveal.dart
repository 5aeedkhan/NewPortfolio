import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that reveals its child with a fade + slide animation when it
/// scrolls into view. Also triggers on initial build if already visible.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;
  final bool enabled;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.beginOffset = const Offset(0, 0.15),
    this.enabled = true,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (!widget.enabled) {
      _controller.value = 1.0;
    } else {
      // Check on next frame if widget is already in viewport
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _checkVisibility();
      });
    }
  }

  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final viewportHeight = MediaQuery.of(context).size.height;
      final widgetPos = renderBox.localToGlobal(Offset.zero);
      final widgetTop = widgetPos.dy;
      final widgetBottom = widgetTop + renderBox.size.height;

      // If widget is in viewport (with some margin), animate it
      if (widgetBottom > 0 && widgetTop < viewportHeight * 0.95) {
        _hasAnimated = true;
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (!_hasAnimated) {
          _checkVisibility();
        }
        return false;
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Animated counter that counts from 0 to [target] when it scrolls into view.
class AnimatedCounter extends StatefulWidget {
  final int target;
  final Duration duration;
  final String suffix;
  final String prefix;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 1500),
    this.suffix = '',
    this.prefix = '',
    this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = IntTween(begin: 0, end: widget.target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Check on next frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final viewportHeight = MediaQuery.of(context).size.height;
      final widgetPos = renderBox.localToGlobal(Offset.zero);
      if (widgetPos.dy < viewportHeight * 0.95) {
        _hasAnimated = true;
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (!_hasAnimated) _checkVisibility();
        return false;
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Text(
            '${widget.prefix}${_animation.value}${widget.suffix}',
            style: widget.style,
          );
        },
      ),
    );
  }
}
