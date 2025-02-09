import 'package:flutter/material.dart';
import 'package:domus/src/screens/stats_screen/components/stats_pie_chart.dart';
import 'package:domus/src/screens/stats_screen/components.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  static String routeName = '/stats-screen';

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String selectedFilter = "daily"; // Default filter

  void updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[100],
        title: const Padding(
          padding: EdgeInsets.only(top: 20, left: 15),
          child: Text(
            'Stats',
            style: TextStyle(fontFamily: 'Lexend', fontSize: 36, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 15),
            child: Icon(Icons.bolt, size: 36, color: Colors.black),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          TypeSelection(onSelectionChanged: updateFilter), // Pass filter update function
          const SizedBox(height: 15),
          Expanded(
            child: StatsElectricityUsageChart(), // Electricity usage chart
          ),
          const SizedBox(height: 15),
          Expanded(
            child: StatsDeviceConsumptionChart(), // Device consumption chart
          ),
          const SizedBox(height: 15),
          Expanded(
            child: StatsDeviceConsumptionPieChart(filter: selectedFilter), // Pie chart with selected filter
          ),
          const SizedBox(height: 15),
        ],
      ),
      bottomNavigationBar: const StatsBottomAppBar(), // Bottom navigation bar
    );
  }
}
