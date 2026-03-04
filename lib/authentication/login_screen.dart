import 'package:chofair_driver/authentication/password_recover.dart';
import 'package:chofair_driver/authentication/signup_screen.dart';
import 'package:chofair_driver/global/global.dart';
import 'package:chofair_driver/splashScreen/splash_screen.dart';
import 'package:chofair_driver/widgets/progress_dialog.dart';
import 'package:chofair_driver/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  validateForm() {
    if (!email.text.contains('@')) {
      showRedSnackBar(context, 'Insira um e-mail válido.');
    } else if (senha.text.length < 6) {
      showRedSnackBar(context, 'A senha deve ter no mínimo 6 caracteres.');
    } else {
      loginDriverNow(context);
    }
  }

// try{ trocar pelo try catch
  loginDriverNow(context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: "Processando...");
        },
      );

      final UserCredential userCredential =
          await fAuth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: senha.text.trim(),
      );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DatabaseReference driversRef =
            FirebaseDatabase.instance.ref().child("drivers");
        final driverKey = await driversRef.child(firebaseUser.uid).once();
        final snap = driverKey.snapshot;

        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          showGreenSnackBar(context, 'Entrada com sucesso.');

          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
        // else {
        //   Fluttertoast.showToast(msg: "Não existe cadastro de motorista com esse e-mail.");
        //   fAuth.signOut();
        //   Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
        // }
      }
    } catch (e) {
      Navigator.pop(context);
      showRedSnackBar(context, 'E-mail ou senha incorretos.');
    }

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext c) {
    //       return ProgressDialog(message: "Entrando. Aguarde por favor...");
    //     }
    //     );

    //     final User? firebaseUser = (
    //       await fAuth.signInWithEmailAndPassword(
    //         email: email.text.trim(),
    //         password: senha.text.trim(),
    //       ).catchError((msg){
    //         Navigator.pop(context);
    //         Fluttertoast.showToast(msg: 'Error: $msg');
    //       })
    //       ).user;

    //       if(firebaseUser != null) {

    //         DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    //         driversRef.child(firebaseUser.uid).once().then((driverKey)
    //         {
    //           final snap = driverKey.snapshot;
    //           if (snap.value != null)
    //           {
    //             currentFirebaseUser = firebaseUser;
    //             Fluttertoast.showToast(msg: "Entrada com sucesso");
    //             // ignore: use_build_context_synchronously
    //             Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
    //           }
    //            else {
    //         Fluttertoast.showToast(msg: "Não existe cadastro de motorista com esse e-mail");
    //         fAuth.signOut();
    //         Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
    //       }
    //         });
    //       }

    //       else {
    //         // ignore: use_build_context_synchronously
    //         Navigator.pop(context);
    //         Fluttertoast.showToast(msg: "Erro ao entrar. Tente novamente em alguns instantes");
    //       }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "images/chofairlogo.png",
                    height: 120,
                    width: 120,
                  ),
                ),

                const SizedBox(height: 20),

                // Título
                const Text(
                  "Bem-vindo de volta!",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Entre como Motorista",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 30),

                // Card de login
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Email field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: email,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Senha field
                      TextField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: senha,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Esqueci senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const PasswordRecover()),
                            );
                          },
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Botão entrar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            validateForm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222222),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "ENTRAR",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Criar conta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ainda não tem uma conta? ',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const SignUpScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Crie agora!',
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
