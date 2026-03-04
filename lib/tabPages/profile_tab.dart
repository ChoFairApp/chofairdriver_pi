import 'package:cached_network_image/cached_network_image.dart';
import 'package:chofair_driver/global/global.dart';
import 'package:chofair_driver/mainScreens/trips_history_screen.dart';
import 'package:chofair_driver/services/image_upload_service.dart';
import 'package:chofair_driver/services/document_upload_service.dart';
import 'package:chofair_driver/splashScreen/splash_screen.dart';
import 'package:chofair_driver/widgets/snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  String driverName = "";
  String driverEmail = "";
  String driverPhone = "";
  String? photoUrl = "";
  String carModel = "";
  String carColor = "";
  String carPlate = "";
  String carYear = "";
  String carService = "";
  bool isUploadingPhoto = false;
  
  // Documentos
  Map<String, dynamic>? cnhDocument;
  Map<String, dynamic>? vehicleDocument;
  bool isLoadingDocuments = false;
  
  final ImageUploadService _imageUploadService = ImageUploadService();
  final DocumentUploadService _documentUploadService = DocumentUploadService();
  
  @override
  void initState() {
    super.initState();
    readDriverInfo();
    loadDocuments();
  }

  void readDriverInfo() async {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);
    
    final snapshot = await driverRef.once();
    
    if (snapshot.snapshot.value != null) {
      final data = snapshot.snapshot.value as Map;
      
      setState(() {
        driverName = data["name"] ?? "";
        driverEmail = data["email"] ?? "";
        driverPhone = data["phone"] ?? "";
        photoUrl = data["photoUrl"] ?? "";
        
        if (data["car_details"] != null) {
          final carData = data["car_details"];
          carModel = "${carData["marca"] ?? ""} ${carData["modelo"] ?? ""}";
          carColor = carData["cor"] ?? "";
          carPlate = carData["placa"] ?? "";
          carYear = carData["year"] ?? "";
          carService = carData["service"] ?? "";
        }
      });
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Escolha uma opção",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.blue),
              ),
              title: const Text("Tirar Foto"),
              subtitle: const Text("Usar câmera"),
              onTap: () async {
                Navigator.pop(context);
                await _uploadPhoto(useCamera: true);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_library, color: Colors.green),
              ),
              title: const Text("Escolher da Galeria"),
              subtitle: const Text("Selecionar foto existente"),
              onTap: () async {
                Navigator.pop(context);
                await _uploadPhoto(useCamera: false);
              },
            ),
            if (photoUrl != null && photoUrl!.isNotEmpty) ...[
              const SizedBox(height: 10),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text("Remover Foto"),
                subtitle: const Text("Excluir foto atual"),
                onTap: () async {
                  Navigator.pop(context);
                  await _removePhoto();
                },
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadPhoto({required bool useCamera}) async {
    setState(() {
      isUploadingPhoto = true;
    });

    try {
      String? newPhotoUrl;
      
      if (useCamera) {
        newPhotoUrl = await _imageUploadService.uploadProfilePhotoFromCamera();
      } else {
        newPhotoUrl = await _imageUploadService.uploadProfilePhotoFromGallery();
      }

      if (newPhotoUrl != null && mounted) {
        setState(() {
          photoUrl = newPhotoUrl;
          isUploadingPhoto = false;
        });
        showGreenSnackBar(context, "Foto atualizada com sucesso!");
      } else if (mounted) {
        setState(() {
          isUploadingPhoto = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isUploadingPhoto = false;
        });
        showRedSnackBar(context, "Erro ao atualizar foto");
      }
    }
  }

  // Carregar documentos do Firebase
  Future<void> loadDocuments() async {
    setState(() {
      isLoadingDocuments = true;
    });

    try {
      final cnh = await _documentUploadService.getDocumentInfo(
        documentType: DocumentType.cnh,
        userId: currentFirebaseUser!.uid,
      );
      
      final vehicle = await _documentUploadService.getDocumentInfo(
        documentType: DocumentType.vehicleDocument,
        userId: currentFirebaseUser!.uid,
      );

      if (mounted) {
        setState(() {
          cnhDocument = cnh;
          vehicleDocument = vehicle;
          isLoadingDocuments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingDocuments = false;
        });
      }
    }
  }

  // Mostrar opções de upload de documento
  void _showDocumentUploadOptions(DocumentType documentType) {
    final String docName = documentType == DocumentType.cnh ? "CNH" : "Documento do Veículo";
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Enviar $docName",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.blue),
              ),
              title: const Text("Tirar Foto"),
              subtitle: const Text("Usar câmera do dispositivo"),
              onTap: () async {
                Navigator.pop(context);
                await _uploadDocument(documentType, fromCamera: true);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_library, color: Colors.green),
              ),
              title: const Text("Escolher da Galeria"),
              subtitle: const Text("Selecionar foto existente"),
              onTap: () async {
                Navigator.pop(context);
                await _uploadDocument(documentType, fromCamera: false);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.picture_as_pdf, color: Colors.orange),
              ),
              title: const Text("Escolher PDF"),
              subtitle: const Text("Selecionar arquivo PDF"),
              onTap: () async {
                Navigator.pop(context);
                await _uploadDocumentPDF(documentType);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Upload de documento (foto)
  Future<void> _uploadDocument(DocumentType documentType, {required bool fromCamera}) async {
    setState(() {
      isLoadingDocuments = true;
    });

    try {
      Map<String, dynamic>? result;
      
      if (fromCamera) {
        result = await _documentUploadService.uploadDocumentFromCamera(
          documentType: documentType,
        );
      } else {
        result = await _documentUploadService.uploadDocumentFromGallery(
          documentType: documentType,
        );
      }

      if (result != null && mounted) {
        await loadDocuments();
        showGreenSnackBar(context, "Documento enviado com sucesso!");
      } else if (mounted) {
        setState(() {
          isLoadingDocuments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingDocuments = false;
        });
        showRedSnackBar(context, "Erro ao enviar documento");
      }
    }
  }

  // Upload de documento (PDF)
  Future<void> _uploadDocumentPDF(DocumentType documentType) async {
    setState(() {
      isLoadingDocuments = true;
    });

    try {
      final result = await _documentUploadService.uploadDocumentPDF(
        documentType: documentType,
      );

      if (result != null && mounted) {
        await loadDocuments();
        showGreenSnackBar(context, "PDF enviado com sucesso!");
      } else if (mounted) {
        setState(() {
          isLoadingDocuments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingDocuments = false;
        });
        showRedSnackBar(context, "Erro ao enviar PDF");
      }
    }
  }

  // Deletar documento
  Future<void> _deleteDocument(DocumentType documentType, String storagePath) async {
    setState(() {
      isLoadingDocuments = true;
    });

    try {
      final success = await _documentUploadService.deleteDocument(
        storagePath: storagePath,
        documentType: documentType,
        userId: currentFirebaseUser!.uid,
      );

      if (success && mounted) {
        await loadDocuments();
        showGreenSnackBar(context, "Documento removido com sucesso!");
      } else if(mounted) {
        setState(() {
          isLoadingDocuments = false;
        });
        showRedSnackBar(context, "Erro ao remover documento");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingDocuments = false;
        });
        showRedSnackBar(context, "Erro ao remover documento");
      }
    }
  }

  Future<void> _removePhoto() async {
    setState(() {
      isUploadingPhoto = true;
    });

    try {
      // Deletar do Storage
      await _imageUploadService.deleteOldPhoto(currentFirebaseUser!.uid);
      
      // Atualizar no Database
      DatabaseReference driverRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentFirebaseUser!.uid);
      
      await driverRef.update({
        "photoUrl": "",
      });

      if (mounted) {
        setState(() {
          photoUrl = "";
          isUploadingPhoto = false;
        });
        showGreenSnackBar(context, "Foto removida com sucesso!");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isUploadingPhoto = false;
        });
        showRedSnackBar(context, "Erro ao remover foto");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header com foto de perfil
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF222222),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    // Avatar com foto
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: isUploadingPhoto
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF222222),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : (photoUrl != null && photoUrl!.isNotEmpty)
                                    ? CachedNetworkImage(
                                        imageUrl: photoUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF222222),
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Color(0xFF222222),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 80,
                                        color: Color(0xFF222222),
                                      ),
                          ),
                        ),
                        // Botão de editar foto
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: isUploadingPhoto ? null : _showPhotoOptions,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Color(0xFF222222),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      driverName.isNotEmpty ? driverName : "Carregando...",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      driverEmail,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Informações Pessoais
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "INFORMAÇÕES PESSOAIS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    _buildInfoCard(
                      icon: Icons.person_outline,
                      title: "Nome Completo",
                      value: driverName,
                    ),
                    const SizedBox(height: 10),
                    
                    _buildInfoCard(
                      icon: Icons.email_outlined,
                      title: "E-mail",
                      value: driverEmail,
                    ),
                    const SizedBox(height: 10),
                    
                    _buildInfoCard(
                      icon: Icons.phone_outlined,
                      title: "Telefone",
                      value: driverPhone,
                    ),
                    
                    const SizedBox(height: 30),

                    // Informações do Veículo
                    const Text(
                      "INFORMAÇÕES DO VEÍCULO",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    _buildInfoCard(
                      icon: Icons.directions_car_outlined,
                      title: "Veículo",
                      value: carModel.isNotEmpty ? carModel : "Não cadastrado",
                    ),
                    const SizedBox(height: 10),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_today_outlined,
                            title: "Ano",
                            value: carYear,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.palette_outlined,
                            title: "Cor",
                            value: carColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.credit_card_outlined,
                            title: "Placa",
                            value: carPlate.toUpperCase(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.category_outlined,
                            title: "Tipo",
                            value: carService,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Seção de Documentos
                    const Text(
                      "DOCUMENTOS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // CNH
                    _buildDocumentCard(
                      title: "CNH (Carteira Nacional de Habilitação)",
                      icon: Icons.badge_outlined,
                      documentInfo: cnhDocument,
                      onUpload: () => _showDocumentUploadOptions(DocumentType.cnh),
                      onDelete: cnhDocument != null
                          ? () => _deleteDocument(DocumentType.cnh, cnhDocument!['storagePath'])
                          : null,
                    ),
                    const SizedBox(height: 10),

                    // Documento do veículo
                    _buildDocumentCard(
                      title: "Documento do Veículo (CRLV)",
                      icon: Icons.description_outlined,
                      documentInfo: vehicleDocument,
                      onUpload: () => _showDocumentUploadOptions(DocumentType.vehicleDocument),
                      onDelete: vehicleDocument != null
                          ? () => _deleteDocument(DocumentType.vehicleDocument, vehicleDocument!['storagePath'])
                          : null,
                    ),

                    const SizedBox(height: 30),

                    // Botão de Histórico
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF222222),
                          side: const BorderSide(color: Color(0xFF222222), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.history, color: Color(0xFF222222)),
                        label: const Text(
                          "HISTÓRICO DE CORRIDAS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const TripsHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Botão de Sair
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF222222),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "SAIR DA CONTA",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _showLogoutDialog();
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required IconData icon,
    required Map<String, dynamic>? documentInfo,
    required VoidCallback onUpload,
    required VoidCallback? onDelete,
  }) {
    final bool hasDocument = documentInfo != null;
    final String fileType = hasDocument ? (documentInfo['fileType'] ?? '') : '';
    final String fileName = hasDocument ? (documentInfo['fileName'] ?? '') : '';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasDocument ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: hasDocument
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: hasDocument ? Colors.green : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: hasDocument ? Colors.green : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasDocument ? "Enviado" : "Pendente",
                          style: TextStyle(
                            fontSize: 12,
                            color: hasDocument ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasDocument) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    fileType == 'pdf' ? Icons.picture_as_pdf : Icons.image,
                    color: fileType == 'pdf' ? Colors.red : Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (!hasDocument)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text(
                      "Enviar",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    onPressed: isLoadingDocuments ? null : onUpload,
                  ),
                )
              else ...[
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF222222),
                      side: const BorderSide(color: Color(0xFF222222)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(
                      "Substituir",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    onPressed: isLoadingDocuments ? null : onUpload,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLoadingDocuments ? null : onDelete,
                  child: const Icon(Icons.delete_outline, size: 20),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF222222).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF222222),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isNotEmpty ? value : "-",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Sair da conta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Você tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF222222),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                fAuth.signOut();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const MySplashScreen()),
                );
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}