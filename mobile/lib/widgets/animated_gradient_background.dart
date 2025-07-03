import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientBackground({
    Key? key,
    required this.child,
    this.colors = const [
      Color(0xFF12211A),
      Color(0xFF1a2f21),
      Color(0xFF234733),
    ],
    this.duration = const Duration(seconds: 8),
  }) : super(key: key);

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(widget.colors[0], widget.colors[1], _animation.value)!,
                      Color.lerp(widget.colors[1], widget.colors[2], _animation.value)!,
                      Color.lerp(widget.colors[2], widget.colors[0], _animation.value)!,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              );
            },
          ),
          
          // Floating gradient circles
          _buildFloatingCircle(
            top: 146,
            right: -50,
            size: 394,
            color: const Color(0xFFEF42B5),
            animationOffset: 0.0,
          ),
          
          _buildFloatingCircle(
            bottom: 200,
            left: -52,
            size: 366,
            color: const Color(0xFF0AD842),
            animationOffset: 0.5,
          ),
          
          // Content
          widget.child,
        ],
      ),
    );
  }

  Widget _buildFloatingCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required double animationOffset,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animValue = (_animation.value + animationOffset) % 1.0;
        final scaleFactor = 0.9 + (0.2 * animValue);
        final opacityFactor = 0.3 + (0.4 * animValue);
        
        return Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: Transform.scale(
            scale: scaleFactor,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(opacityFactor),
                    color.withOpacity(opacityFactor * 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}