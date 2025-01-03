import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectio_app/providers/theme_provider.dart'; // Import your theme provider
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase for logout
import 'package:url_launcher/url_launcher.dart';

class HeaderBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final String? userName;

  const HeaderBar({
    super.key,
    required this.profileImageUrl,
    required this.userName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppBar(
      title: const Text('Haz la Lectio'),
      actions: [
        // Theme Toggle Button
        IconButton(
          icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          onPressed: () {
            final themeNotifier = ref.read(themeProvider.notifier);
            themeNotifier.toggleTheme();
          },
        ),
        ElevatedButton.icon(
          onPressed: _launchDonateURL,
          icon: const Icon(Icons.volunteer_activism),
          label: const Text('Donar'),
        ),
        // User Profile with Dropdown Menu
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 18),
                      SizedBox(width: 8),
                      Text('Cerrar Sesion'),
                    ],
                  ),
                ),
              ];
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.5),
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null, // Load profile image if available
              child: profileImageUrl == null
                  ? Text(
                      userName?.isNotEmpty == true
                          ? userName![0].toUpperCase()
                          : '?',
                      // Show first letter of userName or '?' if name is unavailable
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  // Method to launch the donation URL
  void _launchDonateURL() async {
    const url = 'https://www.paypal.com/donate?hosted_button_id=YOUR_BUTTON_ID';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Logout function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
      // Navigate to the login page or perform other post-logout actions
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
