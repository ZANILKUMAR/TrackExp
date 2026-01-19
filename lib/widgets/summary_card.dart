import 'package:flutter/material.dart';
import '../utils/format_helper.dart';
import '../constants/design_system.dart';

class SummaryCard extends StatefulWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: FinvixAnimations.durationLg,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: FinvixAnimations.premium),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: FinvixAnimations.smooth),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Softer, more premium gradient
    final gradientColors = isDark
      ? [
          widget.color.withOpacity(0.85),
          widget.color.withOpacity(0.65),
        ]
      : [
          widget.color.withOpacity(0.9),
          widget.color.withOpacity(0.75),
        ];
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: FinvixRadius.radiusLg,
            boxShadow: [
              FinvixShadows.coloredShadow(widget.color, opacity: isDark ? 0.3 : 0.2),
            ],
          ),
          child: ClipRRect(
            borderRadius: FinvixRadius.radiusLg,
            child: Container(
              padding: const EdgeInsets.all(FinvixSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with title and icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: FinvixTypography.labelLarge.copyWith(
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(FinvixSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: FinvixRadius.radiusMd,
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FinvixSpacing.lg),
                  
                  // Amount display with animated number feel
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      FormatHelper.formatCurrency(widget.amount),
                      style: FinvixTypography.currencyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
