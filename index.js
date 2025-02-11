require('dotenv').config();
const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Database connection
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  multipleStatements: true,
});

// Utility function to query the database
const queryDatabase = (query, params) =>
  new Promise((resolve, reject) => {
    pool.query(query, params, (error, results) => {
      if (error) return reject(error);
      resolve(results);
    });
  });

app.get('/users', async (req, res) => {
  try {
    // Query to fetch all users
    const users = await queryDatabase('SELECT * FROM users');

    // Check if there are no users
    if (users.length === 0) {
      return res.status(404).json({ message: 'No users found' });
    }

    // Send the list of users
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// app.post('/insertRandomData', async (req, res) => {
//   try {
//     // Insert rooms if they don't exist
//     const roomData = [
//       ['Living Room', 500, 700, 22000, 5],
//       ['Bedroom', 400, 600, 18000, 4],
//       ['Kitchen', 300, 500, 16000, 3],
//       ['Garage', 350, 550, 17000, 2]
//     ];

//     for (const room of roomData) {
//       const [existingRoom] = await queryDatabase('SELECT room_id FROM rooms WHERE room_name = ?', [room[0]]);
//       if (!existingRoom) {
//         await queryDatabase('INSERT INTO rooms (room_name, current_reading, total_units_today, total_units_month, total_devices) VALUES (?, ?, ?, ?, ?)', room);
//       }
//     }

//     // Fetch valid room IDs
//     const rooms = await queryDatabase('SELECT room_id FROM rooms');
//     const roomIds = rooms.map(r => r.room_id);

//     // Insert device types if they don't exist
//     const deviceTypeData = [
//       ['Fan', 100, 200, 6000],
//       ['Light', 80, 160, 4800],
//       ['Refrigerator', 150, 300, 9000],
//       ['Heater', 250, 500, 15000]
//     ];

//     for (const type of deviceTypeData) {
//       const [existingType] = await queryDatabase('SELECT device_type_id FROM device_types WHERE device_type = ?', [type[0]]);
//       if (!existingType) {
//         await queryDatabase('INSERT INTO device_types (device_type, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?)', type);
//       }
//     }

//     // Fetch valid device type IDs
//     const deviceTypes = await queryDatabase('SELECT device_type_id FROM device_types');
//     const deviceTypeIds = deviceTypes.map(d => d.device_type_id);

//     // Insert devices
//     let insertedDevices = [];
//     for (let i = 0; i < 10; i++) {
//       const room_id = roomIds[Math.floor(Math.random() * roomIds.length)];
//       const device_type_id = deviceTypeIds[Math.floor(Math.random() * deviceTypeIds.length)];
//       const current_reading = (Math.random() * 300) + 100;
//       const total_units_today = (Math.random() * 500) + 200;
//       const total_units_month = (Math.random() * 20000) + 10000;

//       const result = await queryDatabase('INSERT INTO devices (room_id, device_type_id, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
//         [room_id, device_type_id, current_reading, total_units_today, total_units_month]);

//       insertedDevices.push(result.insertId);
//     }

//     // Insert device readings
//     for (let i = 0; i < 50; i++) {
//       const device_id = insertedDevices[Math.floor(Math.random() * insertedDevices.length)];
//       const timestamp = new Date(Date.now() - (Math.random() * 31536000000 * 5)); // Last 5 years
//       const current_reading = (Math.random() * 300) + 100;
//       const total_units_today = (Math.random() * 500) + 200;
//       const total_units_month = (Math.random() * 20000) + 10000;

//       await queryDatabase('INSERT INTO device_readings (device_id, timestamp, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
//         [device_id, timestamp, current_reading, total_units_today, total_units_month]);
//     }

//     res.status(200).json({ message: 'Random data inserted successfully!' });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: 'An error occurred while inserting random data.' });
//   }
// });

// app.post('/insertRandomData', async (req, res) => {
//   try {
//     // Insert rooms if they don't exist
//     const roomData = [
//       ['Living Room', 500, 700, 22000, 5],
//       ['Bedroom', 400, 600, 18000, 4],
//       ['Kitchen', 300, 500, 16000, 3],
//       ['Garage', 350, 550, 17000, 2]
//     ];

//     for (const room of roomData) {
//       const [existingRoom] = await queryDatabase('SELECT room_id FROM rooms WHERE room_name = ?', [room[0]]);
//       if (!existingRoom) {
//         await queryDatabase('INSERT INTO rooms (room_name, current_reading, total_units_today, total_units_month, total_devices) VALUES (?, ?, ?, ?, ?)', room);
//       }
//     }

//     // Fetch valid room IDs
//     const rooms = await queryDatabase('SELECT room_id FROM rooms');
//     const roomIds = rooms.map(r => r.room_id);

//     // Insert device types if they don't exist
//     const deviceTypeData = [
//       ['Fan', 100, 200, 6000],
//       ['Light', 80, 160, 4800],
//       ['Refrigerator', 150, 300, 9000],
//       ['Heater', 250, 500, 15000]
//     ];

//     for (const type of deviceTypeData) {
//       const [existingType] = await queryDatabase('SELECT device_type_id FROM device_types WHERE device_type = ?', [type[0]]);
//       if (!existingType) {
//         await queryDatabase('INSERT INTO device_types (device_type, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?)', type);
//       }
//     }

//     // Fetch valid device type IDs
//     const deviceTypes = await queryDatabase('SELECT device_type_id FROM device_types');
//     const deviceTypeIds = deviceTypes.map(d => d.device_type_id);

//     // Insert devices
//     let insertedDevices = [];
//     for (let i = 0; i < 10; i++) {
//       const room_id = roomIds[Math.floor(Math.random() * roomIds.length)];
//       const device_type_id = deviceTypeIds[Math.floor(Math.random() * deviceTypeIds.length)];
//       const current_reading = Math.floor(Math.random() * 5000) + 1000; // Large random values
//       const total_units_today = Math.floor(Math.random() * 8000) + 2000;
//       const total_units_month = Math.floor(Math.random() * 50000) + 20000;

//       const result = await queryDatabase('INSERT INTO devices (room_id, device_type_id, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
//         [room_id, device_type_id, current_reading, total_units_today, total_units_month]);

//       insertedDevices.push(result.insertId);
//     }

//     // Insert device readings for today (10 readings)
//     for (let i = 0; i < 10; i++) {
//       const device_id = insertedDevices[Math.floor(Math.random() * insertedDevices.length)];
//       const timestamp = new Date(); // Today's date
//       const current_reading = Math.floor(Math.random() * 5000) + 1000;
//       const total_units_today = Math.floor(Math.random() * 8000) + 2000;
//       const total_units_month = Math.floor(Math.random() * 50000) + 20000;

//       await queryDatabase('INSERT INTO device_readings (device_id, timestamp, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
//         [device_id, timestamp, current_reading, total_units_today, total_units_month]);
//     }

//     // Insert device readings for this month (20 readings)
//     for (let i = 0; i < 20; i++) {
//       const device_id = insertedDevices[Math.floor(Math.random() * insertedDevices.length)];
//       const daysAgo = Math.floor(Math.random() * 30) + 1; // Any date in this month
//       const timestamp = new Date();
//       timestamp.setDate(timestamp.getDate() - daysAgo); // Adjust date

//       const current_reading = Math.floor(Math.random() * 5000) + 1000;
//       const total_units_today = Math.floor(Math.random() * 8000) + 2000;
//       const total_units_month = Math.floor(Math.random() * 50000) + 20000;

//       await queryDatabase('INSERT INTO device_readings (device_id, timestamp, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
//         [device_id, timestamp, current_reading, total_units_today, total_units_month]);
//     }

//     res.status(200).json({ message: 'Random data inserted successfully!' });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: 'An error occurred while inserting random data.' });
//   }
// });

app.post('/insertRandomData', async (req, res) => {
  try {
    // Insert rooms if they don't exist
    const roomData = [
      ['Living Room', 50.00, 70.00, 220.00, 5],
      ['Bedroom', 40.00, 60.00, 180.00, 4],
      ['Kitchen', 30.00, 50.00, 160.00, 3],
      ['Garage', 35.00, 55.00, 170.00, 2]
    ];

    for (const room of roomData) {
      const [existingRoom] = await queryDatabase('SELECT room_id FROM rooms WHERE room_name = ?', [room[0]]);
      if (!existingRoom) {
        await queryDatabase('INSERT INTO rooms (room_name, current_reading, total_units_today, total_units_month, total_devices) VALUES (?, ?, ?, ?, ?)', room);
      }
    }

    // Fetch valid room IDs
    const rooms = await queryDatabase('SELECT room_id FROM rooms');
    const roomIds = rooms.map(r => r.room_id);

    // Insert device types if they don't exist (Added 3 new types)
    const deviceTypeData = [
      ['Fan', 10.00, 20.00, 60.00],
      ['Light', 8.00, 16.00, 48.00],
      ['Refrigerator', 15.00, 30.00, 90.00],
      ['Heater', 25.00, 50.00, 150.00],
      ['Air Conditioner', 50.00, 80.00, 300.00], // New
      ['Microwave', 30.00, 40.00, 100.00], // New
      ['Washing Machine', 20.00, 35.00, 120.00] // New
    ];

    for (const type of deviceTypeData) {
      const [existingType] = await queryDatabase('SELECT device_type_id FROM device_types WHERE device_type = ?', [type[0]]);
      if (!existingType) {
        await queryDatabase('INSERT INTO device_types (device_type, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?)', type);
      }
    }

    // Fetch valid device type IDs
    const deviceTypes = await queryDatabase('SELECT device_type_id FROM device_types');
    const deviceTypeIds = deviceTypes.map(d => d.device_type_id);

    // Function to generate random numbers with 2 decimal places
    const getRandomValue = (min, max) => (Math.random() * (max - min) + min).toFixed(2);

    // Insert devices
    let insertedDevices = [];
    for (let i = 0; i < 10; i++) {
      const room_id = roomIds[Math.floor(Math.random() * roomIds.length)];
      const device_type_id = deviceTypeIds[Math.floor(Math.random() * deviceTypeIds.length)];
      const current_reading = getRandomValue(100, 1000);
      const total_units_today = getRandomValue(100, 1000);
      const total_units_month = getRandomValue(100, 1000);

      const result = await queryDatabase(
        'INSERT INTO devices (room_id, device_type_id, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
        [room_id, device_type_id, current_reading, total_units_today, total_units_month]
      );

      insertedDevices.push(result.insertId);
    }

    // Insert device readings for today (10 readings)
    for (let i = 0; i < 10; i++) {
      const device_id = insertedDevices[Math.floor(Math.random() * insertedDevices.length)];
      const timestamp = new Date(); // Today's date
      const current_reading = getRandomValue(100, 1000);
      const total_units_today = getRandomValue(100, 1000);
      const total_units_month = getRandomValue(100, 1000);

      await queryDatabase(
        'INSERT INTO device_readings (device_id, timestamp, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
        [device_id, timestamp, current_reading, total_units_today, total_units_month]
      );
    }

    // Insert device readings for this month (20 readings)
    for (let i = 0; i < 20; i++) {
      const device_id = insertedDevices[Math.floor(Math.random() * insertedDevices.length)];
      const daysAgo = Math.floor(Math.random() * 30) + 1; // Any date in this month
      const timestamp = new Date();
      timestamp.setDate(timestamp.getDate() - daysAgo); // Adjust date

      const current_reading = getRandomValue(100, 1000);
      const total_units_today = getRandomValue(100, 1000);
      const total_units_month = getRandomValue(100, 1000);

      await queryDatabase(
        'INSERT INTO device_readings (device_id, timestamp, current_reading, total_units_today, total_units_month) VALUES (?, ?, ?, ?, ?)', 
        [device_id, timestamp, current_reading, total_units_today, total_units_month]
      );
    }

    res.status(200).json({ message: 'Random data inserted successfully!' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while inserting random data.' });
  }
});



app.get('/api/device-type-consumption', async (req, res) => {
  try {
    const { period } = req.query;
    let column = 'total_units_month'; // Default to monthly consumption

    if (period === 'daily') {
      column = 'total_units_today';
    } else if (period === 'all') {
      column = 'current_reading';
    }

    const results = await queryDatabase(
      `SELECT dt.device_type, SUM(d.${column}) AS total_consumption
       FROM devices d
       JOIN device_types dt ON d.device_type_id = dt.device_type_id
       GROUP BY dt.device_type`
    );

    if (results.length === 0) {
      return res.status(404).json({ message: 'No data found' });
    }

    res.status(200).json(results);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});


app.get('/api/power-usage-history', async (req, res) => {
  try {
    const { device_id, days } = req.query;
    const daysLimit = days ? parseInt(days) : 7; // Default to last 7 days

    if (!device_id) {
      return res.status(400).json({ message: "Device ID is required" });
    }

    const results = await queryDatabase(
      `SELECT DATE(timestamp) AS date, SUM(total_units_today) AS daily_usage 
       FROM device_readings 
       WHERE device_id = ? 
       GROUP BY DATE(timestamp) 
       ORDER BY date DESC 
       LIMIT ?`,
      [device_id, daysLimit]
    );

    if (results.length === 0) {
      return res.status(404).json({ message: "No historical data found for this device" });
    }

    res.status(200).json(results);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});




app.post('/delete-dummy-data', async (req, res) => {
  try {
    // Delete all device readings
    await queryDatabase(`DELETE FROM device_readings`);

    // Delete all devices
    await queryDatabase(`DELETE FROM devices`);

    // Delete all device types
    await queryDatabase(`DELETE FROM device_types`);

    // Delete all rooms
    await queryDatabase(`DELETE FROM rooms`);

    res.json({ message: "All dummy records deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting data", error: error.message });
  }
});

// Register a new user
app.post('/register', async (req, res) => {
  const { username, email, password } = req.body;
  try {
    // Check if the email or username already exists
    const existingUser = await queryDatabase(
      'SELECT * FROM users WHERE email = ? OR username = ?',
      [email, username]
    );
    if (existingUser.length > 0) {
      return res.status(400).json({ message: 'Email or username already exists' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert the user into the database
    await queryDatabase('INSERT INTO users (username, email, password) VALUES (?, ?, ?)', [
      username,
      email,
      hashedPassword,
    ]);

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Login a user
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  console.log(email);
  console.log(password);
  try {
    // Check if the user exists
    const user = await queryDatabase('SELECT * FROM users WHERE email = ?', [email]);

    console.log(user);
    if (user.length === 0) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Compare passwords
    const isPasswordValid = await bcrypt.compare(password, user[0].password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Generate JWT token
    const token = jwt.sign({ userId: user[0].user_id }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });

    res.status(200).json({ message: 'Login successful', token });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

app.get('/all-data', async (req, res) => {
  try {
    // Fetch all rooms
    const rooms = await queryDatabase('SELECT * FROM rooms');

    // Fetch all device types
    const deviceTypes = await queryDatabase('SELECT * FROM device_types');

    // Fetch all devices
    const devices = await queryDatabase('SELECT * FROM devices');

    // Fetch all device readings
    const deviceReadings = await queryDatabase('SELECT * FROM device_readings');

    res.status(200).json({
      rooms,
      deviceTypes,
      devices,
      deviceReadings,
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// app.get('/api/device-consumption', async (req, res) => {
//   try {
//     const results = await queryDatabase(`
//       SELECT 
//         d.device_id, d.device_type_id, dt.device_type, d.room_id, r.room_name,
//         d.current_reading, d.total_units_today, d.total_units_month
//       FROM devices d
//       JOIN device_types dt ON d.device_type_id = dt.device_type_id
//       JOIN rooms r ON d.room_id = r.room_id
//     `);
//       console.log(results);
//     if (results.length === 0) {
//       return res.status(404).json({ message: 'No devices found' });
//     }

//     // Grouping by device type and summing up total_units_month for each type
//     const groupedData = results.reduce((acc, device) => {
//       const { device_type, total_units_month } = device;

//       if (acc[device_type]) {
//         acc[device_type] += total_units_month;  // Aggregate total usage for the same device type
//       } else {
//         acc[device_type] = total_units_month;   // Initialize the value if it's the first device of this type
//       }
//       console.log(acc);
//       return acc;
//     }, {});

//     // The response is now a Map<String, dynamic> representation
//     console.log(groupedData);  // Example: { "AC": 1108.729, "Fan": 2012.544, "Light": 2422.542 }

//     // Send the grouped and formatted data as a Map
//     res.status(200).json(groupedData);
//   } catch (error) {
//     res.status(500).json({ message: 'Server error', error: error.message });
//   }
// });

app.get('/api/device-consumption', async (req, res) => {
  try {
    const { period } = req.query; // Get the period query parameter
    let column = 'total_units_month'; // Default to monthly consumption

    // Determine which column to use based on the period
    if (period === 'daily') {
      column = 'total_units_today';
    } else if (period === 'all') {
      column = 'current_reading'; // Using current reading for total power at the moment
    }

    const results = await queryDatabase(`
      SELECT 
        d.device_id, d.device_type_id, dt.device_type, d.room_id, r.room_name,
        d.${column} AS consumption
      FROM devices d
      JOIN device_types dt ON d.device_type_id = dt.device_type_id
      JOIN rooms r ON d.room_id = r.room_id
    `);

    if (results.length === 0) {
      return res.status(404).json({ message: 'No devices found' });
    }

    // Grouping by device type and summing up consumption for each type
    const groupedData = results.reduce((acc, device) => {
      const { device_type, consumption } = device;

      if (acc[device_type]) {
        acc[device_type] += consumption;  // Aggregate total usage for the same device type
      } else {
        acc[device_type] = consumption;   // Initialize the value if it's the first device of this type
      }

      return acc;
    }, {});

    res.status(200).json(groupedData);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Route: Fetch Electricity Usage Data
app.get('/api/electricity-usage', async (req, res) => {
  try {
    const { filter } = req.query;
    let column = 'total_units_month';
    console.log(filter);
    if (filter === 'daily') column = 'total_units_today';
    else if (filter === 'all') column = 'current_reading';

    const results = await queryDatabase(
      `SELECT DATE(timestamp) AS date, SUM(${column}) AS \`usage\`
      FROM device_readings
      GROUP BY DATE(timestamp)
      ORDER BY date DESC
      LIMIT 7`
    );
    results.reverse();
    console.log(results);
    res.status(200).json(results);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Route: Fetch Device Consumption Data
app.get('/api/device-consumption-new', async (req, res) => {
  try {
    const { filter } = req.query;
    let column = 'total_units_month';

    if (filter === 'daily') column = 'total_units_today';
    else if (filter === 'all') column = 'current_reading';

    const results = await queryDatabase(
      `SELECT dt.device_type, SUM(d.${column}) AS consumption
       FROM devices d
       JOIN device_types dt ON d.device_type_id = dt.device_type_id
       GROUP BY dt.device_type`
    );
    res.status(200).json(results);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Route: Fetch Room Consumption Data
app.get('/api/room-consumption', async (req, res) => {
  try {
    const { filter } = req.query;
    let column = 'total_units_month';

    if (filter === 'daily') column = 'total_units_today';
    else if (filter === 'all') column = 'current_reading';

    const results = await queryDatabase(
      `SELECT r.room_name, SUM(d.${column}) AS consumption
       FROM devices d
       JOIN rooms r ON d.room_id = r.room_id
       GROUP BY r.room_name`
    );
    
    res.status(200).json(results);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});


// Start the server
app.listen(process.env.PORT || 3000, () => {
  console.log('Server is running on port 3000');
});
