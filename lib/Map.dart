import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _exibirMarcador(LatLng latLng) {
    Marker marcador = Marker(
      markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
      position: latLng,
      infoWindow: InfoWindow(title: "Marcador"),
    );

    setState(() {
      _marcadores.add(marcador);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa")),
      body: Container(
        child: GoogleMap(
          markers: _marcadores,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(-22.932607, -47.073000),
            zoom: 18,
          ),
          onMapCreated: _onMapCreated,
          onLongPress: _exibirMarcador,
        ),
      ),
    );
  }
}
