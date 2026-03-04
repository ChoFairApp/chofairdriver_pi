# GUIA DE MODERNIZAÇÃO - PARTE 2: DESIGN SYSTEM COMPLETO

**Continuação do Guia de Modernização Chofair User App**

---

## 7.3 Password Recovery Screen

#### 🎯 Design Characteristics
- Simples e clean
- Ícone de cadeado no topo
- Um único campo (e-mail)
- Instruções claras

#### 📱 Código Completo

**Arquivo:** `lib/authentication/password_recover.dart`

```dart
import 'package:chofair_user/authentication/login_screen.dart';
import 'package:chofair_user/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordRecover extends StatefulWidget {
  const PasswordRecover({super.key});

  @override
  State<PasswordRecover> createState() => _PasswordRecoverState();
}

class _PasswordRecoverState extends State<PasswordRecover> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void resetPassword() async {
    if (!emailController.text.contains('@')) {
      showRedSnackBar(context, 'Digite um e-mail válido.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (mounted) {
        showGreenSnackBar(
          context,
          'Link de recuperação enviado para seu e-mail!',
        );
        
        // Aguardar 2 segundos e voltar para login
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => const LoginScreen()),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showRedSnackBar(context, 'Erro ao enviar e-mail. Verifique o endereço.');
      }
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
                // Ícone de cadeado
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Color(0xFF222222),
                  ),
                ),

                const SizedBox(height: 32),

                // Título
                const Text(
                  "Recuperar Senha",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Instruções
                Text(
                  "Digite seu e-mail para receber\no link de recuperação",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Campo de E-mail
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF222222),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF222222),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botão Enviar
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222222),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Enviar Link",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Voltar para login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Voltar para Login",
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
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
```

---

## 7.4 Splash Screen - Animado

#### 🎯 Design Characteristics
- Gradiente suave de fundo
- Logo com animação de fade + escala
- Loading indicator moderno
- Transição automática

#### 📱 Código Completo

**Arquivo:** `lib/splashScreen/splash_screen.dart`

```dart
import 'dart:async';
import 'package:chofair_user/authentication/login_screen.dart';
import 'package:chofair_user/global/global.dart';
import 'package:chofair_user/mainScreens/main_screen.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const MainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Configurar animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
    startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[100]!,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo com container circular
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 10,
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "images/chofairlogo.png",
                      height: 150,
                      width: 150,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Texto principal
                  const Text(
                    'Viaje com segurança!',  // Para User app
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF222222).withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 7.5 Home Screen - Dashboard Moderno

Para o User App, a Home screen terá funcionalidade diferente (solicitar corrida), mas pode seguir o mesmo design system do Driver App.

#### 🎯 Características do Driver App (Referência)
- Header dinâmico com gradiente (verde online, cinza offline)
- Cards de estatísticas (corridas, ganhos)
- Mapa compacto (250px de altura)
- Informações contextuais
- Design limpo e espaçado

#### 📋 Adaptação para User App

```dart
// Home Screen para PASSAGEIROS
// Arquivo: lib/tabPages/home_tab.dart (User App)

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chofair_user/global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? mapController;
  
  // Locais de origem e destino
  String pickupAddress = "Adicionar local de partida";
  String destinationAddress = "Para onde?";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header moderno
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF222222), Color(0xFF444444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Olá!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            currentFirebaseUser?.displayName ?? 'Passageiro',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Avatar do usuário
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF222222),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Mapa expandido
            Expanded(
              child: Stack(
                children: [
                  // Google Maps
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(-22.2963, -48.5587),
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),

                  // Card de solicitação sobre o mapa
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Campo de origem
                          _buildLocationField(
                            icon: Icons.radio_button_checked,
                            iconColor: Colors.green,
                            text: pickupAddress,
                            onTap: () {
                              // Abrir tela de busca de endereço
                            },
                          ),

                          const SizedBox(height: 12),

                          // Campo de destino
                          _buildLocationField(
                            icon: Icons.location_on,
                            iconColor: Colors.red,
                            text: destinationAddress,
                            onTap: () {
                              // Abrir tela de busca de endereço
                            },
                          ),

                          const SizedBox(height: 16),

                          // Botão de solicitar corrida
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                // Solicitar corrida
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF222222),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Solicitar Corrida',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botão de centralizar localização
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF222222),
                      mini: true,
                      onPressed: () {
                        // Centralizar no usuário
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: text.contains('Adicionar') || text.contains('onde')
                      ? Colors.grey[600]
                      : const Color(0xFF222222),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎭 DESIGN SYSTEM - IDENTIDADE VISUAL

Esta seção consolida **TODOS** os padrões de design usados no Driver App para você replicar **exatamente** no User App.

### 🎨 Paleta de Cores

```dart
// Cores Primárias
const Color primaryColor = Color(0xFF222222);  // Quase preto
const Color primaryLight = Color(0xFF444444);
const Color primaryDark = Color(0xFF000000);

// Fundos
const Color backgroundColor = Color(0xFFF5F5F5);  // grey[100]
const Color cardBackground = Colors.white;

// Estados
const Color successColor = Color(0xFF4CAF50);   // Verde
const Color errorColor = Color(0xFFF44336);     // Vermelho
const Color warningColor = Color(0xFFFF9800);   // Laranja
const Color infoColor = Color(0xFF2196F3);      // Azul

// Textos
const Color textPrimary = Color(0xFF222222);
const Color textSecondary = Color(0xFF757575);  // grey[600]
const Color textDisabled = Color(0xFFBDBDBD);   // grey[400]

// Bordas
const Color borderColor = Color(0xFFE0E0E0);    // grey[300]
const Color borderFocused = Color(0xFF222222);
```

### 📏 Espaçamentos

```dart
// Sistema de espaçamento 8dp
const double space4  = 4.0;
const double space8  = 8.0;
const double space12 = 12.0;
const double space16 = 16.0;
const double space20 = 20.0;
const double space24 = 24.0;
const double space32 = 32.0;
const double space40 = 40.0;
const double space56 = 56.0;
```

### 🔤 Tipografia

```dart
// Títulos
const TextStyle titleLarge = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Color(0xFF222222),
);

const TextStyle titleMedium = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF222222),
);

const TextStyle titleSmall = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Color(0xFF222222),
);

// Corpo
const TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  color: Color(0xFF222222),
);

const TextStyle bodyMedium = TextStyle(
  fontSize: 15,
  color: Color(0xFF222222),
);

const TextStyle bodySmall = TextStyle(
  fontSize: 14,
  color: Color(0xFF757575),
);

// Botões
const TextStyle buttonText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
```

### 📦 Componentes Reutilizáveis

#### Card Padrão

```dart
Widget buildStandardCard({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: child,
  );
}
```

#### TextField Padrão

```dart
Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF222222)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
      ),
    ),
  );
}
```

#### Botão Primário

```dart
Widget buildPrimaryButton({
  required String text,
  required VoidCallback onPressed,
  bool isLoading = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF222222),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
}
```

#### Card de Estatística

```dart
Widget buildStatCard({
  required String title,
  required String value,
  required IconData icon,
  Color? iconColor,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF222222))
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor ?? const Color(0xFF222222),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

#### SnackBar Customizado

```dart
// widgets/snack_bar.dart

import 'package:flutter/material.dart';

void showGreenSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF4CAF50),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
    ),
  );
}

void showRedSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF44336),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
    ),
  );
}
```

#### Progress Dialog

```dart
// widgets/progress_dialog.dart

import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String message;

  const ProgressDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF222222),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF222222),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ☁️ CLOUDINARY COMO ALTERNATIVA

Firebase Storage tem **limite de 5GB gratuitos** e **1GB de download/dia**. Para apps com muitos usuários, isso pode ficar caro. **Cloudinary** é uma alternativa gratuita mais generosa.

### 📊 Comparação

| Recurso | Firebase Storage (Free) | Cloudinary (Free) |
|---------|------------------------|-------------------|
| **Armazenamento** | 5 GB | 25 GB |
| **Largura de Banda** | 1 GB/dia | 25 GB/mês |
| **Transformações** | Não | Sim (redimensionar, otimizar) |
| **CDN** | Sim | Sim (mais rápido) |
| **Preço após limite** | Pago (caro) | Pago (barato) |

### 🔧 Como Integrar Cloudinary

#### 1. Criar Conta

1. Acesse https://cloudinary.com/users/register_free
2. Crie conta gratuita
3. Anote: **Cloud Name**, **API Key**, **API Secret**

#### 2. Adicionar Dependência

```yaml
# pubspec.yaml
dependencies:
  cloudinary_public: ^0.23.0
  http: ^1.2.2
```

#### 3. Criar Serviço de Upload

```dart
// lib/services/cloudinary_upload_service.dart

import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryUploadService {
  final cloudinary = CloudinaryPublic(
    'SEU_CLOUD_NAME',  // Substituir
    'PRESET_UNSIGNED',  // Criar no console Cloudinary
    cache: false,
  );

  final ImagePicker _picker = ImagePicker();

  // Upload de foto de perfil
  Future<String?> uploadProfilePhoto(ImageSource source) async {
    try {
      // 1. Escolher imagem
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;

      // 2. Upload para Cloudinary
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'chofair/profile_photos',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      // 3. Retornar URL segura
      return response.secureUrl;
    } catch (e) {
      print('Erro no upload Cloudinary: $e');
      return null;
    }
  }

  // Upload de documento
  Future<String?> uploadDocument(File file, String documentType) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: 'chofair/documents/$documentType',
          resourceType: file.path.endsWith('.pdf')
              ? CloudinaryResourceType.Raw
              : CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } catch (e) {
      print('Erro no upload de documento: $e');
      return null;
    }
  }

  // Deletar imagem
  Future<bool> deleteImage(String publicId) async {
    try {
      await cloudinary.deleteResource(publicId);
      return true;
    } catch (e) {
      print('Erro ao deletar: $e');
      return false;
    }
  }
}
```

#### 4. Configurar Upload Preset (Unsigned)

No Cloudinary Console:
1. **Settings** → **Upload** → **Upload presets**
2. **Add upload preset**
3. Signing Mode: **Unsigned**
4. Nome: `usuario_chofair_preset`
5. Folder: `chofair/`
6. **Save**

#### 5. Usar no App

```dart
// Exemplo de uso
import 'package:chofair_user/services/cloudinary_upload_service.dart';

class ProfileScreen extends StatefulWidget {
  // ...
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CloudinaryUploadService _cloudinaryService = CloudinaryUploadService();

  void _uploadPhotoFromGallery() async {
    setState(() {
      isUploading = true;
    });

    String? photoUrl = await _cloudinaryService.uploadProfilePhoto(
      ImageSource.gallery,
    );

    if (photoUrl != null) {
      // Salvar URL no Firebase Database
      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentFirebaseUser!.uid)
          .update({"photoUrl": photoUrl});

      setState(() {
        profilePhotoUrl = photoUrl;
        isUploading = false;
      });
    } else {
      setState(() {
        isUploading = false;
      });
    }
  }
}
```

### ✅ Vantagens do Cloudinary

1. **25GB de armazenamento grátis** (5x mais que Firebase)
2. **25GB de banda/mês** vs 1GB/dia Firebase
3. **Transformações automáticas**: redimensionar, otimizar, converter
4. **CDN global**: imagens carregam mais rápido
5. **Sem necessidade de servidor**: upload direto do app
6. **URLs otimizadas**: `.../q_auto,f_auto/.../imagem.jpg` (compressão automática)

### ⚠️ Desvantagens

1. Mais uma dependência externa
2. Requer configuração adicional
3. URLs públicas (não tão privadas quanto Firebase com rules)

---

## 💾 ESTRUTURA DE DADOS FIREBASE

### Database Structure (Realtime Database)

```json
{
  "users": {
    "USER_ID_123": {
      "id": "USER_ID_123",
      "name": "João Silva",
      "email": "joao@email.com",
      "phone": "+55 11 98765-4321",
      "photoUrl": "https://..../profile.jpg",
      "photoUpdatedAt": "2026-03-15T10:30:00.000Z",
      "documents": {
        "rg": {
          "url": "https://..../rg.jpg",
          "type": "image",
          "uploadedAt": "2026-03-15T11:00:00.000Z",
          "status": "pending_review"
        },
        "cnh": {
          "url": "https://..../cnh.jpg",
          "type": "image",
          "uploadedAt": "2026-03-15T11:05:00.000Z",
          "status": "approved"
        }
      },
      "trips": {
        "TRIP_ID_456": {
          "driverId": "DRIVER_ID_789",
          "driverName": "Maria Santos",
          "originAddress": "Rua A, 123",
          "destinationAddress": "Rua B, 456",
          "fare": 25.50,
          "distance": 5.2,
          "duration": 15,
          "status": "completed",
          "requestedAt": "2026-03-15T12:00:00.000Z",
          "completedAt": "2026-03-15T12:15:00.000Z",
          "rating": {
            "stars": 5,
            "comment": "Ótima viagem!"
          }
        }
      }
    }
  },

  "drivers": {
    "DRIVER_ID_789": {
      "id": "DRIVER_ID_789",
      "name": "Maria Santos",
      "email": "maria@email.com",
      "phone": "+55 11 91234-5678",
      "photoUrl": "https://..../driver_profile.jpg",
      "car": {
        "model": "Honda Civic",
        "number": "ABC-1234",
        "color": "Preto",
        "type": "Sedã"
      },
      "documents": {
        "cnh": {
          "url": "https://..../cnh.jpg",
          "type": "image",
          "uploadedAt": "2026-03-10T10:00:00.000Z",
          "status": "approved"
        },
        "vehicle": {
          "url": "https://..../crlv.jpg",
          "type": "image",
          "uploadedAt": "2026-03-10T10:05:00.000Z",
          "status": "approved"
        }
      },
      "trips": {
        "TRIP_ID_456": {
          "userId": "USER_ID_123",
          "userName": "João Silva",
          "originAddress": "Rua A, 123",
          "destinationAddress": "Rua B, 456",
          "fare": 25.50,
          "completedAt": "2026-03-15T12:15:00.000Z"
        }
      },
      "ratings": {
        "RATING_ID_111": {
          "stars": 5,
          "comment": "Motorista pontual e educado!",
          "userName": "João Silva",
          "date": "2026-03-15T12:20:00.000Z"
        }
      }
    }
  },

  "allRideRequests": {
    "REQUEST_ID_999": {
      "userId": "USER_ID_123",
      "userName": "João Silva",
      "userPhone": "+55 11 98765-4321",
      "originAddress": "Rua A, 123",
      "originLat": -22.2963,
      "originLng": -48.5587,
      "destinationAddress": "Rua B, 456",
      "destinationLat": -22.3001,
      "destinationLng": -48.5623,
      "status": "waiting",
      "driverId": null,
      "driverName": null,
      "requestedAt": "2026-03-15T12:00:00.000Z",
      "declinedBy": {
        "DRIVER_ID_111": true,
        "DRIVER_ID_222": true
      }
    }
  },

  "activeDrivers": {
    "DRIVER_ID_789": {
      "lat": -22.2970,
      "lng": -48.5590,
      "name": "Maria Santos",
      "phone": "+55 11 91234-5678",
      "carModel": "Honda Civic",
      "carColor": "Preto",
      "lastUpdate": "2026-03-15T12:25:00.000Z"
    }
  }
}
```

---

## ✅ CHECKLIST FINAL

### Antes da Compilação

- [ ] Atualizar `pubspec.yaml` com todas as dependências
- [ ] Executar `flutter pub get`
- [ ] Atualizar `gradle-wrapper.properties` para Gradle 8.12
- [ ] Atualizar `build.gradle` (root) - Kotlin 2.3.0, AGP 8.9.1
- [ ] Atualizar `build.gradle` (app) - namespace, compileSdk 36
- [ ] Atualizar `settings.gradle`
- [ ] Adicionar `google-services.json` atualizado
- [ ] Configurar permissões no `AndroidManifest.xml`
- [ ] Adicionar API Key do Google Maps

### Durante Compilação

- [ ] Executar `flutter clean`
- [ ] Executar `flutter pub get`
- [ ] Verificar erros com `flutter analyze`
- [ ] Compilar: `flutter run` ou `flutter build apk`
- [ ] Corrigir erros de código deprecated
- [ ] Testar em dispositivo físico

### Depois da Compilação

- [ ] Testar login/signup
- [ ] Testar upload de foto de perfil
- [ ] Testar upload de documentos
- [ ] Testar solicitação de corrida
- [ ] Testar push notifications
- [ ] Testar Google Maps (zoom, marcadores, rotas)
- [ ] Verificar Firebase Database (dados salvos corretamente)
- [ ] Verificar Firebase Storage (arquivos enviados)

### Testes Funcionais

- [ ] Criar conta de usuário
- [ ] Fazer login
- [ ] Adicionar foto de perfil
- [ ] Enviar documentos (RG, CNH)
- [ ] Solicitar corrida
- [ ] Receber notificação de motorista
- [ ] Avaliar motorista após corrida
- [ ] Visualizar histórico de corridas
- [ ] Testar recuperação de senha

---

## 🔍 SOLUÇÃO DE PROBLEMAS

### Problema: Erro de compilação Gradle

```
Could not find com.android.tools.build:gradle:8.9.1
```

**Solução:**
- Verificar conexão com internet
- Limpar cache: `flutter clean ; flutter pub get`
- Verificar repositórios em `build.gradle`:
  ```gradle
  repositories {
    google()
    mavenCentral()
  }
  ```

### Problema: Namespace não definido

```
A problem occurred configuring project ':app'.
> Namespace not specified
```

**Solução:**
- Adicionar em `android/app/build.gradle`:
  ```gradle
  android {
      namespace = "com.chofair.user"
      // ...
  }
  ```

### Problema: Firebase Storage upload falha

```
firebase_storage/object-not-found
```

**Solução:**
- Configurar Security Rules no Firebase Console
- Verificar se `google-services.json` está atualizado
- Verificar permissões de Storage no Firebase Console

### Problema: Google Maps não carrega

```
Map not loading / blank screen
```

**Solução:**
- Verificar API Key no `AndroidManifest.xml`
- Habilitar APIs no Google Cloud Console:
  - Maps SDK for Android
  - Directions API
  - Places API
- Verificar permissões de localização

### Problema: Color.withOpacity deprecated

```
'withOpacity' is deprecated
```

**Solução:**
- Substituir `.withOpacity(0.5)` por `.withValues(alpha: 0.5)`

---

## 🔄 DIFERENÇAS DRIVER VS USER

| Aspecto | Driver App | User App |
|---------|-----------|----------|
| **Tela Principal** | Botão Conectar/Desconectar | Solicitar corrida |
| **Mapa** | Mostra posição do motorista | Mostra origem/destino |
| **Notificações** | Pedido de corrida de passageiro | Motorista aceitou/chegou |
| **Perfil** | CNH + Documento do veículo | RG ou CNH (opcional) |
| **Histórico** | Corridas realizadas | Corridas solicitadas |
| **Ganhos** | Tela de ganhos | Tela de gastos/pagamentos |
| **Avaliações** | Recebe avaliações | Dá avaliações |

---

## 🔒 SEGURANÇA

### Firebase Security Rules - Produção

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "allRideRequests": {
      ".read": "auth != null",
      "$requestId": {
        ".write": "auth != null && (!data.exists() || data.child('userId').val() === auth.uid || data.child('driverId').val() === auth.uid)"
      }
    }
  }
}
```

### Boas Práticas

1. **Nunca commitar `google-services.json`** com credenciais reais
2. **Usar variáveis de ambiente** para API keys
3. **Validar entradas** do usuário (e-mail, telefone, senhas)
4. **Sanitizar dados** antes de salvar no Firebase
5. **Implementar rate limiting** para evitar spam
6. **Criptografar dados sensíveis** (documentos)
7. **Implementar 2FA** (autenticação em dois fatores)

---

## 📚 RECURSOS ADICIONAIS

### Documentação Oficial

- **Flutter:** https://flutter.dev/docs
- **Firebase:** https://firebase.google.com/docs
- **Google Maps:** https://developers.google.com/maps/documentation
- **Cloudinary:** https://cloudinary.com/documentation

### Packages Úteis

- **image_picker:** https://pub.dev/packages/image_picker
- **flutter_image_compress:** https://pub.dev/packages/flutter_image_compress
- **file_picker:** https://pub.dev/packages/file_picker
- **cached_network_image:** https://pub.dev/packages/cached_network_image
- **geolocator:** https://pub.dev/packages/geolocator
- **google_maps_flutter:** https://pub.dev/packages/google_maps_flutter

### Comandos Úteis

```bash
# Limpar projeto
flutter clean

# Atualizar dependências
flutter pub get

# Verificar problemas
flutter doctor -v
flutter analyze

# Compilar APK
flutter build apk --release

# Compilar para iOS
flutter build ios --release

# Ver logs
flutter logs

# Hot reload
r

# Hot restart
R
```

---

## 🎯 PRÓXIMOS PASSOS

1. **Implementar User App** seguindo exatamente os padrões do Driver App
2. **Testar extensivamente** em dispositivos reais
3. **Configurar CI/CD** (GitHub Actions, CodeMagic)
4. **Preparar para produção:**
   - Gerar chaves de assinatura
   - Configurar Firebase App Distribution
   - Preparar store listings (Play Store, App Store)
5. **Monitoramento:**
   - Firebase Crashlytics
   - Firebase Analytics
   - Performance Monitoring

---

## 📝 CONCLUSÃO

Este guia documenta **TODO O PROCESSO** de modernização do Chofair Driver App, desde o estado não-funcional de 2023 até a versão completamente redesenhada e funcional de 2026.

### ✅ O que foi alcançado:

1. **App 100% funcional** - Sem erros de compilação
2. **Totalmente moderno** - Dependências 2026, Android SDK 36
3. **UI/UX profissional** - Design consistente e moderno
4. **Funcionalidades completas** - Upload de fotos, documentos, estatísticas
5. **Código limpo** - Validações, tratamento de erros, feedback visual

### 🎨 Design System Estabelecido:

- Cores: `#222222` primário, fundos cinza claro, cards brancos
- Tipografia: Hierarquia clara, pesos consistentes
- Espaçamentos: Sistema 8dp (4, 8, 12, 16, 24, 32)
- Componentes: Cards, botões, inputs padronizados
- Sombras: Sutis (0.05-0.1 opacity)

### 🚀 Para o User App:

**REPLIQUE EXATAMENTE** o design system apresentado neste guia:
- Use os mesmos componentes
- Mantenha as mesmas cores
- Siga os mesmos padrões de espaçamento
- Reutilize os widgets (SnackBar, ProgressDialog, etc.)
- Adapte a lógica de negócio (User solicita, Driver aceita)

---

**Data de conclusão:** Março 2026  
**Versão do documento:** 2.0 - Auditoria Completa  
**Autor:** GitHub Copilot  

**Qualquer dúvida sobre implementação, consulte os exemplos de código completos fornecidos neste guia.** 🚀

