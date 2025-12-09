import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../utils/format_helper.dart';

class BarChartWidget extends ConsumerWidget {
  final DateTime currentMonth;

  const BarChartWidget({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(transactionRepositoryProvider);
    
    // Get last 6 months data
    final List<_MonthData> monthsData = [];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(currentMonth.year, currentMonth.month - i);
      final transactions = repository.getMonthlyTransactions(month.year, month.month);
      
      final income = transactions
          .where((t) => t.type == 'income')
          .fold(0.0, (sum, t) => sum + t.amount);
      
      final expense = transactions
          .where((t) => t.type == 'expense')
          .fold(0.0, (sum, t) => sum + t.amount);
      
      monthsData.add(_MonthData(month, income, expense));
    }

    final maxY = monthsData.fold<double>(
      0,
      (max, data) => [max, data.income, data.expense].reduce((a, b) => a > b ? a : b),
    );

    // Handle case when there's no data
    final adjustedMaxY = maxY == 0 ? 1000.0 : maxY * 1.2;
    final interval = maxY == 0 ? 200.0 : maxY / 5;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: adjustedMaxY,
          groupsSpace: 24,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final month = monthsData[group.x.toInt()].month;
                final value = rod.toY;
                final type = rodIndex == 0 ? 'Income' : 'Expense';
                return BarTooltipItem(
                  '$type\n${FormatHelper.getMonthName(month.month)}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: FormatHelper.formatCurrency(value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < monthsData.length) {
                    final month = monthsData[value.toInt()].month;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        FormatHelper.getMonthName(month.month).substring(0, 3),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const Text('0', style: TextStyle(fontSize: 10));
                  }
                  if (value >= 10000000) {
                    return Text(
                      '${(value / 10000000).toStringAsFixed(1)}Cr',
                      style: const TextStyle(fontSize: 9),
                    );
                  }
                  if (value >= 100000) {
                    return Text(
                      '${(value / 100000).toStringAsFixed(0)}L',
                      style: const TextStyle(fontSize: 9),
                    );
                  }
                  if (value >= 1000) {
                    return Text(
                      '${(value / 1000).toStringAsFixed(0)}k',
                      style: const TextStyle(fontSize: 9),
                    );
                  }
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 9),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
          ),
          borderData: FlBorderData(show: false),
          barGroups: monthsData.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barsSpace: 2,
              barRods: [
                BarChartRodData(
                  toY: entry.value.income == 0 ? 0.01 : entry.value.income,
                  color: Colors.green,
                  width: 8,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                  ),
                ),
                BarChartRodData(
                  toY: entry.value.expense == 0 ? 0.01 : entry.value.expense,
                  color: Colors.red,
                  width: 8,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MonthData {
  final DateTime month;
  final double income;
  final double expense;

  _MonthData(this.month, this.income, this.expense);
}
