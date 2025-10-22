import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

// Constantes de color (se asume que se definen en routes.dart o similar)
const Color kCorporatePrimaryColor = Color(0xFF005691);
const Color kCorporateAccentColor = Color(0xFF14B8A6);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bienvenido de nuevo ${userCredential.user!.email}'),
          backgroundColor: Colors.green,
        ),
      );
      // Navegación a home
      Navigator.pushReplacementNamed(context, Routes.home);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'El usuario no está registrado.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      } else {
        message = 'Error: ${e.message}';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCorporateTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            hintText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType:
              isPassword ? TextInputType.text : TextInputType.emailAddress,
          obscureText: isPassword ? _obscureText : false,
          cursorColor: kCorporateAccentColor,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'ejemplo@medilink.com',
            hintStyle: TextStyle(color: Colors.grey.shade400),

            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 0),
              child: Icon(prefixIcon, color: Colors.grey.shade500, size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 20,
            ),

            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : null,

            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: kCorporateAccentColor,
                width: 2.5,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$hintText es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktopOrTablet = MediaQuery.of(context).size.width > 800;

    final loginFormContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktopOrTablet ? 40 : 25,
        vertical: isDesktopOrTablet ? 40 : 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  // Logo
                  Icon(
                    Icons.favorite_outline,
                    size: isDesktopOrTablet ? 70 : 50,
                    color: kCorporateAccentColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'MediLink',
                    style: TextStyle(
                      fontSize: isDesktopOrTablet ? 40 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inicia sesión en tu cuenta profesional.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            SizedBox(height: isDesktopOrTablet ? 40 : 30),

            // --- Formulario ---
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCorporateTextField(
                    controller: emailController,
                    hintText: 'Correo Electrónico',
                    prefixIcon: Icons.mail_outline,
                  ),
                  const SizedBox(height: 20),
                  _buildCorporateTextField(
                    controller: passwordController,
                    hintText: 'Contraseña',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pronto disponible: Recuperar contraseña',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        '¿Olvidó su contraseña?',
                        style: TextStyle(
                          color: kCorporateAccentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botón INICIAR SESIÓN (Primario - Azul Oscuro)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kCorporatePrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3.0,
                              ),
                            )
                            : const Text(
                              'INICIAR SESIÓN',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                  const SizedBox(height: 20),

                  // Separador 'o'
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'o',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botón CREAR CUENTA NUEVA (Secundario - Outlined)
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Próximamente: Crear cuenta nueva'),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kCorporateAccentColor,
                      side: const BorderSide(
                        color: kCorporateAccentColor,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'CREAR CUENTA NUEVA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // --- Diseño Responsivo (Móvil vs. Desktop) ---
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child:
            isDesktopOrTablet
                ? Container(
                  width: 1200,
                  height: 800,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // PANEL IZQUIERDO (Branding - Desktop)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: kCorporatePrimaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                            ),
                          ),
                          child: _BrandingPanel(),
                        ),
                      ),
                      // PANEL DERECHO (Formulario - Desktop)
                      Expanded(child: loginFormContent),
                    ],
                  ),
                )
                // Diseño Móvil (Columna Centrada)
                : Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: loginFormContent,
                ),
      ),
    );
  }
}

// Widget de Panel de Branding (Desktop)
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.monitor_heart_outlined,
            size: 96,
            color: Color(0xFF5DD9C2),
          ),
          const SizedBox(height: 24),
          const Text(
            'MediLink',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu portal de salud unificado. Accede a tu historial, agenda y teleconsultas de forma segura.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 30),
          // Placeholder para la imagen de "Tu Salud Primero"
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Imagen de Branding',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}
