import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../services/trading_service.dart';
import '../widgets/trading_widgets.dart';
import '../widgets/certificate_widget.dart';
import '../widgets/pulse_widget.dart';
import '../models/trading_models.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Consumer<TradingService>(
        builder: (context, tradingService, child) {
          final user = tradingService.user;
          final holdings = tradingService.holdings;
          final marketSummaries = tradingService.marketSummaries;
          final news = tradingService.news;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: colorScheme.surface,
                elevation: 0,
                title: Text(
                  'نايل تريد برو',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: colorScheme.onSurface),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Welcome Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withOpacity(0.8),
                        colorScheme.secondary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحباً، ${user.name}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'إجمالي قيمة المحفظة',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      PulseWidget(
                        duration: const Duration(seconds: 2),
                        child: Text(
                          '${NumberFormat('#,##0.00').format(user.portfolioValue)} ${user.currency}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            user.dayChange >= 0 ? Icons.trending_up : Icons.trending_down,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${user.dayChange >= 0 ? '+' : ''}${NumberFormat('#,##0.00').format(user.dayChange)} اليوم',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Certificate Section
              const SliverToBoxAdapter(
                child: CertificateWidget(),
              ),

              // Stats Cards
              SliverToBoxAdapter(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'إجمالي الأرباح',
                          value: '${NumberFormat('#,##0').format(user.totalProfit)} ${user.currency}',
                          subtitle: user.totalProfit >= 0 ? '+${((user.totalProfit / user.portfolioValue) * 100).toStringAsFixed(1)}%' : '${((user.totalProfit / user.portfolioValue) * 100).toStringAsFixed(1)}%',
                          icon: Icons.trending_up,
                          iconColor: Colors.green,
                          isPositive: user.totalProfit >= 0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'عدد الأسهم',
                          value: '${holdings.length}',
                          subtitle: 'محفظة متنوعة',
                          icon: Icons.pie_chart,
                          iconColor: colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Market Summary
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.public,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ملخص الأسواق',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: marketSummaries.length,
                        itemBuilder: (context, index) {
                          return MarketSummaryCard(summary: marketSummaries[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Portfolio Holdings
              if (holdings.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'محفظتي',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Navigate to portfolio page
                          },
                          child: Text(
                            'عرض الكل',
                            style: TextStyle(color: colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final holding = holdings[index];
                      final stock = tradingService.getStock(holding.symbol);
                      if (stock == null) return const SizedBox.shrink();
                      
                      return PortfolioCard(
                        holding: holding,
                        stock: stock,
                        onTap: () {
                          // Navigate to stock details
                        },
                      );
                    },
                    childCount: holdings.length > 3 ? 3 : holdings.length,
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Recent News
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.newspaper,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'آخر الأخبار',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Navigate to news page
                        },
                        child: Text(
                          'عرض المزيد',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return NewsCard(
                      article: news[index],
                      onTap: () {
                        // Navigate to news details
                      },
                    );
                  },
                  childCount: news.length > 2 ? 2 : news.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}