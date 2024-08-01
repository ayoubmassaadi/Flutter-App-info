import 'package:flutter/material.dart';
import 'package:flutter_application_1/QRScan.dart';
import 'package:flutter_application_1/camera.dart';
import 'package:flutter_application_1/gallery.dart';
import 'package:flutter_application_1/weather-form.dart'; // Ensure this path is correct
import './quiz.dart';
import './weather.dart'; // Ensure this path is correct

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First App'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          'Hello',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/ayoub_imag.jpg'),
                )
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange, Colors.white]),
              ),
            ),
            ListTile(
              title: Text(
                'Quiz',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quiz()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Weather',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherForm()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Gallery',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Gallery()));
              },
            ),
            ListTile(
              title: Text(
                'Camera',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraPage()));
              },
            ),
            ListTile(
              title: Text(
                'QR Scan',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QRCodePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}