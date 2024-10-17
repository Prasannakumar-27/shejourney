import 'package:flutter/material.dart';
import 'package:shejourney/EmergencyContactPage.dart';
import 'package:shejourney/PanicButtonPage.dart';
import 'package:shejourney/RecorderPage.dart';
import 'package:shejourney/SafetyTipsPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SheJourney'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/assets/icon2.png'), // Replace with a user image
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to SheJourney',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                const Text(
                  'Your safety is our priority!',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 20),
                _buildCard(context, 'Manage Emergency Contacts', Icons.contact_phone, EmergencyContactsPage()),
                _buildCard(context, 'Location Sharing', Icons.location_on, PanicButtonPage()),
                _buildCard(context, 'Recorder', Icons.mic, AudioRecorderPage()),
                _buildCard(context, 'Safety Tips', Icons.security, SafetyTipsPage()),
                const SizedBox(height: 20), // Add some spacing at the bottom
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to panic button page for quick access
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PanicButtonPage()),
          );
        },
        child: const Icon(Icons.warning),
        backgroundColor: Colors.red,
        tooltip: 'Emergency Action',
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 8, // Increased shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.pinkAccent),
              const SizedBox(width: 16), // Space between icon and text
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.pinkAccent), // Icon at the end
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About SheJourney'),
          content: const Text(
            'SheJourney is an application designed to prioritize your safety. '
                'With features like emergency contacts management, location sharing, '
                'audio recording, and safety tips, we aim to empower you to stay safe and informed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
