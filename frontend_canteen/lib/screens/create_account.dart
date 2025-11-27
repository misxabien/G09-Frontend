import 'package:flutter/material.dart';
import 'students_login.dart';
import 'services/api_service.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // Controllers for all text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool agreeToTerms = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the terms")),
      );
      return;
    }

    var result = await ApiService.createAccount(
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      "student", // Change to "faculty" if needed
    );

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentLoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Account creation failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCE8),
      body: Center(
        child: Container(
          width: 950,
          height: 600,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCE8),
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
              // Left side (logo + title)
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Let's Get Started!",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0047AB),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Image.asset(
                      'assets/images/sdc.png',
                      width: 230,
                      height: 230,
                    ),
                  ],
                ),
              ),

              // Right side (form)
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    bottomLeft: Radius.circular(80),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    color: const Color(0xFF0047AB),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFCE8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "We’re here to make your canteen experience faster and smarter.\nReady to order with ease?",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Color(0xFFFFFCE8),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // First & Last Name
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    labelText: "First name",
                                    labelStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                                    hintText: "Enter your first name",
                                    hintStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(color: Color(0xFFFFFCE8)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                                    ),
                                  ),
                                  style: const TextStyle(color: Color(0xFFFFFCE8)),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextField(
                                  controller: lastNameController,
                                  decoration: InputDecoration(
                                    labelText: "Last name",
                                    labelStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                                    hintText: "Enter your last name",
                                    hintStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(color: Color(0xFFFFFCE8)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                                    ),
                                  ),
                                  style: const TextStyle(color: Color(0xFFFFFCE8)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "SDCA Email",
                              labelStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                              hintText: "Enter your SDCA email",
                              hintStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color(0xFFFFFCE8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                              ),
                            ),
                            style: const TextStyle(color: Color(0xFFFFFCE8)),
                          ),
                          const SizedBox(height: 20),

                          // Password
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Create Password",
                              labelStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                              hintText: "Create Password",
                              hintStyle: const TextStyle(color: Color(0xFFFFFCE8)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color(0xFFFFFCE8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color(0xFFFFFCE8), width: 2),
                              ),
                              helperText: "must be at least 8 characters",
                              helperStyle: const TextStyle(color: Color(0xFFFFFCE8), fontSize: 12),
                            ),
                            style: const TextStyle(color: Color(0xFFFFFCE8)),
                          ),
                          const SizedBox(height: 10),

                          // Terms checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: agreeToTerms,
                                activeColor: const Color(0xFFFFFCE8),
                                checkColor: const Color(0xFF0047AB),
                                side: const BorderSide(color: Color(0xFFFFFCE8)),
                                onChanged: (value) {
                                  setState(() {
                                    agreeToTerms = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: Color(0xFFFFFCE8),
                                      fontFamily: 'Montserrat',
                                      fontSize: 13,
                                    ),
                                    children: [
                                      TextSpan(text: "I agree with the "),
                                      TextSpan(
                                        text: "terms and privacy policy",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Create Account button
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
                              onPressed: _createAccount,
                              child: const Text(
                                "Create Account",
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

                          // Already have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(color: Color(0xFFFFFCE8)),
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
                                  "Log in",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
