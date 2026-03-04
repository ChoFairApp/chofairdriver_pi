import 'package:chofair_driver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripsHistoryScreen extends StatefulWidget {
  const TripsHistoryScreen({super.key});

  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  List<Map<String, dynamic>> tripsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTripsData();
  }

  void loadTripsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DatabaseReference tripsRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentFirebaseUser!.uid)
          .child("trips");

      final snapshot = await tripsRef.once();

      if (snapshot.snapshot.value != null) {
        final tripsData = snapshot.snapshot.value as Map;
        List<Map<String, dynamic>> loadedTrips = [];

        tripsData.forEach((key, value) {
          if (value != null && value is Map) {
            loadedTrips.add({
              "id": key,
              "originAddress": value["originAddress"] ?? "Não informado",
              "destinationAddress": value["destinationAddress"] ?? "Não informado",
              "userName": value["userName"] ?? "Passageiro",
              "userPhone": value["userPhone"] ?? "",
              "fare": double.tryParse(value["fare"]?.toString() ?? "0") ?? 0.0,
              "distance": value["distance"]?.toString() ?? "0",
              "duration": value["duration"]?.toString() ?? "0",
              "completedAt": value["completedAt"] ?? "",
              "status": value["status"] ?? "completed",
              "rating": int.tryParse(value["rating"]?.toString() ?? "0") ?? 0,
            });
          }
        });

        // Ordenar por data (mais recentes primeiro)
        loadedTrips.sort((a, b) {
          try {
            DateTime dateA = DateTime.parse(a["completedAt"]);
            DateTime dateB = DateTime.parse(b["completedAt"]);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });

        setState(() {
          tripsList = loadedTrips;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Histórico de Corridas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF222222)))
          : tripsList.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: const Color(0xFF222222),
                  onRefresh: () async {
                    loadTripsData();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: tripsList.length,
                    itemBuilder: (context, index) {
                      return _buildTripCard(tripsList[index]);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            const Text(
              "Nenhuma corrida realizada",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Suas corridas completas aparecerão aqui",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    String formattedDate = "";
    String formattedTime = "";
    
    try {
      DateTime date = DateTime.parse(trip["completedAt"]);
      formattedDate = DateFormat('dd/MM/yyyy').format(date);
      formattedTime = DateFormat('HH:mm').format(date);
    } catch (e) {
      formattedDate = "Data inválida";
      formattedTime = "";
    }

    Color statusColor = trip["status"] == "completed" 
        ? Colors.green 
        : trip["status"] == "cancelled" 
            ? Colors.red 
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
        children: [
          // Header do card
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222),
                        ),
                      ),
                      if (formattedTime.isNotEmpty)
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  "R\$ ${trip["fare"].toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo do card
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // Passageiro
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF222222),
                      radius: 20,
                      child: Text(
                        trip["userName"][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip["userName"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),
                          if (trip["userPhone"].isNotEmpty)
                            Text(
                              trip["userPhone"],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Avaliação
                    if (trip["rating"] > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trip["rating"].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF222222),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 15),
                const Divider(height: 1),
                const SizedBox(height: 15),

                // Origem
                _buildAddressRow(
                  icon: Icons.my_location,
                  iconColor: Colors.green,
                  address: trip["originAddress"],
                ),

                const SizedBox(height: 10),

                // Destino
                _buildAddressRow(
                  icon: Icons.location_on,
                  iconColor: Colors.red,
                  address: trip["destinationAddress"],
                ),

                const SizedBox(height: 15),
                const Divider(height: 1),
                const SizedBox(height: 15),

                // Informações adicionais
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(
                      Icons.straighten,
                      "${trip["distance"]} km",
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    _buildInfoItem(
                      Icons.access_time,
                      "${trip["duration"]} min",
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    _buildInfoItem(
                      Icons.receipt,
                      "#${trip["id"].substring(0, 6)}",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow({
    required IconData icon,
    required Color iconColor,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            address,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 5),
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
