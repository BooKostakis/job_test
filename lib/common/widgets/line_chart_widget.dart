import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_test/common/theme/app_colors.dart';
import 'package:job_test/health_data_bloc/health_data_bloc.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<Color> gradientColors = [
    AppColors.appLightGreen,
    AppColors.appLightGreen,
  ];

  bool showAvg = false;
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthDataBloc, HealthDataState>(
      builder: (context, state) {
        if (state is HealthDataLoaded) {
          return Stack(children: <Widget>[
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(mainData(state)),
            )
          ]);
        }
        return const Center(child: Text('Нет данных'));
      },
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta, HealthDataLoaded state) {
    final dynamics = state.healthData.dynamics;
    final textStyle = Theme.of(context).textTheme.bodySmall;

    if (dynamics.isNotEmpty) {
      final index = value.toInt();
      if (index == _touchedIndex || index == 1) {
        final dateString = dynamics[index].date;
        try {
          final dateTime = DateTime.parse(dateString);
          final formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
          return SideTitleWidget(
            meta: meta,
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(formattedDate, style: textStyle),
                )),
          );
        } catch (e) {
          return SideTitleWidget(meta: meta, child: Text('', style: textStyle));
        }
      }
    }
    return SideTitleWidget(meta: meta, child: Text('', style: textStyle));
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta, HealthDataLoaded state) {
    final dynamics = state.healthData.dynamics;
    if (dynamics.isNotEmpty) {
      final maxY =
          (dynamics.fold<double>(0, (max, dynamic) => max > dynamic.value ? max : dynamic.value).ceil() + 1).toDouble();
      final avg = ((1 + maxY) / 2).roundToDouble();

      if (value == 1) {
        return SideTitleWidget(
            meta: meta, child: const Text('1.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)));
      } else if (value.roundToDouble() == avg) {
        return SideTitleWidget(
            meta: meta, child: Text(avg.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)));
      } else if (value.roundToDouble() == maxY) {
        return SideTitleWidget(
            meta: meta,
            child: Text(maxY.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)));
      } else {
        return Container();
      }
    }
    return Container();
  }

  LineChartData mainData(HealthDataLoaded state) {
    final dynamics = state.healthData.dynamics;
    if (dynamics.isEmpty) return LineChartData(lineBarsData: []);

    dynamics.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    final maxY =
        (dynamics.fold<double>(0, (max, dynamic) => max > dynamic.value ? max : dynamic.value).ceil() + 1).toDouble();
    final spots = dynamics.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.value)).toList();

    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) => _bottomTitleWidgets(value, meta, state),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 42,
            interval: 1,
            getTitlesWidget: (value, meta) => _leftTitleWidgets(value, meta, state),
          ),
        ),
      ),
      borderData: FlBorderData(show: false, border: Border.all(color: Colors.red)),
      minX: 0,
      maxX: spots.length > 1 ? spots.length.toDouble() - 1 : 1,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.4,
          gradient: const LinearGradient(colors: [
            AppColors.appGreen,
            AppColors.appGreen,
          ]),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(colors: [
              AppColors.appLightGreen,
              AppColors.appLightGreen,
            ]),
          ),
          aboveBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(colors: [
              AppColors.appGreen.withAlpha(8),
              AppColors.appGreen.withAlpha(8),
            ]),
          ),
        )
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          if (!event.isInterestedForInteractions || response == null || response.lineBarSpots == null) {
            setState(() {
              _touchedIndex = null;
            });
            return;
          }
          setState(() {
            _touchedIndex = response.lineBarSpots!.first.spotIndex;
          });
        },
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return const TouchedSpotIndicatorData(
              FlLine(
                color: Colors.grey,
                strokeWidth: 1,
                dashArray: [3, 3],
              ),
              FlDotData(show: false),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots
                .map((spot) => const LineTooltipItem('', TextStyle()))
                .toList(); // Пустая подсказка над графмком
          },
          tooltipBorder: BorderSide.none,
          tooltipPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
