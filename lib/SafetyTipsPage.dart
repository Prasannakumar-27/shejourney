import 'package:flutter/material.dart';

class SafetyTipsPage extends StatelessWidget {
  const SafetyTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Tips'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const <Widget>[
            _SafetyTipTile(
              title: 'Tip 1: Stay aware of your surroundings.',
              subtitle: 'Always be alert and mindful of the people around you.',
              icon: Icons.visibility,
            ),
            _SafetyTipTile(
              title: 'Tip 2: Trust your instincts.',
              subtitle: 'If something feels off, remove yourself from the situation.',
              icon: Icons.warning,
            ),
            _SafetyTipTile(
              title: 'Tip 3: Keep your phone charged.',
              subtitle: 'Ensure your phone is charged and accessible in case of emergencies.',
              icon: Icons.phone_android,
            ),
            _SafetyTipTile(
              title: 'Tip 4: Share your location.',
              subtitle: 'Let someone know where you are and your plans.',
              icon: Icons.location_on,
            ),
            _SafetyTipTile(
              title: 'Tip 5: Avoid distractions.',
              subtitle: 'Stay focused and avoid using your phone while walking in unfamiliar areas.',
              icon: Icons.do_not_disturb_on,
            ),
            _SafetyTipTile(
              title: 'Tip 6: Take self-defense classes.',
              subtitle: 'Learn techniques that can help you protect yourself if necessary.',
              icon: Icons.security,
            ),
            _SafetyTipTile(
              title: 'Tip 7: Stay in well-lit areas.',
              subtitle: 'Avoid dark and isolated places, especially at night.',
              icon: Icons.light_mode,
            ),
            _SafetyTipTile(
              title: 'Tip 8: Use trusted transportation.',
              subtitle: 'Always choose reputable services for rides or taxis.',
              icon: Icons.directions_car,
            ),
            _SafetyTipTile(
              title: 'Tip 9: Keep emergency contacts handy.',
              subtitle: 'Have important numbers saved and easily accessible.',
              icon: Icons.contact_phone,
            ),
            _SafetyTipTile(
              title: 'Tip 10: Report suspicious activity.',
              subtitle: 'Notify authorities if you notice anything unusual or concerning.',
              icon: Icons.report_problem,
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyTipTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SafetyTipTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.pinkAccent,
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
