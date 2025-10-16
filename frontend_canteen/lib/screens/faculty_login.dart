import 'package:flutter/material.dart';
import 'package:frontend_canteen/screens/create_account.dart';

class FacultyLoginPage extends StatelessWidget {
  const FacultyLoginPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8), 
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           
              Image.asset(
                'assets/images/sdcanteen_logo.png', 
                width: 180,
                height: 180,
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0047AB),
                ),
              ),

              const SizedBox(height: 30),

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

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0047AB),
                    hintText: "Password",
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont have an account? ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccountPage ()),
                      );
                    },
                  
                   child: const Text(
                  "Sign up",
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
                  // TODO: Handle login
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
