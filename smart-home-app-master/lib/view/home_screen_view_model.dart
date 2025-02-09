import 'dart:convert';
import 'package:domus/provider/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // Import the math package for random number generation
import 'package:domus/provider/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HomeScreenViewModel extends BaseModel {
  // Dynamic data variables
  List<Map<String, dynamic>> rooms = [];
  List<Map<String, dynamic>> devices = [];
  int randomNumber = 0; // Variable to store the random number
  int selectedIndex = 0;

  final PageController pageController = PageController();

  /// Generate a random number between 0 and 8
  void generateRandomNumber() {
    randomNumber = Random().nextInt(8); // Generate a random number
    notifyListeners(); // Notify listeners of the change
  }


  Future<void> fetchDevices() async {
    const url = 'http://10.0.2.2:3000/api/devices';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        devices = List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Devices fetched: $devices'); // Debugging
        notifyListeners();
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (e) {
      print('Error fetching devices: $e');
    }
  }

  Future<void> fetchRooms() async {
    const url = 'http://10.0.2.2:3000/api/rooms';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        rooms = List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Rooms fetched: $rooms'); // Debugging
        notifyListeners();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      print('Error fetching rooms: $e');
    }
  }


  /// Toggle device favorite status
  void toggleFavorite(int deviceId) {
    final index = devices.indexWhere((device) =>
    device['device_id'] == deviceId);
    if (index != -1) {
      devices[index]['isFav'] = !(devices[index]['isFav'] ?? false);
      notifyListeners();
    }
  }

  /// Toggle device status
  void toggleDeviceStatus(int deviceId) {
    final index = devices.indexWhere((device) =>
    device['device_id'] == deviceId);
    if (index != -1) {
      devices[index]['itsOn'] = !(devices[index]['itsOn'] ?? false);
      notifyListeners();
    }
  }

  void onItemTapped(int index) {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    notifyListeners();
  }
}