// models/electricity_usage.dart

class ElectricityUsage {
  int? id;
  String? deviceId;
  String? deviceName;
  int? roomId; // Changed to integer
  int? unitsConsumed;

  ElectricityUsage({this.id, this.deviceId, this.deviceName, this.roomId, this.unitsConsumed});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'roomId': roomId,
      'unitsConsumed': unitsConsumed,
    };
  }

  factory ElectricityUsage.fromMap(Map<String, dynamic> map) {
    return ElectricityUsage(
      id: map['id'],
      deviceId: map['deviceId'],
      deviceName: map['deviceName'],
      roomId: map['roomId'],
      unitsConsumed: map['unitsConsumed'],
    );
  }
}
