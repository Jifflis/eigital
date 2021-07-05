import 'package:eigital_exam/cubit/map_cubit.dart';
import 'package:eigital_exam/cubit/map_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen(this.user);

  final User? user;

  @override
  Widget build(BuildContext context) {
    final MapCubit cubit = BlocProvider.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Welcome ${user?.displayName}!',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        body: BlocConsumer<MapCubit, MapState>(
          listener: (BuildContext context, MapState state) {},
          builder: (BuildContext context, MapState state) {
            return Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: cubit.defaultPosition,
                  onMapCreated: (GoogleMapController controller) {
                    cubit.controller.complete(controller);
                  },
                  markers: cubit.markers,
                  polylines: Set<Polyline>.of(cubit.polylines.values),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                _buildButons(cubit),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build the floating buttons
  ///
  Widget _buildButons(MapCubit cubit) {
    return BlocConsumer<MapCubit, MapState>(
      listener: (BuildContext context, MapState state) {},
      builder: (BuildContext context, MapState state) {
        if (state is MapLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                if (state.showNavigateButton) _buildNavigateButton(cubit),
                const SizedBox(height: 8),
                _buildRandomButton(cubit),
                const SizedBox(height: 8),
              ]),
            ),
          );
        }
        return Container();
      },
    );
  }

  /// Build random button
  ///
  TextButton _buildRandomButton(MapCubit cubit) {
    return TextButton(
      onPressed: () {
        cubit.generateRandomLocation();
      },
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(const Size.fromWidth(170)),
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: const Text(
        'Random Location',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  /// Build navigate button
  ///
  TextButton _buildNavigateButton(MapCubit cubit) {
    return TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(170)),
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () {
        cubit.createPolylines();
      },
      child: const Text(
        'Navigate',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
