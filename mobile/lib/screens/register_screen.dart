// mobile/lib/screens/home_screen.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const StockVisionApp());
}

class StockVisionApp extends StatelessWidget {
  const StockVisionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockVision',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Manrope',
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12211A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background gradient circles
            Positioned(
              right: -50,
              top: 146,
              child: Container(
                width: 394,
                height: 394,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF42B5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -52,
              bottom: 100,
              child: Container(
                width: 366,
                height: 366,
                decoration: const BoxDecoration(
                  color: Color(0xFF0AD842),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'StockVision',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          height: 1.28,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(_firstNameController, 'First Name'),
                          const SizedBox(height: 15),
                          _buildTextField(_lastNameController, 'Last Name'),
                          const SizedBox(height: 15),
                          _buildTextField(_dobController, 'Date of Birth'),
                          const SizedBox(height: 15),
                          _buildTextField(_emailController, 'Email'),
                          const SizedBox(height: 15),
                          _buildTextField(_passwordController, 'Password', isPassword: true),
                          const SizedBox(height: 16),
                          
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 4, bottom: 24),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Color(0xFF93C6AA),
                                  fontSize: 14,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ),
                          
                          Container(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MainNavigation()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF14B75B),
                                foregroundColor: const Color(0xFF112119),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPassword = false}) {
    return Container(
      height: 56,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF93C6AA),
            fontSize: 16,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xFF234733),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
