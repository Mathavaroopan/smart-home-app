import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:domus/src/screens/stats_screen/components.dart';

class StatsRoomConsumptionChart extends StatefulWidget {
  final String filter;

  const StatsRoomConsumptionChart({Key? key, required this.filter}) : super(key: key);

  @override
  _StatsRoomConsumptionChartState createState() => _StatsRoomConsumptionChartState();
}

class _StatsRoomConsumptionChartState extends State<StatsRoomConsumptionChart> {
  List<Consumption> data = [];

  Future<void> fetchRoomConsumption() async {
    final response = await http.get(
      Uri.parse('https://ee1b-223-185-203-96.ngrok-free.app/api/room-consumption?filter=${widget.filter}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      print("This is room consumption data:");
      print(response.body);
      setState(() {
        data = responseData
            .map((item) => Consumption(
          day: item['room_name'],
          usage: double.parse(((item['consumption'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2)),
        ))
            .toList();
      });
    }
  }

  @override
  void didUpdateWidget(StatsRoomConsumptionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      fetchRoomConsumption(); // Fetch data only when filter changes
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoomConsumption();
    print("Room consumption chart initialized");
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return StatsChart(
      title: 'Consumption by Room',
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
