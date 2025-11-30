import 'package:flutter/material.dart';
import 'create_account.dart';
import 'menu.dart';
import 'services/api_service.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  bool keepLoggedIn = false;
  bool isLoading = false;

    void loginStudent() async {
      setState(() => isLoading = true);

      final result = await ApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
        "student",
      );

      print("LOGIN RESULT: $result");

      setState(() => isLoading = false);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: No response from server")),);
            return;
          }

      if (result['status'] == "success") {
        final token = result['token'];
        final userData = result['data']?['user'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FoodHomePage(
              token: token,
              userData: userData,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Login failed")),
        );
      }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7E9),
      body: Center(
        child: Container(
          width: 950,
          height: 550,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7E9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              // Left Panel
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                  child: Container(
                    color: const Color(0xFF0047AB),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Login", style: TextStyle(fontFamily: 'Montserrat', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFFFCE8))),
                        const SizedBox(height: 10),
                        const Text("Ready to enjoy a smarter canteen experience?\nYour meal starts here.", style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Color(0xFFFFFCE8), height: 1.5)),
                        const SizedBox(height: 40),
                        
                        // Email
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Enter your SDCA email",
                            hintStyle: const TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat'),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFFFFCE8))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          style: const TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat'),
                        ),
                        const SizedBox(height: 20),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            hintStyle: const TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat'),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFFFFCE8))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          style: const TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat'),
                        ),
                        const SizedBox(height: 10),

                        // Checkbox + Forgot
                        Row(
                          children: [
                            Checkbox(
                              value: keepLoggedIn,
                              activeColor: const Color(0xFFFFFCE8),
                              checkColor: const Color(0xFF0047AB),
                              side: const BorderSide(color: Color(0xFFFFFCE8)),
                              onChanged: (value) => setState(() => keepLoggedIn = value ?? false),
                            ),
                            const Text("Keep me logged in", style: TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat', fontSize: 13)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat', fontSize: 13, decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: const Color(0xFF0047AB),
                            ),
                            onPressed: isLoading ? null : loginStudent,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Log in",
                                    style: TextStyle(
                                      color: Color(0xFFFFFCE8),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                          ),
                        ),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account? ", style: TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat')),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccountPage())),
                              child: const Text("Sign up", style: TextStyle(color: Color(0xFFFFFCE8), fontFamily: 'Montserrat', fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Right Image
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Welcome Back!", style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0047AB))),
                    const SizedBox(height: 30),
                    Image.asset('assets/images/sdc.png', width: 230, height: 230),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
