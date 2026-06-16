import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['full_name'] as String? ??
        user?.email?.split('@').first ??
        'there';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(name)),
            SliverToBoxAdapter(child: _buildBalanceCard()),
            SliverToBoxAdapter(child: _buildSummaryRow()),
            SliverToBoxAdapter(child: _buildRecentHeader()),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _TransactionTile(item: _mockTransactions[i]),
                childCount: _mockTransactions.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $name 👋',
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              const Text('Your finances', style: AppTextStyles.titleLarge),
            ],
          ),
          const Spacer(),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppShadows.neumorphicSubtle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A4C), Color(0xFF1A2E3E)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            ...AppShadows.neumorphicRaised,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text('\$12,540.00', style: AppTextStyles.balanceLarge),
            const SizedBox(height: 20),
            Row(
              children: [
                _BalancePill(
                  label: 'Income',
                  value: '\$8,200',
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 16),
                _BalancePill(
                  label: 'Expenses',
                  value: '\$3,660',
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.negative,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: NeumorphicCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.savings_outlined,
                      color: AppColors.accent,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This month',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.textDisabled),
                  ),
                  const SizedBox(height: 4),
                  const Text('\$2,180', style: AppTextStyles.balanceMedium),
                  Text(
                    'Saved',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: NeumorphicCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.pie_chart_outline_rounded,
                      color: AppColors.warning,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Budget used',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.textDisabled),
                  ),
                  const SizedBox(height: 4),
                  const Text('68%', style: AppTextStyles.balanceMedium),
                  Text(
                    'of \$5,400',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Row(
        children: [
          const Text('Recent Transactions', style: AppTextStyles.titleMedium),
          const Spacer(),
          Text(
            'See all',
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(color: color),
              ),
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item});

  final _MockTransaction item;

  @override
  Widget build(BuildContext context) {
    final isIncome = item.type == 'income';
    final color = isIncome ? AppColors.accent : AppColors.negative;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.neumorphicSubtle,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    item.category,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}\$${item.amount}',
                  style: AppTextStyles.titleMedium.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(item.date, style: AppTextStyles.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MockTransaction {
  const _MockTransaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.type,
  });

  final String title;
  final String category;
  final String amount;
  final String date;
  final IconData icon;
  final String type;
}

const _mockTransactions = [
  _MockTransaction(
    title: 'Salary',
    category: 'Income',
    amount: '4,200.00',
    date: 'Today',
    icon: Icons.work_outline_rounded,
    type: 'income',
  ),
  _MockTransaction(
    title: 'Grocery Store',
    category: 'Food & Drink',
    amount: '128.50',
    date: 'Yesterday',
    icon: Icons.shopping_basket_outlined,
    type: 'expense',
  ),
  _MockTransaction(
    title: 'Netflix',
    category: 'Entertainment',
    amount: '15.99',
    date: 'Jun 13',
    icon: Icons.movie_outlined,
    type: 'expense',
  ),
  _MockTransaction(
    title: 'Freelance',
    category: 'Income',
    amount: '1,200.00',
    date: 'Jun 12',
    icon: Icons.laptop_outlined,
    type: 'income',
  ),
  _MockTransaction(
    title: 'Uber',
    category: 'Transport',
    amount: '24.80',
    date: 'Jun 11',
    icon: Icons.directions_car_outlined,
    type: 'expense',
  ),
];
