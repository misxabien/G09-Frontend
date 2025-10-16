import 'package:flutter/material.dart';
import 'package:frontend_canteen/screens/canteen_login.dart';
import 'package:frontend_canteen/screens/faculty_login.dart';
import 'package:frontend_canteen/screens/students_login.dart';

class LoginSelectionPage extends StatelessWidget {
  const LoginSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            Image.asset(
              'assets/images/sdcanteen_logo.png',
              width: 200,
              height: 200,
            ),

            const SizedBox(height: 20),

            const Text(
              'CHOOSE A LOGIN TYPE',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0047AB), 
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0047AB),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentLoginPage()),
                );
              },
              child: const Text(
                'STUDENT',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFFFFCE8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //faculty 
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0047AB),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FacultyLoginPage()),
                );
              },
              child: const Text(
                'FACULTY',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFFFFCE8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // canteen staff button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0047AB),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CanteenLoginPage()),
                );
              },
              child: const Text(
                'CANTEEN STAFF',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFFFFCE8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}