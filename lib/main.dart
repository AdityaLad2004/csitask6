import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SMS Location',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var latitude;
  var longitude;
  var currentAddress;
  bool check = false;

  void _checkPermission() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    setState(() {
      check = true;
      currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    });
  }

  void _sendSMS(String message, List<String> recipients) async {
    String _result = await sendSMS(message: message, recipients: recipients);
  }

  List<String> recipients = ["9579318602"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location SMS App"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            check ? Text('Location: $currentAddress') : Container(),
            SizedBox(height: 10),
            check ? Text('Latitude: $latitude') : Container(),
            SizedBox(height: 10),
            check ? Text('Longitude: $longitude') : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _checkPermission();
              },
              child: Text('Locate Me'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendSMS(
                  'My current location is:\nLatitude: $latitude\nLongitude: $longitude',
                  recipients,
                );
              },
              child: Text('Send Location via SMS'),
            ),
          ],
        ),
      ),
    );
  }
}
