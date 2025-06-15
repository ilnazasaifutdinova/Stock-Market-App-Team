import 'package:flutter/material.dart';
import 'package:stock_market_app/screens/main_navigation.dart';
import 'package:stock_market_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}): 
super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            
            SafeArea(
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
                  
                  const Spacer(flex: 2),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 4, bottom: 24),
                          child: GestureDetector(
                            onTap: () {
                              // Handle forgot password
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
                        
                        Container(
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 12),
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
                        
                        Container(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
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