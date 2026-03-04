import 'package:chofair_driver/global/global.dart';
import 'package:chofair_driver/splashScreen/splash_screen.dart';
import 'package:chofair_driver/widgets/snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});


  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {

TextEditingController marcaCarro = TextEditingController();
TextEditingController modeloCarro = TextEditingController();
TextEditingController corCarro = TextEditingController();
TextEditingController placaCarro = TextEditingController();
TextEditingController renavamCarro = TextEditingController();

List<String> anoCarroList = ['2008', '2009', '2010', '2011', '2012', '2013', '2014',
                              '2015', '2016', '2017', '2018', '2019', '2020', '2021',
                              '2022', '2023', '2024'];
String? selectedAnoCarro; 


List<String> serviceType = ['Carro', 'Moto']; 
String? selectedChofairService; 


validateForm() {
    
    if(marcaCarro.text.isEmpty) {
      showRedSnackBar(context, 'Digite a marca do veículo.');
    }
    else if(modeloCarro.text.isEmpty) {
      showRedSnackBar(context, 'Digite o modelo do veículo.');
    }
    else if(corCarro.text.isEmpty) {
      showRedSnackBar(context, 'Digite a cor do veículo.');

    }
    else if(placaCarro.text.isEmpty || placaCarro.text.length != 7) {
      showRedSnackBar(context, 'Digite a placa do veículo corretamente.');
    }
    else if(renavamCarro.text.isEmpty || renavamCarro.text.length != 9 && renavamCarro.text.length  != 11) {
      showRedSnackBar(context, 'Digite o RENAVAM corretamente.');
    }
    else {
      saveCarInfo();
    }
  }

saveCarInfo() {
    Map driverCarInfoMap = { //map cria e adiciona os campos lá no firebase
      "service": selectedChofairService,
      "year": selectedAnoCarro,
      "marca": marcaCarro.text.trim(),
      "modelo": modeloCarro.text.trim(),
      "cor": corCarro.text.trim(),
      "placa": placaCarro.text.trim(),
      "renavam": renavamCarro.text.trim(),
    };
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);
      showGreenSnackBar(context, 'Veículo salvo com sucesso.');
      Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));

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
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "images/chofairlogo.png",
                    height: 80,
                    width: 80,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Título
                const Text(
                  "Cadastro de Veículo",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  "Insira as informações do seu veículo",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                // Aviso importante
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange[700],
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Atenção",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Preencha com cuidado! Por segurança, estes dados não poderão ser alterados posteriormente.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Card de registro
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipo de veículo
                      Text(
                        "Tipo de Veículo",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            hint: const Text(
                              'Selecione o tipo',
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: selectedChofairService,
                            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF222222)),
                            isExpanded: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedChofairService = newValue;
                              });
                            },
                            items: serviceType.map((tipo) {
                              return DropdownMenuItem(
                                value: tipo,
                                child: Row(
                                  children: [
                                    Icon(
                                      tipo == 'Carro' ? Icons.directions_car : Icons.two_wheeler,
                                      color: Color(0xFF222222),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      tipo,
                                      style: const TextStyle(color: Color(0xFF222222)),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Ano de fabricação
                      Text(
                        "Ano de Fabricação",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            hint: const Text(
                              'Selecione o ano',
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: selectedAnoCarro,
                            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF222222)),
                            isExpanded: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedAnoCarro = newValue;
                              });
                            },
                            items: anoCarroList.map((ano) {
                              return DropdownMenuItem(
                                value: ano,
                                child: Text(
                                  ano,
                                  style: const TextStyle(color: Color(0xFF222222)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Marca field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: marcaCarro,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Marca",
                          prefixIcon: const Icon(Icons.branding_watermark_outlined, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Modelo field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: modeloCarro,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Modelo",
                          prefixIcon: const Icon(Icons.car_rental_outlined, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Cor field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: corCarro,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Cor",
                          prefixIcon: const Icon(Icons.palette_outlined, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Placa field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: placaCarro,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: "Placa",
                          prefixIcon: const Icon(Icons.pin_outlined, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // RENAVAM field
                      TextFormField(
                        style: const TextStyle(color: Color(0xFF222222)),
                        controller: renavamCarro,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "RENAVAM",
                          prefixIcon: const Icon(Icons.bookmark_outline, color: Color(0xFF222222)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF222222), width: 2),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão registrar
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedChofairService == null) {
                              showRedSnackBar(context, 'Escolha o tipo de veículo.');
                            } else if (selectedAnoCarro == null) {
                              showRedSnackBar(context, 'Escolha o ano de fabricação do veículo.');
                            } else {
                              validateForm();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222222),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "REGISTRAR VEÍCULO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
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
    );
  }
}