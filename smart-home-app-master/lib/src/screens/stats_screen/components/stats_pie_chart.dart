import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsDeviceConsumptionPieChart extends StatefulWidget {
  const StatsDeviceConsumptionPieChart({Key? key}) : super(key: key);

  @override
  _StatsDeviceConsumptionPieChartState createState() => _StatsDeviceConsumptionPieChartState();
}

class _StatsDeviceConsumptionPieChartState extends State<StatsDeviceConsumptionPieChart> {
  List<Consumption> _consumptionData = [];

  @override
  void initState() {
    super.initState();
    fetchConsumptionData();
  }

  Future<void> fetchConsumptionData() async {
    final url = Uri.parse('https://df15-106-198-9-171.ngrok-free.app/api/device-consumption'); // Change to your actual backend API
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        // Create a list of Consumption objects by iterating over the map
        List<Consumption> consumptionList = responseData.entries
            .map((entry) => Consumption(
            deviceType: entry.key,       // The key is the device type (e.g., "AC")
            usage: entry.value.toDouble() // The value is the total usage for that device type
        ))
            .toList();

        print(consumptionList);
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
    return Scaffold(
      body: Center(
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
                dataLabelMapper: (Consumption consumption, _) => '${consumption.deviceType}: ${consumption.usage.toStringAsFixed(2)} kWh',
              ),
            ],
          ),
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