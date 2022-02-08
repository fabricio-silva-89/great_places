import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/utils/location_util.dart';

import '../models/place.dart';

import '../utils/db_util.dart';

class GreatPlaces with ChangeNotifier {
  final List<Place> _items = [];

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place itemByIndex(int index) => _items[index];

  Future<void> addPlace(String title, File image, LatLng position) async {
    String address = await LocationUtil.getAddressFrom(position);

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      location: PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ),
      image: image,
    );

    _items.add(newPlace);

    DbUtil.insert(
      'places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      },
    );

    notifyListeners();
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');

    _items.clear();

    _items.addAll(
      dataList.map(
        (item) => Place(
          id: item['id'],
          title: item['title'],
          location: PlaceLocation(
            latitude: item['latitude'],
            longitude: item['longitude'],
            address: item['address'],
          ),
          image: File(
            item['image'],
          ),
        ),
      ),
    );

    notifyListeners();
  }
}
