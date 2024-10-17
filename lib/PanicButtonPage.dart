import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shejourney/EmergencyContactPage.dart';
import 'package:url_launcher/url_launcher.dart';

class PanicButtonPage extends StatefulWidget {
  const PanicButtonPage({super.key});

  @override
  _PanicButtonPageState createState() => _PanicButtonPageState();
}

class _PanicButtonPageState extends State<PanicButtonPage> {
  Position? _currentPosition;
  bool _isTrackingLocation = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required.')),
        );
        return;
      }
    }

    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is permanently denied. Please enable it in settings.')),
      );
      await openAppSettings();
    } else if (status.isGranted) {
      _startTrackingLocation();
    }
  }

  Future<void> _startTrackingLocation() async {
    setState(() {
      _isTrackingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled. Please enable them.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are permanently denied.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Geolocator.getPositionStream().listen((Position position) {
          setState(() {
            _currentPosition = position;
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _sendLocation(List<EmergencyContact> contacts) async {
    if (_currentPosition != null) {
      String message = 'I need help! My location is: '
          'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}';

      for (var contact in contacts) {
        String smsUrl = 'sms:${contact.phoneNumber}?body=$message';
        if (await canLaunch(smsUrl)) {
          await launch(smsUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not send SMS to ${contact.name}.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Alert'),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_isTrackingLocation) ...[
                  const Icon(
                    Icons.location_on,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tracking Location...',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (_currentPosition != null)
                    Text(
                      'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, Long: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmergencyContactsPage(),
                        ),
                      ).then((contacts) {
                        if (contacts != null && contacts is List<EmergencyContact>) {
                          _sendLocation(contacts);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'SEND LOCATION',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.warning,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Emergency Situation?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _requestLocationPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'PANIC BUTTON',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
