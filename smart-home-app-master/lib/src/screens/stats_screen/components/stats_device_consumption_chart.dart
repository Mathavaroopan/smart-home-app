import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:domus/src/screens/stats_screen/components.dart';

class StatsDeviceConsumptionChart extends StatefulWidget {
  final String filter;

  const StatsDeviceConsumptionChart({Key? key, required this.filter}) : super(key: key);

  @override
  _StatsDeviceConsumptionChartState createState() => _StatsDeviceConsumptionChartState();
}

class _StatsDeviceConsumptionChartState extends State<StatsDeviceConsumptionChart> {
  List<Consumption> data = [];

  Future<void> fetchDeviceConsumption() async {
    final response = await http.get(
      Uri.parse('https://ee1b-223-185-203-96.ngrok-free.app/api/device-consumption-new?filter=${widget.filter}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      print("This is data");
      print(response.body);
      setState(() {
        data = responseData
            .map((item) => Consumption(
          day: item['device_type'],
          usage: double.parse(((item['consumption'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2)),
        ))
            .toList();
      });
    }
  }

  @override
  void didUpdateWidget(StatsDeviceConsumptionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      fetchDeviceConsumption(); // Fetch data only when filter changes
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDeviceConsumption();
    print("construction");
    print(data);
  }

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
        dataLabelSettings: const DataLabelSettings(
          angle: -90,
          labelAlignment: ChartDataLabelAlignment.bottom,
          isVisible: true,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: const Color(0xFFDCDEDF),
        dataSource: data,
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
