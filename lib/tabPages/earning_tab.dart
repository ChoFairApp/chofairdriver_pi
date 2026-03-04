import 'package:chofair_driver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EarningTabPage extends StatefulWidget {
  const EarningTabPage({super.key});

  @override
  State<EarningTabPage> createState() => _EarningTabPageState();
}

class _EarningTabPageState extends State<EarningTabPage> {
  double totalEarnings = 0.0;
  int totalTrips = 0;
  double todayEarnings = 0.0;
  int todayTrips = 0;
  double weekEarnings = 0.0;
  int weekTrips = 0;
  double monthEarnings = 0.0;
  int monthTrips = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEarningsData();
  }

  void loadEarningsData() async {
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
        
        double allEarnings = 0.0;
        int allTrips = 0;
        double dayEarnings = 0.0;
        int dayTrips = 0;
        double wkEarnings = 0.0;
        int wkTrips = 0;
        double mnthEarnings = 0.0;
        int mnthTrips = 0;

        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime weekStart = today.subtract(Duration(days: today.weekday - 1));
        DateTime monthStart = DateTime(now.year, now.month, 1);

        tripsData.forEach((key, value) {
          if (value != null && value is Map) {
            double fare = double.tryParse(value["fare"]?.toString() ?? "0") ?? 0.0;
            String? dateStr = value["completedAt"];
            
            allEarnings += fare;
            allTrips++;

            if (dateStr != null) {
              try {
                DateTime tripDate = DateTime.parse(dateStr);
                DateTime tripDay = DateTime(tripDate.year, tripDate.month, tripDate.day);
                
                if (tripDay.isAtSameMomentAs(today)) {
                  dayEarnings += fare;
                  dayTrips++;
                }
                
                if (tripDay.isAfter(weekStart.subtract(const Duration(days: 1)))) {
                  wkEarnings += fare;
                  wkTrips++;
                }
                
                if (tripDay.isAfter(monthStart.subtract(const Duration(days: 1)))) {
                  mnthEarnings += fare;
                  mnthTrips++;
                }
              } catch (e) {
                // Data inválida, ignora
              }
            }
          }
        });

        setState(() {
          totalEarnings = allEarnings;
          totalTrips = allTrips;
          todayEarnings = dayEarnings;
          todayTrips = dayTrips;
          weekEarnings = wkEarnings;
          weekTrips = wkTrips;
          monthEarnings = mnthEarnings;
          monthTrips = mnthTrips;
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF222222)))
          : RefreshIndicator(
              color: const Color(0xFF222222),
              onRefresh: () async {
                loadEarningsData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Meus Ganhos",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Acompanhe seus rendimentos",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Card principal - Total
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF222222), Color(0xFF444444)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
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
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.trending_up,
                                    color: Colors.greenAccent,
                                    size: 28,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Ganhos Totais",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "R\$ ${totalEarnings.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "$totalTrips corridas realizadas",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Cards de períodos
                        _buildPeriodCard(
                          title: "Hoje",
                          earnings: todayEarnings,
                          trips: todayTrips,
                          icon: Icons.today,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 15),

                        _buildPeriodCard(
                          title: "Esta Semana",
                          earnings: weekEarnings,
                          trips: weekTrips,
                          icon: Icons.calendar_view_week,
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 15),

                        _buildPeriodCard(
                          title: "Este Mês",
                          earnings: monthEarnings,
                          trips: monthTrips,
                          icon: Icons.calendar_month,
                          color: Colors.orange,
                        ),

                        const SizedBox(height: 25),

                        // Estatísticas adicionais
                        Container(
                          padding: const EdgeInsets.all(20),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Estatísticas",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF222222),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildStatRow(
                                "Média por corrida",
                                totalTrips > 0
                                    ? "R\$ ${(totalEarnings / totalTrips).toStringAsFixed(2)}"
                                    : "R\$ 0,00",
                                Icons.attach_money,
                              ),
                              const Divider(height: 30),
                              _buildStatRow(
                                "Melhor dia",
                                todayEarnings > 0
                                    ? "Hoje - R\$ ${todayEarnings.toStringAsFixed(2)}"
                                    : "Sem dados",
                                Icons.star,
                              ),
                              const Divider(height: 30),
                              _buildStatRow(
                                "Total de corridas",
                                totalTrips.toString(),
                                Icons.directions_car,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        
                        // Mensagem de incentivo
                        if (totalTrips == 0)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Colors.amber, size: 30),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    "Você ainda não completou nenhuma corrida. Fique online para receber solicitações!",
                                    style: TextStyle(
                                      color: Colors.amber[900],
                                      fontSize: 14,
                                    ),
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
            ),
    );
  }

  Widget _buildPeriodCard({
    required String title,
    required double earnings,
    required int trips,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
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
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "R\$ ${earnings.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trips.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                trips == 1 ? "corrida" : "corridas",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF222222), size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF222222),
          ),
        ),
      ],
    );
  }
}