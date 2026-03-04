# Configuração Firebase Storage

## ⚠️ IMPORTANTE - Regras do Firebase Storage

O erro `object-not-found` ocorre porque as regras do Firebase Storage não estão configuradas.

### Passo a Passo:

1. **Acesse o Firebase Console**: https://console.firebase.google.com
2. **Selecione seu projeto** Chofair
3. **No menu lateral, clique em "Storage"**
4. **Clique na aba "Rules" (Regras)**
5. **Substitua as regras existentes por estas**:

```
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    
    // Fotos de perfil dos motoristas
    match /driver_profile_photos/{userId}.jpg {
      allow read: if true; // Qualquer um pode ver fotos de perfil
      allow write: if request.auth != null 
                   && request.auth.uid == userId 
                   && request.resource.size < 5 * 1024 * 1024; // Máximo 5MB
    }
    
    // Documentos CNH dos motoristas
    match /driver_documents/cnh/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null 
                   && request.auth.uid == userId 
                   && request.resource.size < 10 * 1024 * 1024; // Máximo 10MB
    }
    
    // Documentos do veículo
    match /driver_documents/vehicle/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null 
                   && request.auth.uid == userId 
                   && request.resource.size < 10 * 1024 * 1024; // Máximo 10MB
    }
    
    // Negar acesso a todos os outros caminhos
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

6. **Clique em "Publish" (Publicar)**

## ✅ O que essas regras fazem:

- ✅ Permite que motoristas façam upload de suas próprias fotos de perfil
- ✅ Limita o tamanho das fotos a 5MB
- ✅ Permite upload de CNH e documentos do veículo (até 10MB)
- ✅ Qualquer pessoa pode VER fotos de perfil (para passageiros)
- ✅ Apenas o próprio motorista pode VER/EDITAR seus documentos
- ✅ Bloqueia todos os outros acessos não autorizados

## 🔒 Segurança:

- Apenas usuários autenticados podem fazer upload
- Usuários só podem fazer upload em suas próprias pastas
- Limite de tamanho previne abusos
- Documentos privados só visíveis ao proprietário

## 📱 Depois de configurar:

1. Feche e reabra o app
2. Faça login novamente
3. Tente fazer upload da foto de perfil
4. Deve funcionar perfeitamente! ✨
