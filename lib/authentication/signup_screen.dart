import 'package:chofair_driver/authentication/car_info_screen.dart';
import 'package:chofair_driver/authentication/login_screen.dart';
import 'package:chofair_driver/global/global.dart';
import 'package:chofair_driver/widgets/progress_dialog.dart';
import 'package:chofair_driver/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});


  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController celular = TextEditingController();
  TextEditingController senha = TextEditingController();

  validateForm() {
    if(nome.text.length < 3) {
      showRedSnackBar(context, 'Digite seu nome completo.');
    }
    else if(!email.text.contains('@')) {
      showRedSnackBar(context, 'Digite um e-mail válido.');
    }
    else if(celular.text.isEmpty || celular.text.length < 10 || celular.text.length >15) {
      showRedSnackBar(context, 'Digite um número válido com DDD.');
    }
    else if(senha.text.length < 6) {
      showRedSnackBar(context, 'A senha deve ter no mínimo 6 caracteres.');
    }
    else {
      saveDriverInfoNow(context);
    }
  }

//substituído pelo try-catch. TESTAR
  saveDriverInfoNow(context) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processando...");
      },
    );
    
    final UserCredential userCredential = await fAuth.createUserWithEmailAndPassword(
      email: email.text.trim(),
      password: senha.text.trim(),
    );

    final User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nome.text.trim(),
        "email": email.text.trim(),
        "phone": celular.text.trim(),
      };
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      await driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;

      showGreenSnackBar(context, 'Conta criada com sucesso.');
      Navigator.push(context, MaterialPageRoute(builder: (c) => const CarInfoScreen()));
    } 
  } catch (e) {
    Navigator.pop(context);
    showRedSnackBar(context, 'Não foi possível criar sua conta.');
  }
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "images/chofairlogo.png",
                    height: 100,
                    width: 100,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Título
                const Text(
                  "Criar Conta",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  "Junte-se à equipe de motoristas",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Card de registro
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
                      // Nome field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: nome,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "Nome completo",
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Email field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: email,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Celular field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: celular,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Celular",
                          prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Senha field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: senha,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão criar conta
                      SizedBox(
                        width: double.infinity,
                        height: 56,
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
                            "CRIAR CONTA",
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
                
                // Já tem conta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta? ',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (c) => LoginScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Acesse aqui!',
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



//sem try-catch e com aviso:
// saveDriverInfoNow() async {
//  // try{ trocar pelo try catch O PRIMEIRO E QUE FUNCIONA APESAR DO AVISO
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext c) {
//           return ProgressDialog(message: "Processando...");
//         }
//         );
        
//         final User? firebaseUser = (
//           await fAuth.createUserWithEmailAndPassword(
//             email: email.text.trim(),
//             password: senha.text.trim(),
//           ).catchError((msg){
//             Navigator.pop(context);
//             Fluttertoast.showToast(msg: 'Error: $msg');
//           })
//           ).user;
        
//           if(firebaseUser != null) {
//             Map driverMap = {
//               "id": firebaseUser.uid,
//               "name": nome.text.trim(),
//               "email": email.text.trim(),
//               "phone": celular.text.trim(),
//             };
//             DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
//             driversRef.child(firebaseUser.uid).set(driverMap);

//             currentFirebaseUser = firebaseUser;
//             const snackBar = SnackBar(
//               content: Text('Conta criada com sucesso.', textAlign: TextAlign.center),
//               duration: Duration(seconds: 4),backgroundColor: Colors.red);
//               ScaffoldMessenger.of(context).showSnackBar(snackBar);
//             // Fluttertoast.showToast(msg: "Conta criada com sucesso");
//             // ignore: use_build_context_synchronously
//             Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));
//           }
//           else {
//             // ignore: use_build_context_synchronously
//             Navigator.pop(context);
//             Fluttertoast.showToast(msg: "Não foi possível criar sua conta");
//           }
//   }