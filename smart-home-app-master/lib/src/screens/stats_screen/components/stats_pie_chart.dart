import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsDeviceConsumptionPieChart extends StatefulWidget {
  final String filter; // "daily", "weekly", "monthly"

  const StatsDeviceConsumptionPieChart({Key? key, required this.filter}) : super(key: key);

  @override
  _StatsDeviceConsumptionPieChartState createState() => _StatsDeviceConsumptionPieChartState();
}

class _StatsDeviceConsumptionPieChartState extends State<StatsDeviceConsumptionPieChart> {
  List<Consumption> _consumptionData = [];

  @override
  void didUpdateWidget(StatsDeviceConsumptionPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      fetchConsumptionData();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchConsumptionData();
  }

  Future<void> fetchConsumptionData() async {
    final url = Uri.parse(
      'https://ee1b-223-185-203-96.ngrok-free.app/api/device-consumption?period=${widget.filter}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        List<Consumption> consumptionList = responseData.entries
            .map((entry) => Consumption(
          deviceType: entry.key,
          usage: entry.value.toDouble(),
        ))
            .toList();

        setState(() {
          _consumptionData = consumptionList;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _consumptionData.isEmpty
          ? const CircularProgressIndicator()
          : SizedBox(
        height: 300,
        child: SfCircularChart(
          title: ChartTitle(text: 'Device Power Consumption'),
          legend: Legend(isVisible: true),
          series: <CircularSeries>[
            PieSeries<Consumption, String>(
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: _consumptionData,
              xValueMapper: (Consumption consumption, _) => consumption.deviceType,
              yValueMapper: (Consumption consumption, _) => consumption.usage,
              dataLabelMapper: (Consumption consumption, _) =>
              '${consumption.deviceType}: ${consumption.usage.toStringAsFixed(2)} kWh',
            ),
          ],
        ),
      ),
    );
  }
}

class Consumption {
  final String deviceType;
  final double usage;

  Consumption({required this.deviceType, required this.usage});
}
