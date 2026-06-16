import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_text_styles.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  int _filterIndex = 0;
  static const _filters = ['All', 'Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildFilterTabs(),
            const SizedBox(height: 8),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          const Text('Transactions', style: AppTextStyles.titleLarge),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.neumorphicSubtle,
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.neumorphicPressed,
        ),
        child: Row(
          children: List.generate(_filters.length, (i) {
            final isActive = _filterIndex == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _filterIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _filters[i],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isActive
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildList() {
    final filtered = _filterIndex == 0
        ? _allTransactions
        : _allTransactions
            .where((t) =>
                t.type ==
                (_filterIndex == 1 ? 'income' : 'expense'))
            .toList();

    final grouped = <String, List<_Tx>>{};
    for (final t in filtered) {
      (grouped[t.date] ??= []).add(t);
    }

    final keys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        final date = keys[i];
        final txs = grouped[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                date,
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
            ...txs.map((t) => _TxTile(tx: t)),
          ],
        );
      },
    );
  }
}

class _TxTile extends StatelessWidget {
  const _TxTile({required this.tx});

  final _Tx tx;

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == 'income';
    final color = isIncome ? AppColors.accent : AppColors.negative;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.neumorphicSubtle,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx.icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(tx.category, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${tx.amount}',
            style: AppTextStyles.titleMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _Tx {
  const _Tx({
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

const _allTransactions = [
  _Tx(
    title: 'Salary',
    category: 'Income',
    amount: '4,200.00',
    date: 'Today',
    icon: Icons.work_outline_rounded,
    type: 'income',
  ),
  _Tx(
    title: 'Grocery Store',
    category: 'Food & Drink',
    amount: '128.50',
    date: 'Yesterday',
    icon: Icons.shopping_basket_outlined,
    type: 'expense',
  ),
  _Tx(
    title: 'Netflix',
    category: 'Entertainment',
    amount: '15.99',
    date: 'Yesterday',
    icon: Icons.movie_outlined,
    type: 'expense',
  ),
  _Tx(
    title: 'Freelance',
    category: 'Income',
    amount: '1,200.00',
    date: 'Jun 12',
    icon: Icons.laptop_outlined,
    type: 'income',
  ),
  _Tx(
    title: 'Electricity Bill',
    category: 'Housing',
    amount: '98.00',
    date: 'Jun 12',
    icon: Icons.bolt_outlined,
    type: 'expense',
  ),
  _Tx(
    title: 'Uber',
    category: 'Transport',
    amount: '24.80',
    date: 'Jun 11',
    icon: Icons.directions_car_outlined,
    type: 'expense',
  ),
  _Tx(
    title: 'Gym Membership',
    category: 'Healthcare',
    amount: '45.00',
    date: 'Jun 10',
    icon: Icons.fitness_center_outlined,
    type: 'expense',
  ),
];
