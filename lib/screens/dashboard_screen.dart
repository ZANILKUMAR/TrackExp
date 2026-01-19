import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../utils/format_helper.dart';
import '../widgets/summary_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/recent_transactions_widget.dart';
import '../constants/design_system.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(currentMonthProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpense = ref.watch(monthlyExpenseProvider);
    final monthlySavings = ref.watch(monthlySavingsProvider);
    final categorySpending = ref.watch(categoryWiseSpendingProvider);
    final categories = ref.watch(categoriesProvider).value ?? [];
    final monthlyTransactions = ref.watch(monthlyTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: FinvixSpacing.lg),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/logo.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ).createShader(bounds),
                child: Text(
                  'Finvix',
                  style: FinvixTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(currentMonthProvider.notifier).state = DateTime(
                currentMonth.year,
                currentMonth.month - 1,
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: FinvixSpacing.md, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              FormatHelper.formatMonthYear(currentMonth),
              style: FinvixTypography.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(currentMonthProvider.notifier).state = DateTime(
                currentMonth.year,
                currentMonth.month + 1,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tagline Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: FinvixSpacing.xs,
              horizontal: FinvixSpacing.md,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15),
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.05),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              'Track Smarter, Spend Better',
              textAlign: TextAlign.center,
              style: FinvixTypography.labelSmall.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: FinvixSpacing.md,
                vertical: FinvixSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards - Improved Spacing & Layout
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Income',
                          amount: monthlyIncome,
                          color: FinvixColors.income,
                          icon: Icons.arrow_upward_rounded,
                        ),
                      ),
                      const SizedBox(width: FinvixSpacing.sm),
                      Expanded(
                        child: SummaryCard(
                          title: 'Expense',
                          amount: monthlyExpense,
                          color: FinvixColors.expense,
                          icon: Icons.arrow_downward_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FinvixSpacing.sm),
                  SummaryCard(
                    title: 'Savings',
                    amount: monthlySavings,
                    color: monthlySavings >= 0 ? FinvixColors.savings : FinvixColors.warning,
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: FinvixSpacing.xl),

                  // Category-wise Spending Pie Chart - Modern Section Header
                  if (categorySpending.isNotEmpty) ...[
                    Text(
                      'Category-wise Spending',
                      style: FinvixTypography.headlineSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: FinvixSpacing.md),
                    PieChartWidget(
                      categorySpending: categorySpending,
                      categories: categories,
                    ),
                    const SizedBox(height: FinvixSpacing.xl),
                  ],

                  // Monthly Trend Bar Chart - Modern Section Header
                  Text(
                    'Last 6 Months Trend',
                    style: FinvixTypography.headlineSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: FinvixSpacing.md),
                  BarChartWidget(currentMonth: currentMonth),
                  const SizedBox(height: FinvixSpacing.xl),

                  // Recent Transactions - Modern Section Header
                  Text(
                    'Recent Transactions',
                    style: FinvixTypography.headlineSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: FinvixSpacing.md),
                  RecentTransactionsWidget(
                    transactions: monthlyTransactions.take(5).toList(),
                    categories: categories,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}