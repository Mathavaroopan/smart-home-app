import 'package:domus/src/screens/stats_screen/components.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsDeviceConsumptionChart extends StatelessWidget {
  const StatsDeviceConsumptionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatsChart(
      title: 'Consumption by device',
      subtitle: const Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.warning,
            size: 18,
          ),
          SizedBox(width: 5),
          Text('Check level 240'),
        ],
      ),
      plotOffset: -40,
      content: ColumnSeries<Consumption, String>(
        // Plots Columns / Bar chart
        dataLabelSettings: const DataLabelSettings(
          angle: -90,
          labelAlignment: ChartDataLabelAlignment.bottom,
          isVisible: true,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: const Color(0xFFDCDEDF),
        dataSource: const [
        Consumption(day: 'First', usage: 20),
        Consumption(day: 'Fan', usage: 22),
        Consumption(day: 'Light', usage: 30),
        Consumption(day: 'AC', usage: 36),
        Consumption(day: 'Refrigerator', usage: 19),
        Consumption(day: 'Washing Machine', usage: 25),
        Consumption(day: 'Heater', usage: 20),
        Consumption(day: 'Cleaner', usage: 33),
        Consumption(day: 'TV', usage: 25),
      ],
        xValueMapper: (consumption, _) => consumption.day,
        yValueMapper: (consumption, _) => consumption.usage,
        selectionBehavior: SelectionBehavior(
          enable: true,
          selectedColor: const Color(0xFFFF5722),
          selectedOpacity: 0.6,
          unselectedOpacity: 1,
        ),
      ),
      paddingBelow: 10,
    );
  }
}
