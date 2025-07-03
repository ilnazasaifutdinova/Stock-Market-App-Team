import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_app/models/chart_data_point.dart';
import 'package:stock_market_app/providers/market_data_provider.dart';


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
    this.height = 200,
    this.lineColor = const Color(0xFF0AD842),
    this.gradientStartColor = const Color(0xFF0AD842),
    this.gradientEndColor = Colors.transparent,
    this.showGrid = true,
    this.showTooltip = true,
  }) : super(key: key);

  @override
  State<StockChartWidget> createState() => _StockChartWidgetState();
}

class _StockChartWidgetState extends State<StockChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF193326),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0AD842),
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF193326),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF234733),
          width: 1,
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LineChart(
            _buildChartData(),
            //duration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }

  LineChartData _buildChartData() {
    final spots = _createSpots();
    
    return LineChartData(
      gridData: FlGridData(
        show: widget.showGrid,
        drawVerticalLine: false,
        horizontalInterval: _calculateInterval(),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFF234733),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: spots.length / 4,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < widget.data.length) {
                final date = widget.data[index].time;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.month}/${date.day}',
                    style: const TextStyle(
                      color: Color(0xFF93C6AA),
                      fontSize: 10,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _calculateInterval(),
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                '\$${value.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFF93C6AA),
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: _getMinPrice() * 0.98,
      maxY: _getMaxPrice() * 1.02,
      lineBarsData: [
        LineChartBarData(
          spots: spots.take((spots.length * _animation.value).round()).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              widget.lineColor,
              widget.lineColor.withOpacity(0.8),
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              if (index == touchedIndex) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: widget.lineColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              }
              return FlDotCirclePainter(
                radius: 3,
                color: widget.lineColor,
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.gradientStartColor.withOpacity(0.3),
                widget.gradientEndColor,
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: widget.showTooltip,
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          setState(() {
            if (touchResponse != null && touchResponse.lineBarSpots != null) {
              touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: const Color(0xFF234733),
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final index = barSpot.spotIndex;
              if (index < widget.data.length) {
                final dataPoint = widget.data[index];
                return LineTooltipItem(
                  '\$${dataPoint.price.toStringAsFixed(2)}\n${dataPoint.time.month}/${dataPoint.time.day}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    return widget.data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();
  }

  double _getMinPrice() {
    return widget.data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
  }

  double _getMaxPrice() {
    return widget.data.map((e) => e.price).reduce((a, b) => a > b ? a : b);
  }

  double _calculateInterval() {
    final range = _getMaxPrice() - _getMinPrice();
    return range / 5;
  }
}