import 'package:flutter/material.dart';

class StockVisionLoginScreen extends StatefulWidget {
  const StockVisionLoginScreen({Key? key}) : super(key: key);

  @override
  State<StockVisionLoginScreen> createState() => _StockVisionLoginScreenState();
}

class _StockVisionLoginScreenState extends State<StockVisionLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
              left: -114,
              bottom: 100,
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
              right: -100,
              top: 56,
              child: Container(
                width: 366,
                height: 366,
                decoration: const BoxDecoration(
                  color: Color(0xFF0AD842),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top title
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
                  
                  const Spacer(flex: 2),
                  
                  // Login form
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email field
                        Container(
                          height: 56,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Email',
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
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        
                        // Password field
                        Container(
                          height: 56,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Password',
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
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: const Color(0xFF93C6AA),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        // Forgot password
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 4, bottom: 24),
                          child: GestureDetector(
                            onTap: () {
                              // Handle forgot password
                              print('Forgot password pressed');
                            },
                            child: const Text(
                              'Forgot Password?',
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
                        
                        // Login button
                        Container(
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle login
                              print('Login pressed');
                              print('Email: ${_emailController.text}');
                              print('Password: ${_passwordController.text}');
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
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                          ),
                        ),
                        
                        // Register button
                        Container(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle register
                              print('Register pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF234733),
                              foregroundColor: Colors.white,
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
                  
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Example usage in main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockVision',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Manrope',
      ),
      home: const StockVisionLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(MyApp());
}
