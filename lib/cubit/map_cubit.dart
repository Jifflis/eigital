import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:eigital_exam/cubit/map_state.dart';
import 'package:eigital_exam/util/location_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oktoast/oktoast.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import '../environment.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapLoaded()) {
    initializeCurrentLocation();
  }
  final Completer<GoogleMapController> controller = Completer();
  final CameraPosition defaultPosition = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14.4746,
  );

  final Set<Marker> markers = <Marker>{};
  final double meterRadius = 10000;
  LatLng randomLocation = const LatLng(0.0, 0.0);
  LatLng currentLocation = const LatLng(0.0, 0.0);

  // Object for PolylinePoints
  late PolylinePoints polylinePoints;
  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];
  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  /// Initialize current location in map
  ///
  Future<void> initializeCurrentLocation() async {
    await setCurrentLocation();
    animateLocation(currentLocation);
  }

  /// Set current location
  ///
  Future<void> setCurrentLocation() async {
    try {
      final LocationData locationData =
          await LocationManager().getCurrentLocation();

      currentLocation =
          LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
    } catch (e) {
      showToast(e.toString());
    }
  }

  /// Generate and navigate to a random location
  ///
  Future<void> generateRandomLocation() async {
    try {
      resetPolyLines();
      await setCurrentLocation();
      randomLocation = getRandomLocation(meterRadius, currentLocation);

      addMarker(randomLocation);
      animateLocation(randomLocation);
      emit(MapLoaded(showNavigateButton: true));
    } catch (e) {
      showToast(e.toString());
    }
  }

  /// Animate camera to location
  ///
  Future<void> animateLocation(LatLng location,{double zoom=15}) async {
    final CameraPosition _kLake =
        CameraPosition(target: location, zoom: zoom);

    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  /// Reset polylines
  ///
  void resetPolyLines() {
    polylineCoordinates = [];
    polylines = {};
  }


  /// Create poly lines for navigation
  ///
  Future<void> createPolylines() async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Env.googleMapApi, // Google Maps API Key
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(randomLocation.latitude, randomLocation.longitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      showToast('No route found!');
    }

    // Defining an ID
    const PolylineId id = PolylineId('poly');

    // Initializing Polyline
    final Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;

    emit(MapLoaded(showNavigateButton: true));
    animateLocation(randomLocation,zoom: 13);
  }

  /// Add a maker
  ///
  void addMarker(LatLng latLng) {
    markers.add(
      Marker(
        markerId: const MarkerId('random'),
        position: latLng,
      ),
    );
  }

  /// Generate and return a random location inside [meterRadius]
  /// base in the [currentLocation]
  ///
  LatLng getRandomLocation(double radiusInMeters, LatLng currentLocation) {
    final double x0 = currentLocation.longitude;
    final double y0 = currentLocation.latitude;

    final Random random = Random();

    // Convert radius from meters to degrees.
    final double radiusInDegrees = radiusInMeters / 111320;

    // Get a random distance and a random angle.
    final double u = random.nextDouble();
    final double v = random.nextDouble();
    final double w = radiusInDegrees * sqrt(u);
    final double t = 2 * pi * v;
    // Get the x and y delta values.
    final double x = w * cos(t);
    final double y = w * sin(t);

    // Compensate the x value.
    final double newX = x / cos(radians(y0));

    double foundLatitude;
    double foundLongitude;

    foundLatitude = y0 + y;
    foundLongitude = x0 + newX;

    return LatLng(foundLatitude, foundLongitude);
  }
}
