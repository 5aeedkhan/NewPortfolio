import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that reveals its child with a fade + slide animation when it
/// scrolls into view. Pass a [scrollController] from the parent ScrollView
/// so this widget can listen to scroll offsets and trigger the reveal.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;
  final bool enabled;
  final ScrollController? scrollController;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.beginOffset = const Offset(0, 0.08),
    this.enabled = true,
    this.scrollController,
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
      _hasAnimated = true;
    } else {
      // Listen to scroll controller if provided
      widget.scrollController?.addListener(_onScroll);

      // Check on next frame if widget is already in viewport
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _checkVisibility();
      });
    }
  }

  void _onScroll() {
    if (!_hasAnimated) _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final viewportHeight = MediaQuery.of(context).size.height;
    final widgetPos = renderBox.localToGlobal(Offset.zero);
    final widgetTop = widgetPos.dy;
    final widgetBottom = widgetTop + renderBox.size.height;

    // If widget is in viewport, animate it
    if (widgetBottom > 50 && widgetTop < viewportHeight * 0.9) {
      _hasAnimated = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _hasAnimated) {
      // Once animated, just show the child without transitions
      return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
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
  final ScrollController? scrollController;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 1500),
    this.suffix = '',
    this.prefix = '',
    this.style,
    this.scrollController,
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

    widget.scrollController?.addListener(_onScroll);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _onScroll() {
    if (!_hasAnimated) _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final viewportHeight = MediaQuery.of(context).size.height;
    final widgetPos = renderBox.localToGlobal(Offset.zero);
    if (widgetPos.dy < viewportHeight * 0.9) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_animation.value}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
