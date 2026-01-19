import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/category.dart';
import '../constants/design_system.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> categorySpending;
  final List<Category> categories;

  const PieChartWidget({
    super.key,
    required this.categorySpending,
    required this.categories,
  });

  Color _getCategoryColor(String categoryId, int index) {
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(
        id: 'unknown',
        name: 'Unknown',
        type: 'expense',
        colorValue: null,
      ),
    );
    
    // Use category's custom color if available, otherwise use palette
    if (category.colorValue != null) {
      return Color(category.colorValue!);
    }
    
    // Use color from palette, cycling if more categories than colors
    return FinvixChartStyles.pieChartPalette[index % FinvixChartStyles.pieChartPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (categorySpending.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No spending data',
            style: FinvixTypography.bodyMedium.copyWith(
              color: isDark ? FinvixColors.darkTextSecondary : FinvixColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final total = categorySpending.values.fold(0.0, (sum, val) => sum + val);

    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sections: categorySpending.entries.toList().asMap().entries.map((mapEntry) {
                  final index = mapEntry.key;
                  final entry = mapEntry.value;
                  
                  final percentage = (entry.value / total * 100);
                  final color = _getCategoryColor(entry.key, index);
                  
                  return PieChartSectionData(
                    value: entry.value,
                    title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                    color: color,
                    radius: 65,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    badgeWidget: percentage <= 5 && percentage > 0
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? FinvixColors.darkSurfaceDim : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: FinvixShadows.elevationSm,
                            ),
                            child: Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          )
                        : null,
                    badgePositionPercentageOffset: 1.35,
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 45,
                borderData: FlBorderData(show: false),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                  enabled: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: FinvixSpacing.md),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categorySpending.entries.toList().asMap().entries.map((mapEntry) {
                  final index = mapEntry.key;
                  final entry = mapEntry.value;
                  
                  final category = categories.firstWhere(
                    (c) => c.id == entry.key,
                    orElse: () => Category(
                      id: 'unknown',
                      name: 'Unknown',
                      type: 'expense',
                      colorValue: null,
                    ),
                  );
                  
                  final color = _getCategoryColor(entry.key, index);
                  final percentage = (entry.value / total * 100);
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: FinvixSpacing.xs),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: FinvixSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: FinvixTypography.labelSmall.copyWith(
                                  color: isDark ? FinvixColors.darkTextPrimary : FinvixColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: FinvixTypography.caption.copyWith(
                                  color: isDark ? FinvixColors.darkTextTertiary : FinvixColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
