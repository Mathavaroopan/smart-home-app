import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(AIAnalysisApp());
}

class AIAnalysisApp extends StatefulWidget {
  @override
  _AIAnalysisAppState createState() => _AIAnalysisAppState();
}

class _AIAnalysisAppState extends State<AIAnalysisApp> {
  final TextEditingController _roomController = TextEditingController();
  final Map<String, int> _appliances = {};
  String? _aiResponse;

  final String apiKey = 'YOUR_GOOGLE_API_KEY'; // Replace with your actual API key
  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  void _addAppliance(String name, int units) {
    setState(() {
      _appliances[name] = units;
    });
  }

  Future<void> _analyzeData() async {
    String prompt = "Analyze this power usage data: $_appliances. Give insights and suggestions.";
    final response = await model.generateContent([prompt]);

    setState(() {
      _aiResponse = response.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('AI Power Usage Analysis')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _roomController,
                decoration: InputDecoration(labelText: "Appliance Name"),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_roomController.text.isNotEmpty) {
                    _addAppliance(_roomController.text, 10); // Assume 10 units for demo
                    _roomController.clear();
                  }
                },
                child: Text("Add Appliance"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _analyzeData,
                child: Text("Analyze"),
              ),
              SizedBox(height: 16),
              _aiResponse != null
                  ? Text("AI Response: $_aiResponse")
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
