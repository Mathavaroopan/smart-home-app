import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:domus/src/screens/stats_screen/components.dart';

class StatsElectricityUsageChart extends StatefulWidget {
  final String filter;

  const StatsElectricityUsageChart({Key? key, required this.filter}) : super(key: key);

  @override
  _StatsElectricityUsageChartState createState() => _StatsElectricityUsageChartState();
}

class _StatsElectricityUsageChartState extends State<StatsElectricityUsageChart> {
  List<Consumption> data = [];

  Future<void> fetchElectricityUsage() async {
    final response = await http.get(
      Uri.parse('https://ee1b-223-185-203-96.ngrok-free.app/api/electricity-usage?filter=${widget.filter}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        data = responseData.map((item) => Consumption(day: item['date'], usage: item['usage'].toDouble())).toList();
      });
      print(data);
    }
  }

  @override
  void didUpdateWidget(covariant StatsElectricityUsageChart oldWidget) {
    if (oldWidget.filter != widget.filter) {
      fetchElectricityUsage();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    fetchElectricityUsage();
  }

  @override
  Widget build(BuildContext context) {
    return StatsChart(
      title: 'Daily',
      subtitle: const Text('Electricity Usage', style: TextStyle(fontFamily: 'ABeeZee')),
      plotOffset: -35,
      content: SplineAreaSeries<Consumption, String>(
        borderColor: const Color(0xFF464646),
        borderWidth: 1,
        color: const Color(0xFFD3D3D3),
        dataSource: data,
        xValueMapper: (consumption, _) => consumption.day,
        yValueMapper: (consumption, _) => consumption.usage,
      ),
    );
  }
}
