import 'package:chofair_driver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RatingTabPage extends StatefulWidget {
  const RatingTabPage({super.key});

  @override
  State<RatingTabPage> createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> {
  double averageRating = 0.0;
  int totalRatings = 0;
  List<Map<String, dynamic>> ratingsList = [];
  bool isLoading = true;

  int star5Count = 0;
  int star4Count = 0;
  int star3Count = 0;
  int star2Count = 0;
  int star1Count = 0;

  @override
  void initState() {
    super.initState();
    loadRatingsData();
  }

  void loadRatingsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DatabaseReference ratingsRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentFirebaseUser!.uid)
          .child("ratings");

      final snapshot = await ratingsRef.once();

      if (snapshot.snapshot.value != null) {
        final ratingsData = snapshot.snapshot.value as Map;
        
        double totalScore = 0.0;
        int count = 0;
        List<Map<String, dynamic>> loadedRatings = [];

        int star5 = 0, star4 = 0, star3 = 0, star2 = 0, star1 = 0;

        ratingsData.forEach((key, value) {
          if (value != null && value is Map) {
            int rating = int.tryParse(value["stars"]?.toString() ?? "0") ?? 0;
            String comment = value["comment"]?.toString() ?? "";
            String userName = value["userName"]?.toString() ?? "Passageiro";
            String date = value["date"]?.toString() ?? "";

            totalScore += rating;
            count++;

            // Contabilizar estrelas
            switch (rating) {
              case 5:
                star5++;
                break;
              case 4:
                star4++;
                break;
              case 3:
                star3++;
                break;
              case 2:
                star2++;
                break;
              case 1:
                star1++;
                break;
            }

            loadedRatings.add({
              "stars": rating,
              "comment": comment,
              "userName": userName,
              "date": date,
            });
          }
        });

        // Ordenar por data (mais recentes primeiro)
        loadedRatings.sort((a, b) {
          try {
            DateTime dateA = DateTime.parse(a["date"]);
            DateTime dateB = DateTime.parse(b["date"]);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });

        setState(() {
          averageRating = count > 0 ? totalScore / count : 0.0;
          totalRatings = count;
          ratingsList = loadedRatings;
          star5Count = star5;
          star4Count = star4;
          star3Count = star3;
          star2Count = star2;
          star1Count = star1;
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
                loadRatingsData();
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
                          "Avaliações",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Veja o que os passageiros acham de você",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Card de resumo da avaliação
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
                            children: [
                              Text(
                                averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < averageRating.round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 32,
                                  );
                                }),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "$totalRatings avaliações",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Distribuição de estrelas
                        if (totalRatings > 0)
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
                                  "Distribuição",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildStarBar(5, star5Count),
                                const SizedBox(height: 10),
                                _buildStarBar(4, star4Count),
                                const SizedBox(height: 10),
                                _buildStarBar(3, star3Count),
                                const SizedBox(height: 10),
                                _buildStarBar(2, star2Count),
                                const SizedBox(height: 10),
                                _buildStarBar(1, star1Count),
                              ],
                            ),
                          ),

                        const SizedBox(height: 25),

                        // Lista de avaliações
                        if (ratingsList.isNotEmpty) ...[
                          const Text(
                            "Comentários dos Passageiros",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ratingsList.length,
                            itemBuilder: (context, index) {
                              final rating = ratingsList[index];
                              return _buildRatingCard(rating);
                            },
                          ),
                        ],

                        // Mensagem quando não há avaliações
                        if (totalRatings == 0)
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.star_border, size: 60, color: Colors.blue[300]),
                                const SizedBox(height: 15),
                                const Text(
                                  "Você ainda não tem avaliações",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Complete corridas para receber feedback dos passageiros",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
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

  Widget _buildStarBar(int stars, int count) {
    double percentage = totalRatings > 0 ? count / totalRatings : 0;
    
    return Row(
      children: [
        Text(
          "$stars",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(width: 5),
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 30,
          child: Text(
            count.toString(),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingCard(Map<String, dynamic> rating) {
    String formattedDate = "";
    try {
      DateTime date = DateTime.parse(rating["date"]);
      formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      formattedDate = rating["date"];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF222222),
                child: Text(
                  rating["userName"][0].toUpperCase(),
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
                      rating["userName"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating["stars"]
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          if (rating["comment"].isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                rating["comment"],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}