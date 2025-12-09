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
                sections: categorySpending.entries.map((entry) {
                  final category = categories.firstWhere(
                    (c) => c.id == entry.key,
                    orElse: () => Category(
                      id: 'unknown',
                      name: 'Unknown',
                      type: 'expense',
                      colorValue: 0xFFB0B0B0,
                    ),
                  );
                  
                  final percentage = (entry.value / total * 100);
                  
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    color: category.colorValue != null
                        ? Color(category.colorValue!)
                        : Colors.grey,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categorySpending.entries.map((entry) {
                final category = categories.firstWhere(
                  (c) => c.id == entry.key,
                  orElse: () => Category(
                    id: 'unknown',
                    name: 'Unknown',
                    type: 'expense',
                    colorValue: 0xFFB0B0B0,
                  ),
                );
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: category.colorValue != null
                              ? Color(category.colorValue!)
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
