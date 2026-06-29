import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/models/analytics.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/providers/orders.dart';
import 'package:foodorderingadmin/widgets/app_drawer.dart';
import 'package:foodorderingadmin/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "dashboard";

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final loggedInUser =
          Provider.of<Auth>(context, listen: false).loggedInUser;
      Provider.of<Orders>(context, listen: false)
          .streamLiveOrders(loggedInUser);
      Provider.of<Orders>(context, listen: false)
          .streamAcceptedOrders(loggedInUser);
      Provider.of<Analytics>(context, listen: false)
          .fetchAnalytics(loggedInUser);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final liveOrders = Provider.of<Orders>(context).liveOrders;
    final acceptedOrders = Provider.of<Orders>(context).acceptedOrders;
    final analytics = Provider.of<Analytics>(context).orderAnalytics;
    final recentAnalytics = analytics.take(7).toList();
    final totalRevenue = recentAnalytics.fold<double>(
      0,
      (value, day) => value + day.total,
    );
    final totalOrders = recentAnalytics.fold<int>(
      0,
      (value, day) => value + day.orderCount,
    );
    final averageOrder = totalOrders == 0 ? 0 : totalRevenue / totalOrders;

    return Scaffold(
      appBar: BaseAppBar(
        title: "Dashboard",
        backgroundColor: kGreyBackground,
        textColor: Colors.white,
        appBar: AppBar(),
      ),
      drawer: const AppDrawer(),
      body: Container(
        color: kLightGreyBackground,
        child: RefreshIndicator(
          onRefresh: () async {
            final loggedInUser =
                Provider.of<Auth>(context, listen: false).loggedInUser;
            await Provider.of<Analytics>(context, listen: false)
                .fetchAnalytics(loggedInUser);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricCard(
                    title: 'New orders',
                    value: liveOrders.length.toString(),
                    subtitle: 'Waiting for action',
                    color: kGreen,
                  ),
                  _MetricCard(
                    title: 'Accepted today',
                    value: acceptedOrders.length.toString(),
                    subtitle: 'In progress or paid',
                    color: kYellow,
                  ),
                  _MetricCard(
                    title: '7 day revenue',
                    value: NumberFormat.simpleCurrency(name: 'GBP')
                        .format(totalRevenue),
                    subtitle: '$totalOrders completed orders',
                    color: Colors.black87,
                  ),
                  _MetricCard(
                    title: 'Average order',
                    value: NumberFormat.simpleCurrency(name: 'GBP')
                        .format(averageOrder),
                    subtitle: 'Last 7 days',
                    color: Colors.blueGrey,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _RevenuePanel(days: recentAnalytics),
              const SizedBox(height: 18),
              _OperationsPanel(
                liveOrders: liveOrders.length,
                acceptedOrders: acceptedOrders.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: kGreySubTitle),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RevenuePanel extends StatelessWidget {
  const _RevenuePanel({required this.days});

  final List<DayOrderSummary> days;

  @override
  Widget build(BuildContext context) {
    final orderedDays = days.reversed.toList();
    final maxTotal = orderedDays.fold<double>(
      0,
      (value, day) => math.max(value, day.total),
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Revenue trend', style: kTitleText),
            const SizedBox(height: 6),
            const Text('Completed order value over the last 7 reporting days.'),
            const SizedBox(height: 18),
            if (orderedDays.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('No analytics yet.')),
              )
            else
              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: orderedDays
                      .map((day) => Expanded(
                            child: _RevenueBar(
                              day: day,
                              maxTotal: maxTotal,
                            ),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RevenueBar extends StatelessWidget {
  const _RevenueBar({required this.day, required this.maxTotal});

  final DayOrderSummary day;
  final double maxTotal;

  @override
  Widget build(BuildContext context) {
    final heightFactor =
        maxTotal == 0 ? 0.05 : math.max(day.total / maxTotal, 0.05);
    final barHeight = 110 * heightFactor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            NumberFormat.compactCurrency(symbol: '£').format(day.total),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: barHeight,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(DateFormat.E().format(day.orderDate)),
        ],
      ),
    );
  }
}

class _OperationsPanel extends StatelessWidget {
  const _OperationsPanel({
    required this.liveOrders,
    required this.acceptedOrders,
  });

  final int liveOrders;
  final int acceptedOrders;

  @override
  Widget build(BuildContext context) {
    final busy = liveOrders + acceptedOrders;
    final status = busy == 0
        ? 'Quiet service window'
        : liveOrders > 0
            ? 'Action needed now'
            : 'Orders are moving';

    return Card(
      color: kGreyBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.restaurant_menu, color: Colors.white, size: 42),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status, style: kWhiteTitle),
                  const SizedBox(height: 6),
                  Text(
                    '$liveOrders new and $acceptedOrders accepted orders are visible to the team.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
