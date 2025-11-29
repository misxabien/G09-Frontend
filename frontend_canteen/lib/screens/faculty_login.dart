import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_account.dart';
import 'menu.dart';
import 'services/api_service.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class FacultyLoginPage extends StatefulWidget {
  const FacultyLoginPage({super.key});

  @override
  State<FacultyLoginPage> createState() => _FacultyLoginPageState();
}

class _FacultyLoginPageState extends State<FacultyLoginPage> {
  bool keepLoggedIn = false;
  bool isLoading = false;

  void loginFaculty() async {
    setState(() => isLoading = true);

    final result = await ApiService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
      "faculty",
    );

    print("Faculty Login Response: $result");

    setState(() => isLoading = false);

    if (result['success'] == true && result['data']?['token'] != null) {
      final token = result['data']['token'];

      if (keepLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('role', 'faculty');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FoodHomePage(token: token)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login failed')),
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left panel
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
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFCE8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Ready to enjoy a smarter canteen experience?\nYour meal starts here.",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Color(0xFFFFFCE8),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Email
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            hintStyle: const TextStyle(
                              color: Color(0xFFFFFCE8),
                              fontFamily: 'Montserrat',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFFFFCE8)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          style: const TextStyle(
                            color: Color(0xFFFFFCE8),
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            hintStyle: const TextStyle(
                              color: Color(0xFFFFFCE8),
                              fontFamily: 'Montserrat',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFFFFCE8)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          style: const TextStyle(
                            color: Color(0xFFFFFCE8),
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: keepLoggedIn,
                              activeColor: const Color(0xFFFFFCE8),
                              checkColor: const Color(0xFF0047AB),
                              side: const BorderSide(color: Color(0xFFFFFCE8)),
                              onChanged: (value) {
                                setState(() {
                                  keepLoggedIn = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              "Keep me logged in",
                              style: TextStyle(
                                color: Color(0xFFFFFCE8),
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color(0xFF0047AB),
                            ),
                            onPressed: isLoading ? null : loginFaculty,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: Color(0xFFFFFCE8),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don’t have an account? ",
                              style: TextStyle(
                                color: Color(0xFFFFFCE8),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                                );
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Color(0xFFFFFCE8),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Right image/logo
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0047AB),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/images/sdc.png',
                      width: 230,
                      height: 230,
                    ),
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
