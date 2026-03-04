import 'dart:async';
import 'package:chofair_driver/global/global.dart';
import 'package:chofair_driver/push_notifications/push_notification_system.dart';
import 'package:chofair_driver/widgets/snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

GoogleMapController? newGoogleMapController;
final Completer<GoogleMapController> _controllerGoogleMap = Completer();


static const CameraPosition _jau = CameraPosition(
    target: LatLng( -22.2963, -48.5587),
    zoom: 14.4746,
  );

  Position? driverCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  String statusText = "Conectar";
  Color buttonColor = const Color(0xFF222222);
  bool isDriverActive = false;
  
  // Estatísticas do dia
  int todayTrips = 0;
  double todayEarnings = 0.0;
  String lastTripTime = "Nenhuma corrida ainda";
  

  //toogletab
  int selectedIndex = 0;

//clean theme style para o Google Map
static const String _cleanMapStyle = '''
[  {
    "featureType": "administrative",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#d6e2e6"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#cfd4d5"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#7492a8"
      }
    ]
  },
  {
    "featureType": "administrative.neighborhood",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "lightness": 25
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#dde2e3"
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#cfd4d5"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#dde2e3"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#7492a8"
      }
    ]
  },
  {
    "featureType": "landscape.natural.terrain",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#dde2e3"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.icon",
    "stylers": [
      {
        "saturation": -100
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#588ca4"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a9de83"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#bae6a1"
      }
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#c6e8b3"
      }
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#bae6a1"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "saturation": -45
      },
      {
        "lightness": 10
      },
      {
        "visibility": "on"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#41626b"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#c1d1d6"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#a6b5bb"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#9fb6bd"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.icon",
    "stylers": [
      {
        "saturation": -70
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b4cbd4"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#588ca4"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#008cb5"
      }
    ]
  },
  {
    "featureType": "transit.station.airport",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "saturation": -100
      },
      {
        "lightness": -5
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a6cbe3"
      }
    ]
  }
]
''';


  checkIfLocationPermissionAllowed() async {
  _locationPermission = await Geolocator.requestPermission();

  if(_locationPermission == LocationPermission.denied)
  {
    _locationPermission = await Geolocator.requestPermission();
  }
}

locateDriverPosition() async {
  //aqui pega a posicao atual do user
 Position cPosition =  await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );
 driverCurrentPosition = cPosition;

 LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
 CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

 newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
 

  //COM AS LINHAS ABAIXO DÁ ERRO NO PROVIDER, SE TOCAR EM OUTRA PAGINA FECHOU APP?
//   if (mounted) {
//   String humanReadableAddress = await AssistantMethods.searchAddressForGeoCoordinates(driverCurrentPosition!, context);
//   print("Este é o Meu Endereço: " + humanReadableAddress);
// }
  // String humanReadableAddress = await AssistantMethods.searchAddressForGeoCoordinates(driverCurrentPosition!, context);
  //  print("ESTe é o Meu Endereço: " + humanReadableAddress);
}

readCurrentDriverInformation() async {
  currentFirebaseUser = fAuth.currentUser;
  PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
  pushNotificationSystem.initializeCloudMessaging(context); //inicializa CloudMessaging criado em pushnotificationsystem
  pushNotificationSystem.generateAndGetToken();
  
  // Carregar estatísticas do dia
  loadTodayStatistics();
}

void loadTodayStatistics() async {
  if (currentFirebaseUser == null) return;
  
  try {
    // Data de hoje no formato YYYY-MM-DD
    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    
    // Buscar corridas de hoje
    DatabaseReference tripsRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("trips");
    
    DataSnapshot snapshot = await tripsRef.get();
    
    if (snapshot.exists) {
      int trips = 0;
      double earnings = 0.0;
      String lastTime = "Nenhuma corrida ainda";
      
      Map<dynamic, dynamic> tripsData = snapshot.value as Map<dynamic, dynamic>;
      
      tripsData.forEach((key, value) {
        if (value['date'] != null && value['date'].toString().startsWith(todayStr)) {
          trips++;
          if (value['fare'] != null) {
            earnings += double.tryParse(value['fare'].toString()) ?? 0.0;
          }
          if (value['endTime'] != null) {
            lastTime = value['endTime'].toString().split('T')[1].substring(0, 5);
          }
        }
      });
      
      if (mounted) {
        setState(() {
          todayTrips = trips;
          todayEarnings = earnings;
          if (trips > 0) {
            lastTripTime = lastTime;
          }
        });
      }
    }
  } catch (e) {
    print("Erro ao carregar estatísticas: $e");
  }
}

@override
  void initState() {
    super.initState(); 
    checkIfLocationPermissionAllowed(); //permissão para localização method
    readCurrentDriverInformation(); //chama method do CM   
  }

  @override
  void dispose() {
    // Cancela a stream subscription para evitar memory leaks
    streamSubscriptionPosition?.cancel();
    // Dispose do controller do mapa
    newGoogleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header com status
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDriverActive
                      ? [Colors.green, Colors.green.shade700]
                      : [const Color(0xFF222222), const Color(0xFF444444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: isDriverActive ? Colors.white : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isDriverActive ? "Online" : "Offline",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Botão de toggle
                      ElevatedButton(
                        onPressed: () {
                          if (!isDriverActive) {
                            driverIsOnlineNow();
                            updateDriversLocationAtRealtime();

                            setState(() {
                              statusText = "Desconectar";
                              isDriverActive = true;
                              buttonColor = Colors.green;
                            });

                            showGreenSnackBar(context, 'Você se conectou.');
                          } else {
                            driverIsOfflineNow();
                            setState(() {
                              statusText = "Conectar";
                              isDriverActive = false;
                              buttonColor = const Color(0xFF222222);
                            });
                            showRedSnackBar(context, 'Você se desconectou.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: isDriverActive ? Colors.green : const Color(0xFF222222),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDriverActive ? Icons.power_settings_new : Icons.power_settings_new_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statusText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estatísticas do dia
                    const Text(
                      "Hoje",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.route,
                            iconColor: Colors.blue,
                            title: "Corridas",
                            value: todayTrips.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.attach_money,
                            iconColor: Colors.green,
                            title: "Ganhos",
                            value: "R\$ ${todayEarnings.toStringAsFixed(2)}",
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildInfoCard(
                      icon: Icons.access_time,
                      iconColor: Colors.orange,
                      title: "Última corrida",
                      subtitle: lastTripTime,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Mapa compacto
                    const Text(
                      "Sua localização",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            initialCameraPosition: _jau,
                            style: _cleanMapStyle,
                            onMapCreated: (GoogleMapController controller) {
                              if (!_controllerGoogleMap.isCompleted) {
                                _controllerGoogleMap.complete(controller);
                              }
                              newGoogleMapController = controller;
                              locateDriverPosition();
                            },
                          ),
                          if (!isDriverActive)
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Text(
                                    "Conecte-se para começar",
                                    style: TextStyle(
                                      color: Color(0xFF222222),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Dicas
                    if (!isDriverActive)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.blue[700],
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dica",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Conecte-se para começar a receber solicitações de corrida!",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  driverIsOnlineNow() async { //chamado quando driver clica pra ficar online e display todos drivers perto para os user no app users

    //pegar a posição do driver
    Position pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers"); //inicializa geofire e activeDrivers como está na regra criada no firebase
    Geofire.setLocation(currentFirebaseUser!.uid, 
    driverCurrentPosition!.latitude, 
    driverCurrentPosition!.longitude
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref()
    .child("drivers")
    .child(currentFirebaseUser!.uid)
    .child("newRideStatus"); //referenciar driver buscando nova corrida

    ref.set("idle"); //idle está pronto para requests de corrida
    //abaixo se os requests de corride continuam vindo ele está 'ouvindo' para aceitar ou rejeitar request
    ref.onValue.listen((event) { });
  }

  //versão 1 de updateDriversLocationAtRealTime
  // updateDriversLocationAtRealtime() { //atualizar location do driver em realtime
  //   streamSubscriptionPosition = Geolocator.getPositionStream()
  //   .listen((Position position) 
  //   { 
  //     driverCurrentPosition = position;

  //     if(isDriverActive == true) {
  //       Geofire.setLocation(
  //       currentFirebaseUser!.uid,
  //       driverCurrentPosition!.latitude, 
  //       driverCurrentPosition!.longitude
  //   );
  //     }
      
  //     LatLng latLng = LatLng(
  //         driverCurrentPosition!.latitude,
  //         driverCurrentPosition!.longitude,
  //     );

  //     newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));

  //   });
  // }


  //testar updateDriversLocationAtRealtime nova
  void updateDriversLocationAtRealtime() {
  // Assine a transmissão de posições do driver
  streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position) {
    // Atualize a posição atual do motorista
    driverCurrentPosition = position;

    if (isDriverActive) {
      // Se o motorista estiver ativo, atualize a localização no Geofire
      Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );
    }

    // Atualize a posição do mapa
    updateMapPosition();
  });
}

void updateMapPosition() {
  if (driverCurrentPosition != null && newGoogleMapController != null && mounted) {
    LatLng latLng = LatLng(
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    // Anima a câmera para a nova posição
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}



  void driverIsOfflineNow() async {
  // Remove a localização do motorista do "activeDrivers" usando Geofire
  await Geofire.removeLocation(currentFirebaseUser!.uid);

  // Acesse a referência do Firebase
  DatabaseReference driverRef = FirebaseDatabase.instance.ref()
      .child("drivers")
      .child(currentFirebaseUser!.uid);

  // Remova o nó "newRideStatus"
  DatabaseReference newRideStatusRef = driverRef.child("newRideStatus");
  await newRideStatusRef.remove();

  // Remova o motorista do nó "activeDrivers"
  DatabaseReference activeDriversRef = FirebaseDatabase.instance.ref().child("activeDrivers");
  await activeDriversRef.child(currentFirebaseUser!.uid).remove();
}

}





// //teste2 remover CONTINUAR TESTANDO ESSA PORRA! ATE EXCLUIR, VER O VIDEO DO PAKISTANEEZ SAFADO
// driverIsOfflineNow() {
//   Geofire.removeLocation(currentFirebaseUser!.uid);
  
//   DatabaseReference ref = FirebaseDatabase.instance.ref()
//       .child("drivers")
//       .child(currentFirebaseUser!.uid)
//       .child("newRideStatus");

//   // Configurar a ação de desconexão antes de remover os dados
//   ref.onDisconnect().remove();

//   // Remover os dados imediatamente
//   ref.remove();

//   Future.delayed(const Duration(milliseconds: 2000), () {
//     //SystemNavigator.pop();
//     SystemChannels.platform.invokeMethod("SystemNavigator.pop");
//     // Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
//   });
// }


//   //driver offline corrigido, testar se remove do firebase ao desconetar:
//   driverIsOfflineNow() {
//   DatabaseReference ref = FirebaseDatabase.instance.reference()
//       .child("drivers")
//       .child(currentFirebaseUser!.uid);

//   // Use onDisconnect() para definir o que fazer quando o motorista desconectar.
//   ref.onDisconnect().update({"newRideStatus": null});

//   // Esperar um curto período de tempo antes de fechar o aplicativo.
//   Future.delayed(const Duration(milliseconds: 2000), () {
//     // Fecha o aplicativo.
//     SystemNavigator.pop();
//   });
// }



//FUNCIONOU PARA newRideStatus
// void driverIsOfflineNow() async {
//   // Remove a localização do motorista do "activeDrivers" usando Geofire
//   await Geofire.removeLocation(currentFirebaseUser!.uid);

//   // Remove o nó "newRideStatus" do motorista
//   DatabaseReference newRideStatusRef = FirebaseDatabase.instance.ref()
//       .child("drivers")
//       .child(currentFirebaseUser!.uid)
//       .child("newRideStatus");
//   await newRideStatusRef.remove();

//   print("Dados do motorista removidos com sucesso.");
// }

//testar para newridestatus e id do activedrivers





  // driverIsOfflineNow() {
  //   Geofire.removeLocation(currentFirebaseUser!.uid);

  //   DatabaseReference? ref = FirebaseDatabase.instance.ref()
  //       .child("drivers")
  //       .child(currentFirebaseUser!.uid)
  //       .child("newRideStatus"); //referenciar driver buscando nova corrida
  //   ref.remove();
    
  //   ref.onDisconnect();
  //   ref = null;

  //   Future.delayed(const Duration(milliseconds: 2000), () {
  //     // SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  //     // SystemNavigator.pop();

  //     //Recomedado não usar essa linha, e sim fechar app como a de cima
  //     Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen())); 
  //   });
    
  // }