
import 'package:chofair_driver/authentication/login_screen.dart';
import 'package:chofair_driver/widgets/progress_dialog.dart';
import 'package:chofair_driver/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PasswordRecover extends StatefulWidget {
  const PasswordRecover({super.key});


  @override
  State<PasswordRecover> createState() => _PasswordRecoverState();
}

class _PasswordRecoverState extends State<PasswordRecover> {

  TextEditingController emailController = TextEditingController();


validateForm() {
    
    if(!emailController.text.contains('@')) {
      showRedSnackBar(context, 'Utilize um e-mail válido.');
    }
    else {
      resetPassword(emailController.text);
    }
  }

Future<void> resetPassword(String email) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processando...");
      },
    );
    // Navigator.pop(context);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showGreenSnackBar(context, 'Sucesso! Acesse seu e-mail para redefinir sua senha.');
      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
    
    // E-mail de recuperação de senha enviado com sucesso
  } catch (e) {
    Navigator.pop(context);
    showRedSnackBar(context, 'Digite um e-mail válido.');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF222222)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(24),
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
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 80,
                    color: Color(0xFF222222),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Título
                const Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  "Sem problemas! Digite seu e-mail e\nenviaremos instruções para recuperá-la.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Card de recuperação
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
                        controller: emailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          hintText: "Digite seu e-mail cadastrado",
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
                      
                      const SizedBox(height: 24),
                      
                      // Botão enviar
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
                            "ENVIAR INSTRUÇÕES",
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
                
                // Voltar ao login
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const LoginScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: Color(0xFF222222),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Voltar à tela de login',
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ENTRE O LOGINUSERNOW ENTRE O CATCH
 else {
      Navigator.pop(context);
      // Fluttertoast.showToast(msg: "Erro ao entrar");
       const snackBar = SnackBar(
          content: Text('Não existe cadastro de passageiro com esse e-mail', textAlign: TextAlign.center),
          duration: Duration(seconds: 6),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
*/ 

//LOGINUSERNOW ANTIGO
/*  loginUserNow() async {
 // try{ trocar pelo try catch
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: "Processando...");
        }
        );
        
        final User? firebaseUser = (
          await fAuth.signInWithEmailAndPassword(
            email: email.text.trim(),
            password: senha.text.trim(),
          ).catchError((msg){
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Error: $msg');
          })
          ).user;
        
          if(firebaseUser != null) {

            DatabaseReference usersRef= FirebaseDatabase.instance.ref().child("users");
            usersRef.child(firebaseUser.uid).once().then((driverKey)
            {
              final snap = driverKey.snapshot;
              if (snap.value != null)
              {
                currentFirebaseUser = firebaseUser;
                const snackBar = SnackBar( //abre snackbar
                  content: Text('Entrada com sucesso', textAlign: TextAlign.center),
                  duration: Duration(seconds: 6), // Duração da exibição do SnackBar
                  backgroundColor: Colors.green);
                  // Exibir o SnackBar na tela
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // Fluttertoast.showToast(msg: "Entrada com sucesso",
                // // toastLength: Toast.LENGTH_LONG, 
                // // gravity: ToastGravity.BOTTOM,
                // // timeInSecForIosWeb: 2,
                // // backgroundColor: Colors.red,
                // // textColor: Colors.white,
                // // fontSize: 15,
                // );
                // ignore: use_build_context_synchronously
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
              }
               else {
            Fluttertoast.showToast(msg: "Não existe cadastro de passageiro com esse e-mail");
            fAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
          }
            }); 
            
          }
          else {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Erro ao entrar");
          }
  }*/