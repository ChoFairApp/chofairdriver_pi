import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chofair_driver/global/global.dart';
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

  // Comprimir imagem
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
      final ref = _storage.ref().child('driver_profile_photos/$userId.jpg');
      
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
      DatabaseReference driverRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentFirebaseUser!.uid);
      
      await driverRef.update({
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
      final ref = _storage.ref().child('driver_profile_photos/$userId.jpg');
      await ref.delete();
    } catch (e) {
      print("Erro ao deletar foto antiga: $e");
    }
  }

  // Processo completo: escolher, comprimir e fazer upload
  Future<String?> uploadProfilePhotoFromGallery() async {
    try {
      // Escolher imagem
      File? imageFile = await pickImageFromGallery();
      if (imageFile == null) return null;

      // Upload
      String? photoUrl = await uploadToFirebase(
        imageFile,
        currentFirebaseUser!.uid,
      );
      
      if (photoUrl != null) {
        // Atualizar no database
        await updateProfilePhoto(photoUrl);
      }
      
      return photoUrl;
    } catch (e) {
      print("Erro no processo de upload: $e");
      return null;
    }
  }

  // Processo completo: tirar foto, comprimir e fazer upload
  Future<String?> uploadProfilePhotoFromCamera() async {
    try {
      // Tirar foto
      File? imageFile = await takePhotoWithCamera();
      if (imageFile == null) return null;

      // Upload
      String? photoUrl = await uploadToFirebase(
        imageFile,
        currentFirebaseUser!.uid,
      );
      
      if (photoUrl != null) {
        // Atualizar no database
        await updateProfilePhoto(photoUrl);
      }
      
      return photoUrl;
    } catch (e) {
      print("Erro no processo de upload: $e");
      return null;
    }
  }
}
