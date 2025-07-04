import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_app/models/chart_data_point.dart';

class StockChartWidget extends StatefulWidget {
  final List<ChartDataPoint> data;
  final double height;
  final Color lineColor;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final bool showGrid;
  final bool showTooltip;

  const StockChartWidget({
    Key? key,
    required this.data,
    required this.height,
    required this.lineColor,
    required this.gradientStartColor,
    required this.gradientEndColor,
    this.showGrid = true,
    this.showTooltip = true,
  }) : super(key: key);

  @override
  State<StockChartWidget> createState() => _StockChartWidgetState();
}

class _StockChartWidgetState extends State<StockChartWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return SizedBox(
      height: widget.height,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: widget.showGrid),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _createSpots(),
              isCurved: true,
              color: widget.lineColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    widget.gradientStartColor.withOpacity(0.3),
                    widget.gradientEndColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    if (widget.data.isEmpty) return [];

    final minX = 0.0;
    final maxX = (widget.data.length - 1).toDouble();
    final minY = widget.data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxY = widget.data.map((e) => e.price).reduce((a, b) => a > b ? a : b);

    return widget.data.asMap().entries.map((entry) {
      final x = entry.key.toDouble();
      final normalizedX = (x - minX) / (maxX - minX);
      final normalizedY = (entry.value.price - minY) / (maxY - minY);
      return FlSpot(normalizedX * maxX, entry.value.price);
    }).toList();
  }
}