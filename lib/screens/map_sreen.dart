import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  final bool isReadOnly;

  const MapScreen({
    Key? key,
    required this.location,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _initalLocation = const LatLng(37.419857, -122.078827);
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione...'),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              onPressed: _pickedPosition == null
                  ? () {}
                  : () {
                      Navigator.of(context).pop(_pickedPosition);
                    },
              icon: const Icon(Icons.check),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.location.latitude == 0.0 &&
                  widget.location.longitude == 0.0
              ? _initalLocation
              : LatLng(
                  widget.location.latitude,
                  widget.location.longitude,
                ),
          zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: (_pickedPosition == null && !widget.isReadOnly)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position: _pickedPosition ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
