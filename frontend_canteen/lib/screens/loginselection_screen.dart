import 'package:flutter/material.dart';
import 'package:frontend_canteen/screens/students_login.dart';
import 'package:frontend_canteen/screens/faculty_login.dart';
import 'package:frontend_canteen/screens/canteen_login.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7E9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🏫 Logo
              Image.asset(
                'assets/images/sdc.png',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 20),

              // 🧭 Title
              Text(
                "Select Your Role",
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004AAD),
                ),
              ),
              const SizedBox(height: 40),

              // 👤 Role Buttons
              buildRoleButton(context, "Student", const StudentLoginPage()),
              const SizedBox(height: 20),
              buildRoleButton(context, "Faculty", const FacultyLoginPage()),
              const SizedBox(height: 20),
              buildRoleButton(context, "Canteen Staff", const CanteenLoginPage()),
            ],
          ),
        ),
      ),
    );
  }

  // 🎨 Reusable Button Widget
  Widget buildRoleButton(BuildContext context, String label, Widget destination) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF004AAD), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: const Color(0xFFF9F7E9),
            foregroundColor: const Color(0xFF004AAD),
          ).copyWith(
            overlayColor: WidgetStateProperty.all(const Color(0x22004AAD)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat', // 👈 Uses your local font
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF004AAD),
            ),
          ),
        ),
      ),
    );
  }
}
