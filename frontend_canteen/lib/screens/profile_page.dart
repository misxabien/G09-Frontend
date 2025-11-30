import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginselection_screen.dart';
import 'staff_dashboard.dart';
import 'menu.dart';

class ProfilePage extends StatelessWidget {
  final String token;
  final Map<String, dynamic>? userData;

  const ProfilePage({super.key, required this.token, this.userData});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RoleSelectionPage()),
        (route) => false,
      );
    }
  }

  void _navigateToTab(BuildContext context, int tabIndex) {
    Navigator.pop(context); // Go back to dashboard
    // The dashboard will show the tab based on its own state
  }

  @override
  Widget build(BuildContext context) {
    final bool isStaff = userData?['userType'] == 'canteen_staff';
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8),
      body: Row(
        children: [
          // Sidebar - matches the dashboard exactly
          Container(
            width: 90,
            color: const Color(0xFF0A57A3),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.restaurant_menu,
                      color: Color(0xFF0A57A3), size: 32),
                ),
                const SizedBox(height: 40),
                
                if (isStaff) ...[
                  // Orders icon
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffDashboard(
                            token: token,
                            userData: userData,
                            initialTab: 0,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.receipt_long, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 35),
                  // Menu Management icon  
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffDashboard(
                            token: token,
                            userData: userData,
                            initialTab: 1,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.fastfood, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 35),
                  // Profile icon (current page - highlighted)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.person, color: Colors.white, size: 30),
                      disabledColor: Colors.white,
                    ),
                  ),
                ] else ...[
                  // Home icon
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.home, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 35),
                  // Profile icon (current page - highlighted)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(height: 35),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Divider(color: Colors.white, thickness: 1),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.history, color: Colors.white, size: 30),
                  ),
                ],
                
                const Spacer(),
                Icon(isStaff ? Icons.settings : Icons.menu, color: Colors.white, size: 30),
                const SizedBox(height: 25),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A57A3),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Icon
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF0A57A3),
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // User Info
                        if (userData != null) ...[
                          _buildInfoRow("Name", "${userData!['firstName']} ${userData!['lastName']}"),
                          const SizedBox(height: 15),
                          _buildInfoRow("Email", userData!['email'] ?? 'N/A'),
                          const SizedBox(height: 15),
                          _buildInfoRow("User Type", userData!['userType']?.toString().toUpperCase() ?? 'N/A'),
                        ],

                        const SizedBox(height: 40),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => _logout(context),
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 16,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A57A3),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
