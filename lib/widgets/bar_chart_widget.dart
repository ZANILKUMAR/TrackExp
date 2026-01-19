import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../utils/format_helper.dart';
import '../constants/design_system.dart';

class BarChartWidget extends ConsumerWidget {
  final DateTime currentMonth;

  const BarChartWidget({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
    
    final gridColor = isDark ? FinvixChartStyles.gridLineDark : FinvixChartStyles.gridLine;
    final textColor = isDark ? FinvixColors.darkTextSecondary : FinvixColors.textSecondary;

    return SizedBox(
      height: 250,
      child: Container(
        padding: const EdgeInsets.all(FinvixSpacing.md),
        decoration: BoxDecoration(
          color: isDark 
            ? FinvixColors.darkSurfaceDim.withOpacity(0.5) 
            : FinvixColors.surfaceDim.withOpacity(0.5),
          borderRadius: FinvixRadius.radiusLg,
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.06) : FinvixColors.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            maxY: adjustedMaxY,
            groupsSpace: 20,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipRoundedRadius: 8,
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: FinvixSpacing.md,
                  vertical: FinvixSpacing.sm,
                ),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final value = rod.toY;
                  final type = rodIndex == 0 ? 'Income' : 'Expense';
                  return BarTooltipItem(
                    '$type\n',
                    FinvixTypography.labelSmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    children: [
                      TextSpan(
                        text: FormatHelper.formatCurrency(value),
                        style: FinvixTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                      padding: const EdgeInsets.only(top: FinvixSpacing.sm),
                      child: Text(
                        FormatHelper.getMonthName(month.month).substring(0, 3),
                        style: FinvixTypography.caption.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return Text(
                      '0',
                      style: FinvixTypography.caption.copyWith(color: textColor),
                    );
                  }
                  String text;
                  if (value >= 10000000) {
                    text = '${(value / 10000000).toStringAsFixed(1)}Cr';
                  } else if (value >= 100000) {
                    text = '${(value / 100000).toStringAsFixed(0)}L';
                  } else if (value >= 1000) {
                    text = '${(value / 1000).toStringAsFixed(0)}k';
                  } else {
                    text = value.toInt().toString();
                  }
                  return Text(
                    text,
                    style: FinvixTypography.caption.copyWith(color: textColor),
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
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: monthsData.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barsSpace: 3,
              barRods: [
                BarChartRodData(
                  toY: entry.value.income == 0 ? 0.01 : entry.value.income,
                  color: FinvixChartStyles.barIncome,
                  width: 10,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: adjustedMaxY,
                    color: FinvixChartStyles.barIncome.withOpacity(0.05),
                  ),
                ),
                BarChartRodData(
                  toY: entry.value.expense == 0 ? 0.01 : entry.value.expense,
                  color: FinvixChartStyles.barExpense,
                  width: 10,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: adjustedMaxY,
                    color: FinvixChartStyles.barExpense.withOpacity(0.05),
                  ),
                ),
              ],
            );
          }).toList(),
          ),
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
