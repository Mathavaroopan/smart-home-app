//const express = require('express');
//const mysql = require('mysql2');
//const app = express();
//const port = 3000;
//
//// MySQL connection setup
//const db = mysql.createConnection({
//  host: '34.47.238.116', // Replace with your Google Cloud DB host
//  user: 'samah',      // Replace with your MySQL username
//  password: 'Cloud#1234',  // Replace with your MySQL password
//  database: 'smart_power_management', // Replace with your database name
//});
//
//// Connect to MySQL
//db.connect((err) => {
//  if (err) {
//    console.error('Error connecting to the database:', err);
//    process.exit(1);
//  }
//  console.log('Connected to the MySQL database!');
//});
//
//// API endpoint to fetch rooms and device details
//app.get('/api/devices', (req, res) => {
//  const query = `
//    SELECT
//      r.room_name,
//      d.device_id,
//      d.current_reading,
//      d.total_units_today,
//      d.total_units_month,
//      dt.device_type
//    FROM
//      rooms r
//    JOIN
//      devices d ON r.room_id = d.room_id
//    JOIN
//      device_types dt ON d.device_type_id = dt.device_type_id`;
//  ;
//
//  db.query(query, (err, results) => {
//    if (err) {
//      console.error('Error executing query:', err);
//      res.status(500).send({ error: 'Database query error' });
//    } else {
//      res.status(200).json(results); // Send results as JSON
//    }
//  });
//});
//
//// API endpoint to fetch room details
//app.get('/api/rooms', (req, res) => {
//  const query = `
//    SELECT
//      room_id,
//      room_name,
//      current_reading,
//      total_units_today,
//      total_units_month,
//      total_devices
//    FROM
//      rooms`;
//  ;
//
//  db.query(query, (err, results) => {
//    if (err) {
//      console.error('Error executing query:', err);
//      res.status(500).send({ error: 'Database query error' });
//    } else {
//      res.status(200).json(results); // Send room details as JSON
//    }
//  });
//});
//
//// Start the server
//app.listen(port, () => {
//  console.log(`Server is running on http://localhost:${port}`);
//});

const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();
const port = 3000;

// Use CORS to allow client-side requests
app.use(cors());

// MySQL connection setup
const db = mysql.createConnection({
  host: '34.47.238.116', // Replace with your Google Cloud DB host
  user: 'samah',         // Replace with your MySQL username
  password: 'Cloud#1234',// Replace with your MySQL password
  database: 'smart_power_management', // Replace with your database name
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    process.exit(1);
  }
  console.log('Connected to the MySQL database!');
});

// API endpoint to fetch rooms and device details
app.get('/api/devices', (req, res) => {
  const query = `
    SELECT
      r.room_name,
      d.device_id,
      d.current_reading,
      d.total_units_today,
      d.total_units_month,
      dt.device_type
    FROM
      rooms r
    JOIN
      devices d ON r.room_id = d.room_id
    JOIN
      device_types dt ON d.device_type_id = dt.device_type_id;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(200).json(results); // Send results as JSON
  });
});

// API endpoint to fetch room details
app.get('/api/rooms', (req, res) => {
  const query = `
    SELECT
      room_id,
      room_name,
      current_reading,
      total_units_today,
      total_units_month,
      total_devices
    FROM
      rooms;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(200).json(results); // Send room details as JSON
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
