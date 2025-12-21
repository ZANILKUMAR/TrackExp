import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/category.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> categorySpending;
  final List<Category> categories;

  const PieChartWidget({
    super.key,
    required this.categorySpending,
    required this.categories,
  });

  // Enhanced color palette for better visual distinction
  static const List<Color> defaultColorPalette = [
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFF8B5CF6), // Violet
    Color(0xFF06B6D4), // Cyan
    Color(0xFFF97316), // Orange
    Color(0xFF14B8A6), // Teal
    Color(0xFFEF4444), // Red
    Color(0xFF3B82F6), // Blue
    Color(0xFFA855F7), // Purple
    Color(0xFF22C55E), // Green
    Color(0xFFEAB308), // Yellow
    Color(0xFF84CC16), // Lime
    Color(0xFF0EA5E9), // Sky
    Color(0xFFD946EF), // Fuchsia
  ];

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
    return defaultColorPalette[index % defaultColorPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    if (categorySpending.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No spending data')),
      );
    }

    final total = categorySpending.values.fold(0.0, (sum, val) => sum + val);

    return SizedBox(
      height: 250,
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
                    title: percentage > 5 ? '${percentage.toStringAsFixed(1)}%' : '',
                    color: color,
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    badgeWidget: percentage <= 5 
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          )
                        : null,
                    badgePositionPercentageOffset: 1.3,
                  );
                }).toList(),
                sectionsSpace: 3,
                centerSpaceRadius: 50,
                borderData: FlBorderData(show: false),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                  enabled: true,
                ),
              ),
            ),
          ),
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
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 3,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
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
