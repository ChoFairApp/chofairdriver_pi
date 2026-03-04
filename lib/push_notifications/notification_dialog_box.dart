import 'package:chofair_driver/global/global.dart';
import 'package:chofair_driver/models/user_ride_request_information.dart';
import 'package:chofair_driver/widgets/snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationDialogBox extends StatefulWidget {
  final UserRideRequestInformation? userRideRequestDetails;
  
  const NotificationDialogBox({super.key, this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  bool isProcessing = false;

  void acceptRide() async {
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    try {
      // Aceitar a corrida no Firebase
      DatabaseReference tripRef = FirebaseDatabase.instance
          .ref()
          .child("allRideRequests")
          .child(widget.userRideRequestDetails!.rideRequestId!);

      await tripRef.update({
        "status": "accepted",
        "driverId": currentFirebaseUser!.uid,
        "driverName": currentFirebaseUser!.displayName ?? "Motorista",
        "acceptedAt": DateTime.now().toIso8601String(),
      });

      // Salvar corrida nas trips do motorista
      DatabaseReference driverTripRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentFirebaseUser!.uid)
          .child("activeTrip");

      await driverTripRef.set({
        "rideRequestId": widget.userRideRequestDetails!.rideRequestId,
        "originAddress": widget.userRideRequestDetails!.originAddress,
        "destinationAddress": widget.userRideRequestDetails!.destinationAddress,
        "userName": widget.userRideRequestDetails!.userName,
        "userPhone": widget.userRideRequestDetails!.userPhone,
        "status": "going_to_pickup",
        "acceptedAt": DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context);
        showGreenSnackBar(context, "Corrida aceita! Indo buscar passageiro...");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
        showRedSnackBar(context, "Erro ao aceitar corrida. Tente novamente.");
      }
    }
  }

  void declineRide() async {
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    try {
      // Marcar como recusada no Firebase
      DatabaseReference tripRef = FirebaseDatabase.instance
          .ref()
          .child("allRideRequests")
          .child(widget.userRideRequestDetails!.rideRequestId!);

      await tripRef.update({
        "declinedBy/${currentFirebaseUser!.uid}": true,
        "lastDeclinedAt": DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header com ícone
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF222222),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Nova Solicitação de Corrida",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.userRideRequestDetails!.userName ?? "Passageiro",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Origem
                  _buildLocationRow(
                    icon: Icons.my_location,
                    iconColor: Colors.green,
                    label: "Origem",
                    address: widget.userRideRequestDetails!.originAddress!,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Linha conectora
                  Container(
                    margin: const EdgeInsets.only(left: 35),
                    height: 30,
                    width: 2,
                    color: Colors.grey[300],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Destino
                  _buildLocationRow(
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    label: "Destino",
                    address: widget.userRideRequestDetails!.destinationAddress!,
                  ),

                  const SizedBox(height: 20),

                  // Informações adicionais
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoChip(
                          Icons.phone,
                          widget.userRideRequestDetails!.userPhone ?? "N/A",
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        _buildInfoChip(
                          Icons.access_time,
                          "Aguardando",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Botões de ação
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: isProcessing
                          ? const SizedBox.shrink()
                          : const Icon(Icons.close, size: 20),
                      label: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "RECUSAR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                      onPressed: isProcessing ? null : declineRide,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: isProcessing
                          ? const SizedBox.shrink()
                          : const Icon(Icons.check, size: 20),
                      label: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "ACEITAR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                      onPressed: isProcessing ? null : acceptRide,
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

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF222222),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}