import 'package:flutter/material.dart';
import '../constants/design_system.dart';

/// Skeleton loader for summary cards
class SummaryCardSkeleton extends StatelessWidget {
  const SummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinvixSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: FinvixRadius.radiusLg,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          _SkeletonBox(
            width: 80,
            height: 16,
            borderRadius: FinvixRadius.radiusSm,
          ),
          const SizedBox(height: FinvixSpacing.md),
          // Amount skeleton
          _SkeletonBox(
            width: double.infinity,
            height: 24,
            borderRadius: FinvixRadius.radiusSm,
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for chart widget
class ChartSkeleton extends StatelessWidget {
  final double height;

  const ChartSkeleton({
    super.key,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(FinvixSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: FinvixRadius.radiusLg,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          _SkeletonBox(
            width: 120,
            height: 18,
            borderRadius: FinvixRadius.radiusSm,
          ),
          const SizedBox(height: FinvixSpacing.lg),
          // Chart area skeleton (shimmer effect)
          Expanded(
            child: Center(
              child: _SkeletonBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: FinvixRadius.radiusMd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for transaction list item
class TransactionItemSkeleton extends StatelessWidget {
  const TransactionItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FinvixSpacing.lg,
        vertical: FinvixSpacing.md,
      ),
      child: Row(
        children: [
          // Icon skeleton
          _SkeletonBox(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: FinvixSpacing.lg),
          // Details skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(
                  width: 120,
                  height: 16,
                  borderRadius: FinvixRadius.radiusSm,
                ),
                const SizedBox(height: 8),
                _SkeletonBox(
                  width: 80,
                  height: 14,
                  borderRadius: FinvixRadius.radiusSm,
                ),
              ],
            ),
          ),
          // Amount skeleton
          _SkeletonBox(
            width: 60,
            height: 16,
            borderRadius: FinvixRadius.radiusSm,
          ),
        ],
      ),
    );
  }
}

/// Base skeleton box with shimmer effect
class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const _SkeletonBox({
    this.width = double.infinity,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDarkMode
              ? [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ]
              : [
                  Colors.grey[300]!,
                  Colors.grey[200]!,
                  Colors.grey[300]!,
                ],
        ),
        backgroundBlendMode: BlendMode.overlay,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: [
            0,
            _animationController.value,
            _animationController.value + 0.1,
          ],
        ),
      ),
    );
  }
}
