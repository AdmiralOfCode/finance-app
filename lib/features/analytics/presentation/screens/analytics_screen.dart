import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_card.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _touchedIndex = -1;
  int _selectedMonth = 5; // June (0-indexed)

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildMonthSelector(),
              const SizedBox(height: 24),
              _buildOverviewCards(),
              const SizedBox(height: 24),
              _buildPieChart(),
              const SizedBox(height: 24),
              _buildBarChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Text('Analytics', style: AppTextStyles.titleLarge),
    );
  }

  Widget _buildMonthSelector() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        itemCount: _months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = i == _selectedMonth;
          return GestureDetector(
            onTap: () => setState(() => _selectedMonth = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent
                    : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected ? null : AppShadows.neumorphicSubtle,
              ),
              child: Center(
                child: Text(
                  _months[i],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected
                        ? AppColors.backgroundDark
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Total Income',
              value: '\$5,400',
              change: '+12%',
              isPositive: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              label: 'Total Expenses',
              value: '\$3,220',
              change: '-8%',
              isPositive: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expenses by Category',
                style: AppTextStyles.titleMedium),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex = response
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 3,
                      centerSpaceRadius: 48,
                      sections: _pieData(),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: _categoryLegend
                        .asMap()
                        .entries
                        .map((e) => _LegendItem(
                              label: e.value.$1,
                              color: e.value.$2,
                              percent: e.value.$3,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _pieData() {
    return _categoryLegend.asMap().entries.map((entry) {
      final i = entry.key;
      final isTouched = i == _touchedIndex;
      return PieChartSectionData(
        color: entry.value.$2,
        value: entry.value.$3.toDouble(),
        title: '${entry.value.$3}%',
        radius: isTouched ? 58 : 48,
        titleStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.backgroundDark,
          fontWeight: FontWeight.w700,
        ),
      );
    }).toList();
  }

  Widget _buildBarChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Monthly Overview', style: AppTextStyles.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 6000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          _months[value.toInt()],
                          style: AppTextStyles.labelSmall,
                        ),
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _barData(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BarLegend(color: AppColors.accent, label: 'Income'),
                const SizedBox(width: 24),
                _BarLegend(color: AppColors.negative, label: 'Expense'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _barData() {
    final incomes = [3200, 4100, 3800, 5200, 4800, 5400];
    final expenses = [2100, 2800, 3100, 2600, 3400, 3220];

    return List.generate(6, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: incomes[i].toDouble(),
            color: AppColors.accent,
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: expenses[i].toDouble(),
            color: AppColors.negative,
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}

final _categoryLegend = [
  ('Food', AppColors.negative, 32),
  ('Housing', AppColors.categoryPalette[4], 28),
  ('Transport', AppColors.warning, 18),
  ('Entertainment', AppColors.categoryPalette[5], 12),
  ('Other', AppColors.textSecondary, 10),
];

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  final String label;
  final String value;
  final String change;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.accent : AppColors.negative;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.neumorphicSubtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.textDisabled),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.balanceMedium),
          const SizedBox(height: 4),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              change,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    required this.percent,
  });

  final String label;
  final Color color;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Text(
            '$percent%',
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _BarLegend extends StatelessWidget {
  const _BarLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
