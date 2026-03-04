# 📱 GUIA COMPLETO DE MODERNIZAÇÃO - CHOFAIR USER APP
**Auditoria Completa & Design System para Replicação**

**Projeto:** Chofair User (Aplicativo de Passageiro)  
**Baseado em:** Modernização Completa do Chofair Driver App (2023 → 2026)  
**Data:** Março 2026  
**Versão:** 2.0 - Auditoria Completa Pós-Implementação

---

## 📋 ÍNDICE

1. [🎯 Resumo Executivo](#-resumo-executivo)
2. [📊 Auditoria Completa de Mudanças](#-auditoria-completa-de-mudanças)
3. [🗺️ Roadmap de Modernização](#️-roadmap-de-modernização)
4. [📦 FASE 1: Auditoria Inicial](#-fase-1-auditoria-inicial)
5. [⚙️ FASE 2: Atualização de Dependências](#️-fase-2-atualização-de-dependências)
6. [🤖 FASE 3: Configuração Android](#-fase-3-configuração-android)
7. [🔧 FASE 4: Correção de Código Obsoleto](#-fase-4-correção-de-código-obsoleto)
8. [🔥 FASE 5: Configuração Firebase](#-fase-5-configuração-firebase)
9. [🛠️ FASE 6: Serviços Criados](#️-fase-6-serviços-criados)
10. [🎨 FASE 7: Redesign Completo de UI/UX](#-fase-7-redesign-completo-de-uiux)
11. [🎭 Design System - Identidade Visual](#-design-system---identidade-visual)
12. [✨ Novas Funcionalidades](#-novas-funcionalidades)
13. [☁️ Cloudinary como Alternativa](#️-cloudinary-como-alternativa)
14. [💾 Estrutura de Dados Firebase](#-estrutura-de-dados-firebase)
15. [✅ Checklist Final](#-checklist-final)
16. [🔍 Solução de Problemas](#-solução-de-problemas)
17. [🔄 Diferenças Driver vs User](#-diferenças-driver-vs-user)
18. [🔒 Segurança](#-segurança)
19. [📚 Recursos Adicionais](#-recursos-adicionais)

---

## 🎯 RESUMO EXECUTIVO

Este guia documenta **TODA A JORNADA** de modernização do **Chofair Driver App**, desde o estado não-funcional de 2023 até a versão moderna, totalmente funcional e redesenhada de 2026.

### ⚡ Estado Atual do Driver App

**✅ COMPLETAMENTE FUNCIONAL E MODERNIZADO**

#### O que foi Alcançado:
- ✅ **100% Funcional** - App compila e executa sem erros
- ✅ **Dependências Atualizadas** - Flutter 3.41.0, Dart 3.11.0, Firebase 2024-2026
- ✅ **Android Moderno** - Gradle 8.12, AGP 8.9.1, Kotlin 2.3.0, targetSdk 36
- ✅ **零 APIs Deprecadas** - Todas substituídas por versões atuais
- ✅ **UI/UX Completamente Redesenhada** - Design moderno, consistente e profissional
- ✅ **Novos Recursos** - Upload de fotos, documentos (CNH/CRLV), estatísticas
- ✅ **Firebase Integrado** - Auth, Database, Storage, Messaging
- ✅ **Código Limpo** - Tratamento de erros, validações, feedback visual

---

## 📊 AUDITORIA COMPLETA DE MUDANÇAS

### 🕐 Linha do Tempo Cronológica

```
2023 (Estado Inicial - Não Funcional)
  ├─ Dependências desatualizadas (Flutter 2.x)
  ├─ Erros de compilação no Android
  ├─ APIs deprecadas não compilam
  ├─ Firebase mal configurado
  ├─ Funcionalidades incompletas
  └─ UI básica e inconsistente

⬇️  MODERNIZAÇÃO INICIADA

2024-2025 (Fase 1: Correções Essenciais)
  ├─ ✅ Atualização Flutter 3.41.0 / Dart 3.11.0
  ├─ ✅ Migração Gradle 7.5 → 8.12
  ├─ ✅ Atualização Android Gradle Plugin → 8.9.1
  ├─ ✅ Kotlin 1.7.10 → 2.3.0
  ├─ ✅ compileSdk/targetSdk 33 → 36
  ├─ ✅ Firebase suite atualizada (Core 4.5.0, Auth 6.2.0, Database 12.1.4, Storage 13.1.0)
  ├─ ✅ Google Maps 2.9.0
  ├─ ✅ Geolocator 14.0.2
  └─ ✅ Correções de APIs deprecadas

2025-2026 (Fase 2: Funcionalidades & UI)
  ├─ ✅ Sistema de upload de fotos (ImageUploadService)
  ├─ ✅ Sistema de documentos CNH/CRLV (DocumentUploadService)
  ├─ ✅ Redesign completo telas de autenticação
  ├─ ✅ Redesign Home/Início (estatísticas, layout moderno)
  ├─ ✅ Perfil completo com foto e documentos
  ├─ ✅ Tela de Ganhos com métricas
  ├─ ✅ Tela de Avaliações com distribuição
  ├─ ✅ Histórico de corridas
  ├─ ✅ Notificações modernizadas
  ├─ ✅ Splash screen animado
  └─ ✅ Validações e avisos

2026 (Estado Atual - Totalmente Funcional)
  ✅ App 100% operacional
  ✅ Design moderno e consistente
  ✅ Todas funcionalidades implementadas
  ✅ Pronto para produção
```

### 📦 Resumo Quantitativo

| Categoria | Quantidade |
|-----------|------------|
| **Dependências Atualizadas** | 15+ packages |
| **Arquivos Android Modificados** | 8 arquivos |
| **APIs Deprecadas Corrigidas** | 5+ APIs |
| **Telas Redesenhadas** | 11 telas |
| **Serviços Criados** | 2 serviços |
| **Novas Funcionalidades** | 8+ features |
| **Linhas de Código Adicionadas** | ~3000+ linhas |

---

## 🗺️ ROADMAP DE MODERNIZAÇÃO

### Visão Geral das Fases

```
FASE 1: AUDITORIA INICIAL (1-2 dias)
├─ Identificar dependências desatualizadas
├─ Listar erros de compilação
├─ Mapear funcionalidades faltantes
└─ Planejar abordagem de migração

FASE 2: ATUALIZAÇÃO DE DEPENDÊNCIAS (1-2 dias)
├─ Atualizar pubspec.yaml
├─ Resolver conflitos de versão
└─ flutter pub get

FASE 3: CONFIGURAÇÃO ANDROID (2-3 dias)
├─ Atualizar Gradle wrapper
├─ Atualizar build.gradle (root)
├─ Atualizar build.gradle (app)
├─ Atualizar Kotlin
├─ Configurar AndroidManifest.xml
└─ Atualizar MainActivity.kt

FASE 4: CORREÇÃO DE CÓDIGO (3-5 dias)
├─ Geolocator → LocationSettings
├─ GoogleMap → getStyleError
├─ Color → withValues
├─ Firebase → currentUser nullability
└─ GoogleMapController lifecycle

FASE 5: CONFIGURAÇÃO FIREBASE (1-2 dias)
├─ Reativar Firebase Database
├─ Configurar Security Rules
├─ Configurar Firebase Storage
├─ Gerar google-services.json atualizado
└─ Configurar Firebase Messaging

FASE 6: SERVIÇOS (2-3 dias)
├─ ImageUploadService (foto de perfil)
└─ DocumentUploadService (CNH, CRLV)

FASE 7: REDESIGN UI/UX (5-7 dias)
├─ Login Screen
├─ Signup Screen
├─ Car Info Screen
├─ Password Recovery
├─ Splash Screen
├─ Home/Início Screen
├─ Profile Screen
├─ Earnings Screen
├─ Ratings Screen
├─ Trip History
└─ Notification Dialog

⏱️ TEMPO TOTAL ESTIMADO: 15-25 dias
```

---

## 📦 FASE 1: AUDITORIA INICIAL

### 1.1 Verificação de Ambiente

```bash
# Verificar versões instaladas
flutter --version
dart --version
java --version

# Limpar cache
flutter clean
flutter pub cache repair

# Verificar problemas
flutter doctor -v
```

### 1.2 Problemas Identificados no Driver App (2023)

#### ❌ Erros de Compilação
```
1. Gradle version incompatible
2. Android Gradle Plugin outdated
3. Kotlin version mismatch
4. compileSdk/targetSdk too old
5. Namespace missing in build.gradle
```

#### ❌ Erros de Código
```
1. Geolocator.getPositionStream() parameters deprecated
2. GoogleMap.onMapCreated() style property deprecated
3. Color.fromARGB() → Color.fromARGB().withOpacity() deprecated
4. FirebaseAuth.currentUser nullable not handled
5. GoogleMapController disposed before async completion
```

#### ❌ Funcionalidades Faltantes
```
1. Profile screen incomplete (no photo upload)
2. Earnings screen empty
3. Ratings screen empty
4. Trip history missing
5. Document upload system missing
6. Splash screen static
7. Home screen poor UX
```

### 1.3 Análise de Dependências Obsoletas

Veja a seção [FASE 2: Atualização de Dependências](#️-fase-2-atualização-de-dependências) para detalhes.

---

## ⚙️ FASE 2: ATUALIZAÇÃO DE DEPENDÊNCIAS

### 2.1 pubspec.yaml Completo Atualizado

```yaml
name: chofair_driver  # ou chofair_user
description: A new Flutter project.
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Core Firebase
  firebase_core: ^4.5.0              # ⬆️ ATUALIZADO (was ^2.x)
  firebase_auth: ^6.2.0              # ⬆️ ATUALIZADO (was ^4.x)
  firebase_database: ^12.1.4         # ⬆️ ATUALIZADO (was ^10.x)
  firebase_storage: ^13.1.0          # ⬆️ ATUALIZADO (was ^11.x)
  firebase_messaging: ^16.1.2        # ⬆️ ATUALIZADO (was ^14.x)
  
  # Maps & Location
  google_maps_flutter: ^2.9.0        # ⬆️ ATUALIZADO (was ^2.5)
  geolocator: ^14.0.2                # ⬆️ ATUALIZADO (was ^10.x)
  flutter_polyline_points: ^3.1.0    # ⬆️ ATUALIZADO
  flutter_geofire: ^2.0.7            # ⬆️ ATUALIZADO
  
  # Image Management (✨ NOVO)
  image_picker: ^1.1.2               # ✨ ADICIONADO
  flutter_image_compress: ^2.3.0     # ✨ ADICIONADO
  cached_network_image: ^3.4.1       # ✨ ADICIONADO
  path_provider: ^2.1.5              # ✨ ADICIONADO
  file_picker: ^8.1.6                # ✨ ADICIONADO (para PDFs)
  
  # Utilities
  http: ^1.2.2                       # ⬆️ ATUALIZADO
  provider: ^6.1.2                   # ⬆️ ATUALIZADO
  fluttertoast: ^9.0.0               # ⬆️ ATUALIZADO
  intl: ^0.20.2                      # ⬆️ ATUALIZADO
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0              # ⬆️ ATUALIZADO

flutter:
  uses-material-design: true
  assets:
    - images/
```

### 2.2 Tabela de Atualizações

| Package | Versão Antiga (2023) | Versão Nova (2026) | Mudanças Críticas |
|---------|----------------------|--------------------|--------------------|
| **firebase_core** | 2.x | 4.5.0 | Initialize syntax |
| **firebase_auth** | 4.x | 6.2.0 | currentUser nullability |
| **firebase_database** | 10.x | 12.1.4 | Query methods |
| **firebase_storage** | 11.x | 13.1.0 | SettableMetadata |
| **google_maps_flutter** | 2.5.x | 2.9.0 | style property deprecated |
| **geolocator** | 10.x | 14.0.2 | LocationSettings required |
| **image_picker** | - | 1.1.2 | ✨ NOVO |
| **flutter_image_compress** | - | 2.3.0 | ✨ NOVO |
| **file_picker** | - | 8.1.6 | ✨ NOVO |

### 2.3 Comandos de Instalação

```bash
# Limpar projeto
flutter clean

# Atualizar dependências
flutter pub get

# Verificar problemas
flutter pub outdated

# Atualizar dependências (se necessário)
flutter pub upgrade --major-versions
```

---

## 🤖 FASE 3: CONFIGURAÇÃO ANDROID

### 3.1 Gradle Wrapper (gradle-wrapper.properties)

**Arquivo:** `android/gradle/wrapper/gradle-wrapper.properties`

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
# ⬆️ ATUALIZADO: 7.5 → 8.12
distributionUrl=https\://services.gradle.org/distributions/gradle-8.12-all.zip
```

### 3.2 Root build.gradle

**Arquivo:** `android/build.gradle`

```gradle
buildscript {
    // ⬆️ ATUALIZADO: 1.7.10 → 2.3.0
    ext.kotlin_version = '2.3.0'
    
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // ⬆️ ATUALIZADO: 7.x → 8.9.1
        classpath 'com.android.tools.build:gradle:8.9.1'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // Firebase Google Services
        classpath 'com.google.gms:google-services:4.4.2'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
```

### 3.3 App build.gradle

**Arquivo:** `android/app/build.gradle`

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    // ✨ NOVO: Namespace obrigatório
    namespace = "com.chofair.driver"  // ou "com.chofair.user"
    
    // ⬆️ ATUALIZADO: 33 → 36
    compileSdk = 36
    ndkVersion = "28.0.12674087"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21
    }

    defaultConfig {
        applicationId = "com.chofair.driver"  // ou "com.chofair.user"
        minSdk = 21
        // ⬆️ ATUALIZADO: 33 → 36
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.debug
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk8:$kotlin_version"
    implementation 'com.google.android.gms:play-services-maps:19.0.0'
    implementation 'com.google.android.gms:play-services-location:21.3.0'
    implementation 'com.android.support:multidex:1.0.3'
}

// ✨ Google Services (Firebase)
apply plugin: 'com.google.gms.google-services'
```

### 3.4 settings.gradle

**Arquivo:** `android/settings.gradle`

```gradle
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.9.1" apply false
    id "org.jetbrains.kotlin.android" version "2.3.0" apply false
}

include ":app"
```

### 3.5 gradle.properties

**Arquivo:** `android/gradle.properties`

```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true
android.defaults.buildfeatures.buildconfig=true
android.nonTransitiveRClass=false
android.nonFinalResIds=false
```

### 3.6 AndroidManifest.xml (Main)

**Arquivo:** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Permissões -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    
    <!-- ✨ NOVO: Permissões Android 13+ para imagens/vídeos -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>

    <application
        android:label="Chofair Driver"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:enableOnBackInvokedCallback="true">
        
        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="SUA_API_KEY_AQUI"/>

        <!-- MainActivity -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"/>
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2"/>
    </application>
    
    <!-- Query para file_picker funcionar no Android 11+ -->
    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW"/>
            <data android:mimeType="*/*"/>
        </intent>
    </queries>
</manifest>
```

### 3.7 AndroidManifest.xml (Debug & Profile)

**Arquivo:** `android/app/src/debug/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

**Arquivo:** `android/app/src/profile/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

### 3.8 MainActivity.kt

**Arquivo:** `android/app/src/main/kotlin/com/chofair/driver/MainActivity.kt`

```kotlin
package com.chofair.driver  // ou com.chofair.user

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
```

---

## 🔧 FASE 4: CORREÇÃO DE CÓDIGO OBSOLETO

### 4.1 Geolocator - LocationSettings

#### ❌ ANTES (Deprecated)
```dart
StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
  desiredAccuracy: LocationAccuracy.high,
  distanceFilter: 10,
).listen((Position position) {
  // código
});
```

#### ✅ DEPOIS (Correto)
```dart
LocationSettings locationSettings = const LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 10,
);

StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
  locationSettings: locationSettings,
).listen((Position position) {
  // código
});
```

### 4.2 GoogleMap - Style Property

#### ❌ ANTES (Deprecated)
```dart
GoogleMap(
  onMapCreated: (GoogleMapController controller) {
    controller.setMapStyle(/* style */);
  },
)
```

#### ✅ DEPOIS (Correto)
```dart
GoogleMap(
  onMapCreated: (GoogleMapController controller) {
    controller.setMapStyle(/* style */).then((_) {
      // Success
    }).catchError((error) {
      print("Error setting map style: $error");
    });
  },
)
```

### 4.3 Color - withOpacity to withValues

#### ❌ ANTES (Deprecated)
```dart
Color color = Colors.black.withOpacity(0.5);
```

#### ✅ DEPOIS (Correto)
```dart
Color color = Colors.black.withValues(alpha: 0.5);
```

### 4.4 Firebase Auth - Nullable currentUser

#### ❌ ANTES (Unsafe)
```dart
String userId = FirebaseAuth.instance.currentUser.uid;  // ❌ Null crash
```

#### ✅ DEPOIS (Safe)
```dart
final User? firebaseUser = FirebaseAuth.instance.currentUser;
if (firebaseUser != null) {
  String userId = firebaseUser.uid;
  // código seguro
}
```

### 4.5 GoogleMapController Lifecycle

#### ❌ ANTES (Problema)
```dart
GoogleMapController? newGoogleMapController;

GoogleMap(
  onMapCreated: (GoogleMapController controller) {
    newGoogleMapController = controller;
    // Usar controller aqui pode causar erro se widget disposed
  },
)
```

#### ✅ DEPOIS (Seguro)
```dart
GoogleMapController? newGoogleMapController;

GoogleMap(
  onMapCreated: (GoogleMapController controller) {
    if (mounted) {
      setState(() {
        newGoogleMapController = controller;
      });
    }
  },
)

@override
void dispose() {
  newGoogleMapController?.dispose();
  super.dispose();
}
```

---

## 🔥 FASE 5: CONFIGURAÇÃO FIREBASE

### 5.1 Firebase Console Setup

1. **Acesse:** https://console.firebase.google.com
2. **Crie projeto** ou selecione existente
3. **Adicione aplicativo Android:**
   - Package name: `com.chofair.user` (para User app)
   - Download `google-services.json`
   - Colocar em: `android/app/google-services.json`

### 5.2 Firebase Database - Reativar e Configurar

#### Reativar Realtime Database
1. Firebase Console → Realtime Database
2. Create Database → Choose location
3. Start in **Test Mode** (inicialmente)

#### Security Rules (Produção)

**⚠️ IMPORTANTE:** Substituir regras de teste por estas:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "drivers": {
      "$uid": {
        ".read": "auth != null",
        ".write": "$uid === auth.uid"
      }
    },
    "allRideRequests": {
      ".read": "auth != null",
      "$requestId": {
        ".write": "auth != null && (!data.exists() || data.child('userId').val() === auth.uid || data.child('driverId').val() === auth.uid)"
      }
    },
    "activeDrivers": {
      ".read": "auth != null",
      "$uid": {
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

### 5.3 Firebase Storage - Configurar

#### Storage Rules

**Arquivo:** Firebase Console → Storage → Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // User profile photos (passageiros)
    match /user_profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024  // Max 5MB
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Driver profile photos (motoristas)
    match /driver_profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Driver documents (CNH & Vehicle)
    match /driver_documents/{type}/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024  // Max 10MB
                   && (request.resource.contentType.matches('image/.*') 
                       || request.resource.contentType == 'application/pdf');
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 5.4 Firebase Messaging (Push Notifications)

**AndroidManifest.xml adicionar:**

```xml
<service
    android:name=".MyFirebaseMessagingService"
    android:exported="false">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT"/>
    </intent-filter>
</service>
```

### 5.5 Google Maps API Key

1. **Google Cloud Console:** https://console.cloud.google.com
2. **APIs & Services** → **Credentials**
3. **Create API Key** → **Restrict key:**
   - Android apps
   - Package name: `com.chofair.user`
   - SHA-1: `keytool -list -v -keystore ~/.android/debug.keystore`
4. **Enable APIs:**
   - Maps SDK for Android
   - Directions API
   - Places API
   - Geocoding API

---

## 🛠️ FASE 6: SERVIÇOS CRIADOS

Durante a modernização do Driver App, foram criados 2 serviços essenciais para gerenciar uploads de imagens e documentos.

### 6.1 ImageUploadService (Upload de Fotos de Perfil)

**Arquivo:** `lib/services/image_upload_service.dart`

#### 📋 Funcionalidades
- ✅ Escolher foto da galeria
- ✅ Tirar foto com câmera
- ✅ Compressão automática de imagens
- ✅ Upload para Firebase Storage
- ✅ Atualização no Firebase Database
- ✅ Deletar foto antiga

#### 🔧 Implementação Completa

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chofair_user/global/global.dart';  // Ajustar path
import 'package:path/path.dart' as path;

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Escolher foto da galeria
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print("Erro ao escolher imagem da galeria: $e");
      return null;
    }
  }

  // Tirar foto com a câmera
  Future<File?> takePhotoWithCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      print("Erro ao tirar foto: $e");
      return null;
    }
  }

  // Comprimir imagem (reduz tamanho para upload mais rápido)
  Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 400,
        minHeight: 400,
      );

      if (result != null) {
        return File(result.path);
      }
      return null;
    } catch (e) {
      print("Erro ao comprimir imagem: $e");
      return file; // Retorna original se falhar
    }
  }

  // Upload para Firebase Storage
  Future<String?> uploadToFirebase(File imageFile, String userId) async {
    try {
      // Comprimir antes de fazer upload
      File? compressedFile = await compressImage(imageFile);
      if (compressedFile == null) {
        compressedFile = imageFile;
      }

      // Criar referência no Storage
      // Para User app: user_profile_photos
      final ref = _storage.ref().child('user_profile_photos/$userId.jpg');
      
      // Fazer upload
      final uploadTask = ref.putFile(compressedFile);
      
      // Aguardar conclusão
      final snapshot = await uploadTask.whenComplete(() {});
      
      // Obter URL de download
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print("Erro ao fazer upload: $e");
      return null;
    }
  }

  // Atualizar foto de perfil no Firebase Database
  Future<bool> updateProfilePhoto(String photoUrl) async {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("users")  // Para User app
          .child(currentFirebaseUser!.uid);
      
      await userRef.update({
        "photoUrl": photoUrl,
        "photoUpdatedAt": DateTime.now().toIso8601String(),
      });
      
      return true;
    } catch (e) {
      print("Erro ao atualizar URL da foto: $e");
      return false;
    }
  }

  // Deletar foto antiga do Storage
  Future<void> deleteOldPhoto(String userId) async {
    try {
      final ref = _storage.ref().child('user_profile_photos/$userId.jpg');
      await ref.delete();
    } catch (e) {
      print("Erro ao deletar foto antiga: $e");
    }
  }

  // 🎯 MÉTODO COMPLETO: Galeria → Compressão → Upload → Database
  Future<String?> uploadProfilePhotoFromGallery() async {
    try {
      // 1. Escolher imagem
      File? imageFile = await pickImageFromGallery();
      if (imageFile == null) return null;

      // 2. Upload
      String? photoUrl = await uploadToFirebase(
        imageFile,
        currentFirebaseUser!.uid,
      );
      
      // 3. Atualizar database
      if (photoUrl != null) {
        await updateProfilePhoto(photoUrl);
      }
      
      return photoUrl;
    } catch (e) {
      print("Erro no processo de upload: $e");
      return null;
    }
  }

  // 🎯 MÉTODO COMPLETO: Câmera → Compressão → Upload → Database
  Future<String?> uploadProfilePhotoFromCamera() async {
    try {
      // 1. Tirar foto
      File? imageFile = await takePhotoWithCamera();
      if (imageFile == null) return null;

      // 2. Upload
      String? photoUrl = await uploadToFirebase(
        imageFile,
        currentFirebaseUser!.uid,
      );
      
      // 3. Atualizar database
      if (photoUrl != null) {
        await updateProfilePhoto(photoUrl);
      }
      
      return photoUrl;
    } catch (e) {
      print("Erro no processo de upload: $e");
      return null;
    }
  }
}
```

#### 📖 Como Usar no User App

```dart
// Na tela de Perfil
import 'package:chofair_user/services/image_upload_service.dart';

class ProfileScreen extends StatefulWidget {
  // ...
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImageUploadService _imageUploadService = ImageUploadService();
  String? profilePhotoUrl;
  bool isUploading = false;

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Tirar Foto'),
              onTap: () {
                Navigator.pop(context);
                _uploadPhotoFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Escolher da Galeria'),
              onTap: () {
                Navigator.pop(context);
                _uploadPhotoFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _uploadPhotoFromCamera() async {
    setState(() {
      isUploading = true;
    });

    String? url = await _imageUploadService.uploadProfilePhotoFromCamera();
    
    if (url != null) {
      setState(() {
        profilePhotoUrl = url;
        isUploading = false;
      });
      // Mostrar sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto atualizada com sucesso!')),
      );
    } else {
      setState(() {
        isUploading = false;
      });
      // Mostrar erro
    }
  }

  void _uploadPhotoFromGallery() async {
    // Mesma lógica que câmera
    setState(() {
      isUploading = true;
    });

    String? url = await _imageUploadService.uploadProfilePhotoFromGallery();
    
    if (url != null) {
      setState(() {
        profilePhotoUrl = url;
        isUploading = false;
      });
    } else {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: _showPhotoOptions,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: isUploading
                ? CircularProgressIndicator()
                : profilePhotoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          profilePhotoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.person, size: 60),
          ),
        ),
      ),
    );
  }
}
```

---

### 6.2 DocumentUploadService (Upload de Documentos)

**Arquivo:** `lib/services/document_upload_service.dart`

#### 📋 Funcionalidades
- ✅ Upload de fotos de documentos (CNH, RG, etc.)
- ✅ Upload de PDFs
- ✅ Suporte para câmera e galeria
- ✅ Compressão de imagens
- ✅ Metadados no Firebase Database
- ✅ Deletar documentos

#### 🔧 Implementação Completa

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chofair_user/global/global.dart';
import 'package:path/path.dart' as path;

class DocumentUploadService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Escolher foto de documento
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print("Erro ao escolher imagem: $e");
      return null;
    }
  }

  // Escolher PDF
  Future<File?> pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print("Erro ao escolher PDF: $e");
      return null;
    }
  }

  // Comprimir imagem de documento
  Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        "doc_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
        minWidth: 800,
        minHeight: 800,
      );

      if (result != null) {
        return File(result.path);
      }
      return null;
    } catch (e) {
      print("Erro ao comprimir: $e");
      return file;
    }
  }

  // Upload documento para Firebase Storage
  Future<String?> uploadDocument(
    File file,
    String userId,
    String documentType,  // "cnh", "rg", "cnh_verso", etc.
    bool isPDF,
  ) async {
    try {
      File fileToUpload = file;
      
      // Comprimir se for imagem
      if (!isPDF) {
        File? compressed = await compressImage(file);
        if (compressed != null) {
          fileToUpload = compressed;
        }
      }

      // Criar nome único para o arquivo
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = isPDF ? 'pdf' : 'jpg';
      String fileName = '${timestamp}_${documentType}.$extension';

      // Path no Storage
      final ref = _storage.ref().child('user_documents/$documentType/$userId/$fileName');
      
      // Metadata
      SettableMetadata metadata = SettableMetadata(
        contentType: isPDF ? 'application/pdf' : 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'documentType': documentType,
        },
      );
      
      // Upload
      final uploadTask = ref.putFile(fileToUpload, metadata);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print("Erro ao fazer upload do documento: $e");
      return null;
    }
  }

  // Salvar informações do documento no Database
  Future<bool> saveDocumentInfo(
    String documentType,
    String downloadUrl,
    bool isPDF,
  ) async {
    try {
      DatabaseReference docRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentFirebaseUser!.uid)
          .child("documents")
          .child(documentType);
      
      await docRef.set({
        "url": downloadUrl,
        "type": isPDF ? "pdf" : "image",
        "uploadedAt": DateTime.now().toIso8601String(),
        "status": "pending_review",  // ou "approved", "rejected"
      });
      
      return true;
    } catch (e) {
      print("Erro ao salvar info do documento: $e");
      return false;
    }
  }

  // Deletar documento
  Future<bool> deleteDocument(String documentType, String fileUrl) async {
    try {
      // Deletar do Storage
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();

      // Deletar do Database
      DatabaseReference docRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentFirebaseUser!.uid)
          .child("documents")
          .child(documentType);
      
      await docRef.remove();
      
      return true;
    } catch (e) {
      print("Erro ao deletar documento: $e");
      return false;
    }
  }

  // Obter informações de documento
  Future<Map<String, dynamic>?> getDocumentInfo(String documentType) async {
    try {
      DatabaseReference docRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentFirebaseUser!.uid)
          .child("documents")
          .child(documentType);
      
      final snapshot = await docRef.once();
      
      if (snapshot.snapshot.value != null) {
        return Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print("Erro ao obter info do documento: $e");
      return null;
    }
  }

  // 🎯 MÉTODO COMPLETO: Galeria → Upload → Database
  Future<String?> uploadDocumentFromGallery(String documentType) async {
    try {
      File? imageFile = await pickImage(ImageSource.gallery);
      if (imageFile == null) return null;

      String? url = await uploadDocument(
        imageFile,
        currentFirebaseUser!.uid,
        documentType,
        false,
      );
      
      if (url != null) {
        await saveDocumentInfo(documentType, url, false);
      }
      
      return url;
    } catch (e) {
      print("Erro no processo: $e");
      return null;
    }
  }

  // 🎯 MÉTODO COMPLETO: Câmera → Upload → Database
  Future<String?> uploadDocumentFromCamera(String documentType) async {
    try {
      File? imageFile = await pickImage(ImageSource.camera);
      if (imageFile == null) return null;

      String? url = await uploadDocument(
        imageFile,
        currentFirebaseUser!.uid,
        documentType,
        false,
      );
      
      if (url != null) {
        await saveDocumentInfo(documentType, url, false);
      }
      
      return url;
    } catch (e) {
      print("Erro no processo: $e");
      return null;
    }
  }

  // 🎯 MÉTODO COMPLETO: PDF → Upload → Database
  Future<String?> uploadDocumentPDF(String documentType) async {
    try {
      File? pdfFile = await pickPDF();
      if (pdfFile == null) return null;

      String? url = await uploadDocument(
        pdfFile,
        currentFirebaseUser!.uid,
        documentType,
        true,
      );
      
      if (url != null) {
        await saveDocumentInfo(documentType, url, true);
      }
      
      return url;
    } catch (e) {
      print("Erro no processo: $e");
      return null;
    }
  }
}
```

#### 📖 Como Usar no User App

```dart
// Exemplo: Tela de documentos do usuário
import 'package:chofair_user/services/document_upload_service.dart';

class DocumentsScreen extends StatefulWidget {
  // ...
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final DocumentUploadService _docService = DocumentUploadService();
  Map<String, dynamic>? rgDocument;
  Map<String, dynamic>? cnhDocument;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  void _loadDocuments() async {
    setState(() {
      isLoading = true;
    });

    rgDocument = await _docService.getDocumentInfo('rg');
    cnhDocument = await _docService.getDocumentInfo('cnh');

    setState(() {
      isLoading = false;
    });
  }

  void _showUploadOptions(String documentType) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Tirar Foto'),
              onTap: () {
                Navigator.pop(context);
                _uploadFromCamera(documentType);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Escolher da Galeria'),
              onTap: () {
                Navigator.pop(context);
                _uploadFromGallery(documentType);
              },
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Selecionar PDF'),
              onTap: () {
                Navigator.pop(context);
                _uploadPDF(documentType);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _uploadFromCamera(String documentType) async {
    setState(() {
      isLoading = true;
    });

    String? url = await _docService.uploadDocumentFromCamera(documentType);
    
    if (url != null) {
      _loadDocuments();  // Recarregar documentos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Documento enviado com sucesso!')),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _uploadFromGallery(String documentType) async {
    // Similar ao _uploadFromCamera
  }

  void _uploadPDF(String documentType) async {
    // Similar ao _uploadFromCamera, usando uploadDocumentPDF
  }

  @override
  Widget build(BuildContext context) {
    // UI dos documentos
    return Scaffold(
      appBar: AppBar(title: Text('Meus Documentos')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildDocumentCard('RG', rgDocument, 'rg'),
                SizedBox(height: 16),
                _buildDocumentCard('CNH', cnhDocument, 'cnh'),
              ],
            ),
    );
  }

  Widget _buildDocumentCard(String title, Map<String, dynamic>? doc, String type) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: doc != null 
            ? Text('Enviado em ${doc['uploadedAt']}')
            : Text('Não enviado'),
        trailing: IconButton(
          icon: Icon(doc != null ? Icons.edit : Icons.add),
          onPressed: () => _showUploadOptions(type),
        ),
      ),
    );
  }
}
```

---

## 🎨 FASE 7: REDESIGN COMPLETO DE UI/UX

Durante a modernização, **TODAS** as telas do Driver App foram redesenhadas para seguir um design system moderno e consistente. Esta seção apresenta código completo de cada tela para você **replicar exatamente** no User App.

### 7.1 Login Screen - Redesign Completo

#### 🎯 Design Characteristics
- Card branco centralizado sobre fundo cinza claro
- Logo circular com sombra
- Campos de texto com ícones
- Botões com bordas arredondadas
- Links de navegação estilizados
- Feedback visual (SnackBars modernos)

#### 📱 Código Completo

**Arquivo:** `lib/authentication/login_screen.dart`

```dart
import 'package:chofair_user/authentication/password_recover.dart';
import 'package:chofair_user/authentication/signup_screen.dart';
import 'package:chofair_user/global/global.dart';
import 'package:chofair_user/splashScreen/splash_screen.dart';
import 'package:chofair_user/widgets/progress_dialog.dart';
import 'package:chofair_user/widgets/snack_bar.dart';
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
    if(!email.text.contains('@')) {
      showRedSnackBar(context, 'Insira um e-mail válido.');
    }
    else if(senha.text.length < 6) {
      showRedSnackBar(context, 'A senha deve ter no mínimo 6 caracteres.');
    }
    else {
      loginUserNow(context);
    }
  }

  loginUserNow(context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: "Processando...");
        },
      );
      
      final UserCredential userCredential = await fAuth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: senha.text.trim(),
      );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
        final userKey = await usersRef.child(firebaseUser.uid).once();
        final snap = userKey.snapshot;

        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          showGreenSnackBar(context, 'Entrada com sucesso.');
          Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      } 
    } catch (e) {
      Navigator.pop(context);
      showRedSnackBar(context, 'E-mail ou senha incorretos.');
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
                        color: Colors.black.withValues(alpha: 0.1),
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
                  "Bem-vindo!",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  "Faça login para continuar",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Card de login
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
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF222222)),
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
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Campo de Senha
                      TextField(
                        controller: senha,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF222222)),
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
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Esqueceu a senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => const PasswordRecover()));
                          },
                          child: Text(
                            "Esqueceu a senha?",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão de Login
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: validateForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222222),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Entrar",
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
                
                // Link para cadastro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não tem uma conta? ",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const SignUpScreen()));
                      },
                      child: const Text(
                        "Cadastre-se",
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 15,
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
```

#### 🎨 Design Tokens Utilizados

| Elemento | Valor |
|----------|-------|
| **Cor Primária** | `#222222` (quase preto) |
| **Fundo** | `Colors.grey[100]` |
| **Card Background** | `Colors.white` |
| **Card Border Radius** | `20px` |
| **Input Border Radius** | `12px` |
| **Button Height** | `56px` |
| **Button Border Radius** | `12px` |
| **Shadow** | `0.05-0.1 opacity, 10-15 blur` |
| **Spacing** | `8, 12, 16, 24, 32` |

---

### 7.2 Signup Screen - Redesign Completo

#### 🎯 Design Characteristics
- Mesmo padrão do Login (consistência)
- 4 campos de entrada (Nome, E-mail, Celular, Senha)
- Todos com ícones contextuais
- Validações inline
- Navegação para tela de informações adicionais

#### 📱 Código Completo

**Arquivo:** `lib/authentication/signup_screen.dart`

```dart
import 'package:chofair_user/authentication/login_screen.dart';
import 'package:chofair_user/global/global.dart';
import 'package:chofair_user/widgets/progress_dialog.dart';
import 'package:chofair_user/widgets/snack_bar.dart';
import 'package:chofair_user/mainScreens/main_screen.dart';  // ou tela de info adicional
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
    else if(celular.text.isEmpty || celular.text.length < 10 || celular.text.length > 15) {
      showRedSnackBar(context, 'Digite um número válido com DDD.');
    }
    else if(senha.text.length < 6) {
      showRedSnackBar(context, 'A senha deve ter no mínimo 6 caracteres.');
    }
    else {
      saveUserInfoNow(context);
    }
  }

  saveUserInfoNow(context) async {
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
        Map userMap = {
          "id": firebaseUser.uid,
          "name": nome.text.trim(),
          "email": email.text.trim(),
          "phone": celular.text.trim(),
        };
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
        await usersRef.child(firebaseUser.uid).set(userMap);

        currentFirebaseUser = firebaseUser;

        showGreenSnackBar(context, 'Conta criada com sucesso.');
        Navigator.push(context, MaterialPageRoute(builder: (c) => const MainScreen()));
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
                        color: Colors.black.withValues(alpha: 0.1),
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
                  "Preencha os dados para começar",
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
                      // Campo de Nome
                      TextField(
                        controller: nome,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Nome Completo",
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF222222)),
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
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Campo de E-mail
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF222222)),
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
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Campo de Celular
                      TextField(
                        controller: celular,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Celular",
                          prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF222222)),
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
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Campo de Senha
                      TextField(
                        controller: senha,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF222222)),
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
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão de Cadastro
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: validateForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222222),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Criar Conta",
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
                
                // Link para login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já tem uma conta? ",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
                      },
                      child: const Text(
                        "Faça login",
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 15,
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
```

---

