import 'package:flutter/material.dart';
import 'students_login.dart'; // Import your login page

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8), // Light beige background
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/sdcanteen_logo.png',
                width: 180,
                height: 180,
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                "CREATE ACCOUNT",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0047AB),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "SDCA EMAIL ONLY",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0047AB),
                ),
              ),

              const SizedBox(height: 30),

              // SDCA Email Field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0047AB),
                    hintText: "SDCA Email",
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),

              // Create Password Field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0047AB),
                    hintText: "Create Password",
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),

              // Confirm Password Field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0047AB),
                    hintText: "Confirm Password",
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudentLoginPage()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF0047AB),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // LOGIN button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0047AB),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  // TODO: Handle sign up logic
                },
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFFFFCE8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
