# Chofair Driver App

Este repositório contém a versão do Chofair Driver App (motorista), atualizada para funcionar com as versões recentes do Flutter, Firebase e Android build tools.

## Visão Geral

- Projeto: Chofair Driver (aplicativo para motoristas)
- Objetivo: Modernizar dependências, corrigir APIs deprecadas, implementar upload de fotos e documentos, redesenhar UI/UX e preparar para produção.
- Funções principais implementadas:
	- Autenticação (login/signup/password recovery)
	- Upload de foto de perfil (galeria/câmera) com compressão
	- Upload de documentos (CNH / CRLV) — foto e PDF
	- Home com estatísticas (corridas, ganhos) e mapa compacto
	- Perfil com seção de documentos
	- Earnings, Ratings, Trip History
	- Notificações por push
	- Guia de modernização completo e design system (documentação no repo)

---

## Versões e ferramentas usadas (recomendado)

- Flutter SDK: 3.41.0
- Dart SDK: 3.11.0
- Android Gradle Plugin (AGP): 8.9.1
- Gradle: 8.12
- Kotlin: 2.3.0
- Android compileSdk / targetSdk: 36
- Google Maps SDK: google_maps_flutter ^2.9.0
- Geolocator: ^14.0.2
- Firebase packages (principais):
	- firebase_core: ^4.5.0
	- firebase_auth: ^6.2.0
	- firebase_database: ^12.1.4
	- firebase_storage: ^13.1.0
	- firebase_messaging: ^16.1.2
- Outras bibliotecas notáveis:
	- image_picker, flutter_image_compress, cached_network_image, file_picker

> Android Studio: utilize o canal estável mais recente que suporte AGP 8.9.1 (versão estável de 2024–2026). Se não souber qual usar, confirme em `Help → About` e garanta compatibilidade com AGP 8.9.1/Gradle 8.12.

---

## Pré-requisitos (ambiente de desenvolvimento)

- Flutter 3.41.0 instalado e disponível no PATH
- Android SDK com `platforms;android-36` instalado
- Java JDK compatível (recomendado JDK 17+)
- Android Studio (stable) com SDK Tools atualizados
- AVD ou aparelho físico conectado
- Conta Firebase com projeto criado (para Auth, Realtime Database, Storage, Messaging)
- (Opcional) Conta Cloudinary se for usar a alternativa de storage

---

## Configurações obrigatórias antes de rodar

1. Clonar o repositório localmente (se ainda não estiver):

```bash
git clone https://github.com/thiagofjau/chofairdriver_pi.git
cd chofairDriverApp-main
```

2. Instalar dependências:

```bash
flutter pub get
```

3. Firebase: baixar `google-services.json` (Android) e colocá-lo em `android/app/google-services.json`.
	 - Para iOS: baixar `GoogleService-Info.plist` e colocá-lo em `ios/Runner/`.
	 - OBS: Esses arquivos **NÃO** estão no repo por segurança.

4. Google Maps: definir API key no `AndroidManifest.xml` (meta-data `com.google.android.geo.API_KEY`).

5. (Opcional) Se usar Cloudinary, configurar `cloudinary_public` e colocar `CLOUD_NAME` e `UPLOAD_PRESET` no serviço correspondente.

6. Verificar arquivos de build e propriedades do Gradle:
	 - `android/gradle/wrapper/gradle-wrapper.properties` deve apontar para `gradle-8.12`.
	 - `android/build.gradle` deve ter `classpath 'com.android.tools.build:gradle:8.9.1'`.

---

## Como rodar em desenvolvimento (Android)

1. Conectar dispositivo físico ou iniciar um AVD.
2. Executar:

```bash
flutter clean
flutter pub get
flutter run
```

Para compilar um APK release:

```bash
flutter build apk --release
```

---

## Configuração Firebase (detalhes resumidos)

- Realtime Database: regras mínimas para desenvolvimento estão no guia; antes de publicar, use regras de produção.
- Storage: regras foram propostas para proteger uploads de imagens e documentos.
- Messaging: configurar `MyFirebaseMessagingService` (se for utilizar push).

Veja em `FIREBASE_STORAGE_SETUP.md` e nos guias: `GUIA_MODERNIZACAO_CHOFAIR_USER_COMPLETO.md` e `GUIA_PARTE2_DESIGN_SYSTEM.md` para instruções completas.

---

## Estrutura do repositório (pontos-chave)

- `lib/` — código fonte Flutter
	- `authentication/` — login, signup, car_info, password recover
	- `mainScreens/` — main screen, trips_history, etc.
	- `tabPages/` — home_tab.dart, profile_tab.dart, earning_tab.dart, ratings_tab.dart
	- `services/` — `image_upload_service.dart`, `document_upload_service.dart` (serviços principais)
	- `widgets/` — `progress_dialog.dart`, `snack_bar.dart`, componentes reutilizáveis
	- `splashScreen/` — splash screen animado
- `android/`, `ios/`, `windows/`, `linux/`, `macos/` — plataformas específicas
- `GUIA_MODERNIZACAO_CHOFAIR_USER_COMPLETO.md` — guia detalhado de modernização
- `GUIA_PARTE2_DESIGN_SYSTEM.md` — design system e exemplos de tela
- `FIREBASE_STORAGE_SETUP.md` — regras e instruções do Storage

---

## Notas de segurança

- Nunca commite `google-services.json`, `GoogleService-Info.plist`, chaves de assinatura (`.jks`) ou tokens.
- Arquivos de ambiente (ex: `.env`) devem ser mantidos fora do controle de versão.
- As regras do Firebase fornecidas são um ponto de partida; revise antes de produção.

---

## Como contribuir / desenvolver localmente

1. Crie uma branch para sua feature:

```bash
git checkout -b feat/minha-feature
```

2. Faça alterações, adicione e commit:

```bash
git add .
git commit -m "feat: descrição curta"
```

3. Push e abra um Pull Request no GitHub:

```bash
git push origin feat/minha-feature
```

---

## Troubleshooting rápido

- Erro de compilação Gradle: rode `flutter clean`, verifique `gradle-wrapper.properties` e reexecute.
- Erro Firebase Storage `object-not-found`: verifique `google-services.json` e Storage Rules.
- Google Maps em branco: confirme a API key e habilite as APIs no Google Cloud Console.
- Problemas de permissão Android 13+: verifique `READ_MEDIA_IMAGES` e permissões runtime.

---

## Contato

- Maintainer: Thiago (thiagofjau)
- Repo remoto: https://github.com/thiagofjau/chofairdriver_pi.git

---

