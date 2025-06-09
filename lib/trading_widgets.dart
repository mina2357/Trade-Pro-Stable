import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/trading_models.dart';


class StockCard extends StatefulWidget {
final Stock stock;
final VoidCallback? onTap;
final bool showWatchlistButton;
final VoidCallback? onWatchlistToggle;
final bool isInWatchlist;

const StockCard({
super.key,
required this.stock,
this.onTap,
this.showWatchlistButton = false,
this.onWatchlistToggle,
this.isInWatchlist = false,
});

@override
State<StockCard> createState() => _StockCardState();
}

class _StockCardState extends State<StockCard>
with SingleTickerProviderStateMixin {
late AnimationController _animationController;
late Animation<double> _scaleAnimation;
bool _isPressed = false;

@override
void initState() {
super.initState();
_animationController = AnimationController(
duration: const Duration(milliseconds: 150),
vsync: this,
);
_scaleAnimation = Tween<double>(
begin: 1.0,
end: 0.95,
).animate(CurvedAnimation(
parent: _animationController,
curve: Curves.easeInOut,
));
}

@override
void dispose() {
_animationController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

return AnimatedBuilder(
animation: _scaleAnimation,
builder: (context, child) {
return Transform.scale(
scale: _scaleAnimation.value,
child: Card(
margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
elevation: 0,
color: colorScheme.surface,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
),
child: InkWell(
onTap: () {
if (widget.onTap != null) {
widget.onTap!();
}
},
onTapDown: (_) {
setState(() => _isPressed = true);
_animationController.forward();
},
onTapUp: (_) {
setState(() => _isPressed = false);
_animationController.reverse();
},
onTapCancel: () {
setState(() => _isPressed = false);
_animationController.reverse();
},
borderRadius: BorderRadius.circular(12),
child: Padding(
padding: const EdgeInsets.all(16),
child: Row(
children: [
// Stock Icon
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
color: colorScheme.primary.withOpacity(0.1),
borderRadius: BorderRadius.circular(12),
),
child: Shimmer.fromColors(
baseColor: colorScheme.primary,
highlightColor: colorScheme.primary.withOpacity(0.3),
child: Icon(
Icons.trending_up,
color: colorScheme.primary,
size: 24,
),
),
),
const SizedBox(width: 12),

// Stock Info
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Text(
widget.stock.symbol,
style: theme.textTheme.titleMedium?.copyWith(
fontWeight: FontWeight.bold,
color: colorScheme.onSurface,
),
),
const SizedBox(width: 8),
Container(
padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
decoration: BoxDecoration(
color: colorScheme.secondary.withOpacity(0.1),
borderRadius: BorderRadius.circular(4),
),
child: Text(
widget.stock.market,
style: theme.textTheme.labelSmall?.copyWith(
color: colorScheme.secondary,
fontSize: 10,
),
),
),
],
),
const SizedBox(height: 4),
Text(
widget.stock.nameAr,
style: theme.textTheme.bodySmall?.copyWith(
color: colorScheme.onSurface.withOpacity(0.7),
),
maxLines: 1,
overflow: TextOverflow.ellipsis,
),
],
),
),

// Price Info
Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text(
'${widget.stock.currentPrice.toStringAsFixed(2)} ${widget.stock.currency}',
style: theme.textTheme.titleMedium?.copyWith(
fontWeight: FontWeight.bold,
color: colorScheme.onSurface,
),
),
const SizedBox(height: 4),
Container(
padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
decoration: BoxDecoration(
color: widget.stock.isPositive
? Colors.green.withOpacity(0.1)
: Colors.red.withOpacity(0.1),
borderRadius: BorderRadius.circular(12),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
widget.stock.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
size: 12,
color: widget.stock.isPositive ? Colors.green : Colors.red,
),
const SizedBox(width: 2),
Text(
'${widget.stock.changePercentage.toStringAsFixed(2)}%',
style: theme.textTheme.labelSmall?.copyWith(
color: widget.stock.isPositive ? Colors.green : Colors.red,
fontWeight: FontWeight.w600,
),
),
],
),
),
],
),

// Watchlist Button
if (widget.showWatchlistButton) ...[
const SizedBox(width: 8),
IconButton(
onPressed: widget.onWatchlistToggle,
icon: Icon(
widget.isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
color: widget.isInWatchlist ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
),
),
],
],
),
),
),
),
);
},
);
}
}

class PortfolioCard extends StatelessWidget {
final PortfolioHolding holding;
final Stock stock;
final VoidCallback? onTap;

const PortfolioCard({
super.key,
required this.holding,
required this.stock,
this.onTap,
});

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

return Card(
margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
elevation: 0,
color: colorScheme.surface,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(12),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
Row(
children: [
// Stock Icon
Container(
width: 40,
height: 40,
decoration: BoxDecoration(
color: holding.isPositive
? Colors.green.withOpacity(0.1)
: Colors.red.withOpacity(0.1),
borderRadius: BorderRadius.circular(10),
),
child: Icon(
holding.isPositive ? Icons.trending_up : Icons.trending_down,
color: holding.isPositive ? Colors.green : Colors.red,
size: 20,
),
),
const SizedBox(width: 12),

// Stock Info
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
holding.symbol,
style: theme.textTheme.titleMedium?.copyWith(
fontWeight: FontWeight.bold,
color: colorScheme.onSurface,
),
),
Text(
'${holding.quantity} سهم',
style: theme.textTheme.bodySmall?.copyWith(
color: colorScheme.onSurface.withOpacity(0.7),
),
),
],
),
),

// Value Info
Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text(
'${holding.totalValue.toStringAsFixed(0)} ${stock.currency}',
style: theme.textTheme.titleMedium?.copyWith(
fontWeight: FontWeight.bold,
color: colorScheme.onSurface,
),
),
Container(
padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
decoration: BoxDecoration(
color: holding.isPositive
? Colors.green.withOpacity(0.1)
: Colors.red.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: Text(
'${holding.isPositive ? "+" : ""}${holding.profitLoss.toStringAsFixed(0)}',
style: theme.textTheme.labelSmall?.copyWith(
color: holding.isPositive ? Colors.green : Colors.red,
fontWeight: FontWeight.w600,
),
),
),
],
),
],
),
const SizedBox(height: 12),

// Progress bar showing profit/loss
Container(
height: 4,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(2),
color: colorScheme.outline.withOpacity(0.2),
),
child: FractionallySizedBox(
alignment: Alignment.centerLeft,
widthFactor: (holding.profitLossPercentage.abs() / 100).clamp(0.0, 1.0),
child: Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(2),
color: holding.isPositive ? Colors.green : Colors.red,
),
),
),
),
],
),
),
),
);
}
}

class PriceChart extends StatelessWidget {
final List<double> priceHistory;
final bool isPositive;

const PriceChart({
super.key,
required this.priceHistory,
required this.isPositive,
});

@override
Widget build(BuildContext context) {
final colorScheme = Theme.of(context).colorScheme;

return Container(
height: 200,
padding: const EdgeInsets.all(16),
child: LineChart(
LineChartData(
gridData: FlGridData(
show: true,
drawVerticalLine: false,
horizontalInterval: 1,
getDrawingHorizontalLine: (value) => FlLine(
color: colorScheme.outline.withOpacity(0.2),
strokeWidth: 1,
),
),
titlesData: FlTitlesData(
leftTitles: AxisTitles(
sideTitles: SideTitles(
showTitles: true,
reservedSize: 40,
getTitlesWidget: (value, meta) => Text(
value.toStringAsFixed(0),
style: TextStyle(
color: colorScheme.onSurface.withOpacity(0.6),
fontSize: 10,
),
),
),
),
rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
),
borderData: FlBorderData(show: false),
lineBarsData: [
LineChartBarData(
spots: priceHistory
.asMap()
.entries
.map((entry) => FlSpot(entry.key.toDouble(), entry.value))
.toList(),
isCurved: true,
color: isPositive ? Colors.green : Colors.red,
barWidth: 2,
dotData: const FlDotData(show: false),
belowBarData: BarAreaData(
show: true,
color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
),
),
],
),
),
);
}
}

class MarketSummaryCard extends StatelessWidget {
final MarketSummary summary;

const MarketSummaryCard({
super.key,
required this.summary,
});

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

return Container(
width: 200,
margin: const EdgeInsets.only(right: 12),
child: Card(
elevation: 0,
color: colorScheme.surface,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(
Icons.show_chart,
color: colorScheme.primary,
size: 20,
),
const SizedBox(width: 8),
Expanded(
child: Text(
summary.indexName,
style: theme.textTheme.titleSmall?.copyWith(
fontWeight: FontWeight.bold,
color: colorScheme.onSurface,
),
),
),
],
),
const SizedBox(height: 12),
Text(
NumberFormat('#,##0.00').format(summary.currentValue),
style: theme.textTheme.headlineSmall?.copyWith(
fontWeight: FontWeight.bold,
color: colorScheme.onSurface,
),
),
const SizedBox(height: 4),
Row(
children: [
Icon(
summary.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
size: 14,
color: summary.isPositive ? Colors.green : Colors.red,
),
const SizedBox(width: 4),
Text(
'${summary.changePercentage.toStringAsFixed(2)}%',
style: theme.textTheme.bodySmall?.copyWith(
color: summary.isPositive ? Colors.green : Colors.red,
fontWeight: FontWeight.w600,
),
),
],
),
],
),
),
),
);
}
}

class NewsCard extends StatelessWidget {
final NewsArticle article;
final VoidCallback? onTap;

const NewsCard({
super.key,
required this.article,
this.onTap,
});

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

return Card(
margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
elevation: 0,
color: colorScheme.surface,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(12),
child: Padding(
padding: const EdgeInsets.all(16),
child: Row(
children: [
// News Icon
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
color: colorScheme.tertiary.withOpacity(0.1),
borderRadius: BorderRadius.circular(12),
),
child: Icon(
Icons.article,
color: colorScheme.tertiary,
size: 24,
),
),
const SizedBox(width: 12),

// News Content
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
article.title,
style: theme.textTheme.titleSmall?.copyWith(
fontWeight: FontWeight.w600,
color: colorScheme.onSurface,
),
maxLines: 2,
overflow: TextOverflow.ellipsis,
),
const SizedBox(height: 6),
Text(
article.summary,
style: theme.textTheme.bodySmall?.copyWith(
color: colorScheme.onSurface.withOpacity(0.7),
),
maxLines: 2,
overflow: TextOverflow.ellipsis,
),
const SizedBox(height: 8),
Row(
children: [
Icon(
Icons.access_time,
size: 12,
color: colorScheme.onSurface.withOpacity(0.5),
),
const SizedBox(width: 4),
Text(
_formatTimeAgo(article.publishedAt),
style: theme.textTheme.labelSmall?.copyWith(
color: colorScheme.onSurface.withOpacity(0.5),
),
),
const SizedBox(width: 12),
Text(
article.source,
style: theme.textTheme.labelSmall?.copyWith(
color: colorScheme.secondary,
fontWeight: FontWeight.w500,
),
),
],
),
],
),
),
],
),
),
),
);
}

String _formatTimeAgo(DateTime dateTime) {
final now = DateTime.now();
final difference = now.difference(dateTime);

if (difference.inDays > 0) {
return 'منذ ${difference.inDays} يوم';
} else if (difference.inHours > 0) {
return 'منذ ${difference.inHours} ساعة';
} else if (difference.inMinutes > 0) {
return 'منذ ${difference.inMinutes} دقيقة';
} else {
return 'الآن';
}
}
}

class StatCard extends StatelessWidget {
final String title;
final String value;
final String? subtitle;
final IconData icon;
final Color? iconColor;
final bool isPositive;

const StatCard({
super.key,
required this.title,
required this.value,
this.subtitle,
required this.icon,
this.iconColor,
this.isPositive = true,
});

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

return Card(
elevation: 0,
color: colorScheme.surface,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: Icon(
icon,
size: 20,
color: iconColor ?? colorScheme.primary,
),
),
const Spacer(),
if (subtitle != null)
Container(
padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
decoration: BoxDecoration(
color: isPositive
? Colors.green.withOpacity(0.1)
: Colors.red.withOpacity(0.1),
borderRadius: BorderRadius.circular(6),
),
child: Text(
subtitle!,
style: theme.textTheme.labelSmall?.copyWith(
color: isPositive ? Colors.green : Colors.red,
fontWeight: FontWeight.w600,
),
),
),
],
),
const SizedBox(height: 12),
Text(
title,
style: theme.textTheme.bodySmall?.copyWith(
color: colorScheme.onSurface.withOpacity(0.7),
),
),
const SizedBox(height: 4),
Text(
value,
style: theme.textTheme.headlineSmall?.copyWith(
fontWeight: FontWeight.bold,
color: colorScheme.onSurface,
),
),
],
),
),
);
}
}