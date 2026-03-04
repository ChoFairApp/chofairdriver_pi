import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chofair_driver/global/global.dart';
import 'package:path/path.dart' as path;

enum DocumentType {
  cnh,
  vehicleDocument,
}

class DocumentUploadService {
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Escolher imagem (foto ou galeria)
  Future<File?> pickImage({required bool fromCamera}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
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

  // Upload do documento para Firebase Storage
  Future<Map<String, dynamic>?> uploadDocument({
    required File file,
    required DocumentType documentType,
    required String userId,
  }) async {
    try {
      final fileName = path.basename(file.path);
      final extension = path.extension(file.path).toLowerCase();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Determinar o caminho baseado no tipo de documento
      String storagePath;
      if (documentType == DocumentType.cnh) {
        storagePath = 'driver_documents/cnh/$userId/${timestamp}_$fileName';
      } else {
        storagePath = 'driver_documents/vehicle/$userId/${timestamp}_$fileName';
      }

      // Criar referência no Storage
      final ref = _storage.ref().child(storagePath);
      
      // Metadata
      final metadata = SettableMetadata(
        contentType: _getContentType(extension),
      );
      
      // Fazer upload
      final uploadTask = ref.putFile(file, metadata);
      
      // Aguardar conclusão
      final snapshot = await uploadTask.whenComplete(() {});
      
      // Obter URL de download
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return {
        'url': downloadUrl,
        'fileName': fileName,
        'fileType': extension.replaceAll('.', ''),
        'uploadedAt': DateTime.now().toIso8601String(),
        'storagePath': storagePath,
      };
    } catch (e) {
      print("Erro ao fazer upload do documento: $e");
      return null;
    }
  }

  // Salvar informações do documento no Firebase Database
  Future<bool> saveDocumentInfo({
    required DocumentType documentType,
    required Map<String, dynamic> documentInfo,
    required String userId,
  }) async {
    try {
      String dbPath;
      if (documentType == DocumentType.cnh) {
        dbPath = "drivers/$userId/documents/cnh";
      } else {
        dbPath = "drivers/$userId/documents/vehicle";
      }

      DatabaseReference ref = FirebaseDatabase.instance.ref().child(dbPath);
      await ref.set(documentInfo);
      
      return true;
    } catch (e) {
      print("Erro ao salvar informações do documento: $e");
      return false;
    }
  }

  // Deletar documento
  Future<bool> deleteDocument({
    required String storagePath,
    required DocumentType documentType,
    required String userId,
  }) async {
    try {
      // Deletar do Storage
      final ref = _storage.ref().child(storagePath);
      await ref.delete();

      // Deletar do Database
      String dbPath;
      if (documentType == DocumentType.cnh) {
        dbPath = "drivers/$userId/documents/cnh";
      } else {
        dbPath = "drivers/$userId/documents/vehicle";
      }
      
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(dbPath);
      await dbRef.remove();
      
      return true;
    } catch (e) {
      print("Erro ao deletar documento: $e");
      return false;
    }
  }

  // Obter informações do documento do Firebase Database
  Future<Map<String, dynamic>?> getDocumentInfo({
    required DocumentType documentType,
    required String userId,
  }) async {
    try {
      String dbPath;
      if (documentType == DocumentType.cnh) {
        dbPath = "drivers/$userId/documents/cnh";
      } else {
        dbPath = "drivers/$userId/documents/vehicle";
      }

      DatabaseReference ref = FirebaseDatabase.instance.ref().child(dbPath);
      DataSnapshot snapshot = await ref.get();
      
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print("Erro ao obter informações do documento: $e");
      return null;
    }
  }

  // Upload completo: escolher imagem da galeria e fazer upload
  Future<Map<String, dynamic>?> uploadDocumentFromGallery({
    required DocumentType documentType,
  }) async {
    final userId = currentFirebaseUser?.uid;
    if (userId == null) {
      print("Usuário não autenticado");
      return null;
    }

    final file = await pickImage(fromCamera: false);
    if (file == null) return null;

    final documentInfo = await uploadDocument(
      file: file,
      documentType: documentType,
      userId: userId,
    );

    if (documentInfo != null) {
      await saveDocumentInfo(
        documentType: documentType,
        documentInfo: documentInfo,
        userId: userId,
      );
    }

    return documentInfo;
  }

  // Upload completo: tirar foto e fazer upload
  Future<Map<String, dynamic>?> uploadDocumentFromCamera({
    required DocumentType documentType,
  }) async {
    final userId = currentFirebaseUser?.uid;
    if (userId == null) {
      print("Usuário não autenticado");
      return null;
    }

    final file = await pickImage(fromCamera: true);
    if (file == null) return null;

    final documentInfo = await uploadDocument(
      file: file,
      documentType: documentType,
      userId: userId,
    );

    if (documentInfo != null) {
      await saveDocumentInfo(
        documentType: documentType,
        documentInfo: documentInfo,
        userId: userId,
      );
    }

    return documentInfo;
  }

  // Upload completo: escolher PDF e fazer upload
  Future<Map<String, dynamic>?> uploadDocumentPDF({
    required DocumentType documentType,
  }) async {
    final userId = currentFirebaseUser?.uid;
    if (userId == null) {
      print("Usuário não autenticado");
      return null;
    }

    final file = await pickPDF();
    if (file == null) return null;

    final documentInfo = await uploadDocument(
      file: file,
      documentType: documentType,
      userId: userId,
    );

    if (documentInfo != null) {
      await saveDocumentInfo(
        documentType: documentType,
        documentInfo: documentInfo,
        userId: userId,
      );
    }

    return documentInfo;
  }

  String _getContentType(String extension) {
    switch (extension) {
      case '.pdf':
        return 'application/pdf';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }
}
