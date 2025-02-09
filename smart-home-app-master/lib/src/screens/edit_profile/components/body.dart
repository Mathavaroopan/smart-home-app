import 'package:flutter/material.dart';
import 'package:domus/config/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController roomsController = TextEditingController();
  TextEditingController devicesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int roomIdCounter = 1; // Counter for generating room IDs
  int deviceIdCounter = 1; // Counter for generating device IDs

  List<Room> rooms = []; // List to store room objects

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(15),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Row(
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  cursorColor: Colors.black12,
                  decoration: const InputDecoration(
                    hintText: 'Your full name',
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  controller: roomsController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      rooms.clear(); // Clear existing rooms when input changes
                      if (value.isNotEmpty) {
                        int numRooms = int.parse(value);
                        for (int i = 0; i < numRooms; i++) {
                          rooms.add(Room(id: roomIdCounter++));
                        }
                      }
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.trim().isEmpty) {
                      return 'Number of rooms is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Number of rooms',
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                // Dynamically generate input fields for each room
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return RoomWidget(room: rooms[index], deviceIdCounter: deviceIdCounter);
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  height: getProportionateScreenHeight(40),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Room {
  final int id;
  List<Device> devices = []; // List to store device objects for each room

  Room({required this.id});
}

class Device {
  final int id;
  String type;

  Device({required this.id, required this.type});
}

class RoomWidget extends StatefulWidget {
  final Room room;
  int deviceIdCounter;

  RoomWidget({Key? key, required this.room, required this.deviceIdCounter}) : super(key: key);

  @override
  State<RoomWidget> createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  TextEditingController devicesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Room ${widget.room.id}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        TextFormField(
          controller: devicesController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              widget.room.devices.clear(); // Clear existing devices when input changes
              if (value.isNotEmpty) {
                int numDevices = int.parse(value);
                for (int i = 0; i < numDevices; i++) {
                  widget.room.devices.add(Device(id: widget.deviceIdCounter++, type: ""));
                }
              }
            });
          },
          validator: (value) {
            if (value!.isEmpty || value.trim().isEmpty) {
              return 'Number of devices is required';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Number of devices',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.devices,
              color: Colors.black,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        // Dynamically generate input fields for each device in the room
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.room.devices.length,
          itemBuilder: (context, index) {
            return DeviceWidget(device: widget.room.devices[index]);
          },
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
      ],
    );
  }
}

class DeviceWidget extends StatelessWidget {
  final Device device;

  const DeviceWidget({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: (value) {
            // Update device type when input changes
            device.type = value;
          },
          decoration: const InputDecoration(
            hintText: 'Device type',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.device_hub,
              color: Colors.black,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
      ],
    );
  }
}
