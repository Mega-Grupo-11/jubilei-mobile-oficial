import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'register.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Versão automática - descomente para habilitar transição automática
    // Timer(Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginScreen())
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para dimensionar proporcionalmente
    final screenSize = MediaQuery.of(context).size;
    final imageWidth = screenSize.width * 0.75;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.1),

              // Título principal
              Text(
                'SUAS TAREFAS\nORGANIZADAS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),

              SizedBox(height: 30),

              // Imagem principal
              Container(
                width: imageWidth,
                height: imageWidth * 0.8,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'imgs/LOGO-E-IMG.png',
                  fit: BoxFit.contain,
                  height: 200,
                ),
              ),

              SizedBox(height: 30),

              // Logo TO-DO TOOL
              Image.asset(
                'imgs/LOGO-E-IMG.png',
                height: 100,
                fit: BoxFit.contain,
              ),

              Spacer(),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text('login', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'cadastre-se',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
