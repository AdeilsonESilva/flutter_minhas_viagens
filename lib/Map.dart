import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(-22.932607, -47.073000),
    zoom: 18,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _exibirMarcador(LatLng latLng) async {
    List<Placemark> listaEnderecos =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Placemark endereco = listaEnderecos[0];
      String rua = endereco.thoroughfare;

      Marker marcador = Marker(
        markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
        position: latLng,
        infoWindow: InfoWindow(title: rua),
      );

      setState(() {
        _marcadores.add(marcador);
      });
    }
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _adicionarListenerLocalizacao() {
    StreamSubscription<Position> positionStream =
        getPositionStream(desiredAccuracy: LocationAccuracy.high)
            .listen((Position position) {
      if (position == null) {
        return;
      }

      setState(() {
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
        );
        _movimentarCamera();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa")),
      body: Container(
        child: GoogleMap(
          markers: _marcadores,
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          onLongPress: _exibirMarcador,
        ),
      ),
    );
  }
}
