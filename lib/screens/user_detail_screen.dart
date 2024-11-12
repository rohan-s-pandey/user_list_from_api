import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  UserDetailScreen({required this.user});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail(String email) {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    _launchUrl(emailUri.toString());
  }

  void _launchGeoLocation(String lat, String lng) {
    final String geoUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    _launchUrl(geoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRow(
              icon: Icons.person,
              title: 'Username',
              content: user.username,
            ),
            Divider(),
            _buildHoverableLinkRow(
              icon: Icons.email,
              title: 'Email',
              content: user.email,
              onTap: () => _launchEmail(user.email),
            ),
            Divider(),
            _buildInfoRow(
              icon: Icons.phone,
              title: 'Phone',
              content: user.phone,
            ),
            Divider(),
            _buildHoverableLinkRow(
              icon: Icons.web,
              title: 'Website',
              content: user.website,
              onTap: () => _launchUrl('https://${user.website}'),
            ),
            Divider(),
            _buildInfoRow(
              icon: Icons.location_on,
              title: 'Address',
              content:
                  '${user.address.street}, ${user.address.suite}, ${user.address.city} - ${user.address.zipcode}',
            ),
            Divider(),
            _buildHoverableLinkRow(
              icon: Icons.map,
              title: 'Geo Location',
              content:
                  'Lat: ${user.address.geo.lat}, Lng: ${user.address.geo.lng}',
              onTap: () => _launchGeoLocation(
                  user.address.geo.lat, user.address.geo.lng),
            ),
            Divider(),
            _buildInfoRow(
              icon: Icons.business,
              title: 'Company',
              content:
                  '${user.company.name}\nCatchPhrase: ${user.company.catchPhrase}\nBusiness: ${user.company.bs}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.indigo, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(content, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoverableLinkRow({
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onTap,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: Colors.indigo, size: 28),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          content,
                          style: TextStyle(
                            fontSize: 16,
                            color: isHovered ? Colors.indigo : Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
