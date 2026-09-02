import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/models/address_model.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng selectedLocation = const LatLng(32.5556, 35.8500);
  GoogleMapController? mapController;
Future<AddressModel> getAddress() async {
  const String apiKey = 'pk.f3f609c01c377d8ba976e59e089fcf19';

  final url = Uri.parse(
    'https://us1.locationiq.com/v1/reverse?key=$apiKey&lat=${selectedLocation.latitude}&lon=${selectedLocation.longitude}&format=json',
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['error'] == null&&data['display_name'] != null) {
        final addressData = data['address'] as Map<String, dynamic>;
        String city = addressData['city'] ??
              addressData['town'] ??
              addressData['village'] ??
              addressData['suburb'] ??
              addressData['county'] ??
              'Unknown Area';
              String country = addressData['country'] ?? '';
              String formattedAddress = country.isNotEmpty ? '$city, $country' : city;
        return AddressModel(
          address: formattedAddress,
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude,
        );
        
      }
    }
  } catch (e) {
    debugPrint("HTTP Geocoding Error: $e");
  }

  return AddressModel(
    address: 'Location not found',
    latitude: selectedLocation.latitude,
    longitude: selectedLocation.longitude,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (position) {
              setState(() {
                selectedLocation = position.target;
              });
            },
            onCameraIdle: () {
              setState(() {});
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),

          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35), 
              child: Icon(
                Icons.location_on,
                size: 45,
                color: Colors.red,
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstantColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                
                ),
              ),
              onPressed: () async {
                AddressModel address;

                try {
                  address = await getAddress();
                } catch (e) {
                  debugPrint("Error fetching address: $e");
                  address = AddressModel(
                    address: 'location(${selectedLocation.latitude.toStringAsFixed(3)}, ${selectedLocation.longitude.toStringAsFixed(3)})',
                    latitude: selectedLocation.latitude,
                    longitude: selectedLocation.longitude,
                  );
                }

                if (!context.mounted) return;
                Navigator.pop(context, address);
              },
              child:  Text(
                "Confirm Location",
                style: ConstantStyle.titeStyle.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}