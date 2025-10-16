import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddActivityMap extends StatefulWidget {
  final void Function(LatLng location, String address) onLocationSelected;

  const AddActivityMap({required this.onLocationSelected, Key? key})
    : super(key: key);

  @override
  State<AddActivityMap> createState() => _AddActivityMapState();
}

class _AddActivityMapState extends State<AddActivityMap> {
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _debounce; // Timer für Debouncing
  Map<String, dynamic> _selectedAddress = {}; // Für die Adresse

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Debouncing: Warte 1 Sekunde, bevor die API-Anfrage gesendet wird
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _searchAddress(query);
    });
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      final url =
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5';
      final headers = {
        'User-Agent': 'YourAppName/1.0 (your.email@example.com)',
      };
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _searchResults = data.cast<Map<String, dynamic>>();
        });
      } else if (response.statusCode == 403) {
        // Zeige Debugging-Dialog nur bei Blockierung (403)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Blocked by API'),
              content: Text(
                'You have been blocked by the API. Please ensure you are adhering to the usage policy.\n\n'
                'Response Status: ${response.statusCode}\nResponse Body: ${response.body}',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        // Andere Fehler behandeln
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      // Allgemeine Fehlerbehandlung
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Barlow'),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'S E L E C T  L O C A T I O N',
            style: TextStyle(
              color: Color(0xFF81B29A),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF3D405B),
          iconTheme: const IconThemeData(color: Color(0xFF81B29A)),
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: LatLng(48.1351, 11.5820), // Beispiel: München
                zoom: 12,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        builder:
                            (ctx) => const Icon(
                              Icons.location_pin,
                              color: Color(0xFFE07A5F),
                              size: 40,
                            ),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for an address...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF3D405B),
                      ), // Textfarbe
                      filled: true,
                      fillColor: const Color(0xFFF4F1DE), // Hintergrundfarbe
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF3D405B),
                          width: 2,
                        ), // Umrandung
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF3D405B),
                          width: 2,
                        ), // Umrandung für nicht fokussiert
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF3D405B),
                          width: 2,
                        ), // Umrandung für fokussiert
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF3D405B),
                        ), // Farbe der Lupe
                        onPressed: () => _searchAddress(_searchController.text),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF3D405B),
                    ), // Textfarbe
                    onChanged: _onSearchChanged,
                  ),
                  if (_searchResults.isNotEmpty)
                    Container(
                      constraints: BoxConstraints(maxHeight: 200),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F1DE), // Hintergrundfarbe
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return ListTile(
                            title: Text(
                              result['display_name'],
                              style: const TextStyle(
                                color: Color(0xFF3D405B), // Schriftfarbe
                                fontFamily: 'Barlow', // Schriftart
                              ),
                            ),
                            onTap: () {
                              final lat = double.parse(result['lat']);
                              final lon = double.parse(result['lon']);
                              setState(() {
                                _selectedLocation = LatLng(lat, lon);
                                _searchResults = [];
                                _searchController.clear();
                                _selectedAddress = {
                                  'road':
                                      result['address']['road'] ?? 'Unbekannt',
                                  'postcode':
                                      result['address']['postcode'] ??
                                      'Unbekannt',
                                  'city':
                                      result['address']['city'] ?? 'Unbekannt',
                                };
                              });
                            },
                          );
                        },
                        separatorBuilder:
                            (context, index) => const Divider(
                              color: Color(0xFF3D405B), // Trennlinienfarbe
                              thickness: 1,
                            ),
                      ),
                    ),
                ],
              ),
            ),
            if (_selectedLocation != null)
              Positioned(
                bottom: 80, // Platzierung über dem "Select"-Button
                left: MediaQuery.of(context).size.width * 0.25,
                right: MediaQuery.of(context).size.width * 0.25,
                child: Container(
                  height: 150, // 3-fache Höhe des Buttons
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF81B29A), // Hintergrundfarbe
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Straße: ${_selectedAddress['road'] ?? 'Unbekannt'}',
                        style: const TextStyle(
                          color: Color(
                            0xFF3D405B,
                          ), // Schriftfarbe wie im roten Kästchen
                          fontSize: 16, // Schriftgröße wie im roten Kästchen
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'PLZ: ${_selectedAddress['postcode'] ?? 'Unbekannt'}',
                        style: const TextStyle(
                          color: Color(
                            0xFF3D405B,
                          ), // Schriftfarbe wie im roten Kästchen
                          fontSize: 16, // Schriftgröße wie im roten Kästchen
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Stadt: ${_selectedAddress['city'] ?? 'Unbekannt'}',
                        style: const TextStyle(
                          color: Color(
                            0xFF3D405B,
                          ), // Schriftfarbe wie im roten Kästchen
                          fontSize: 16, // Schriftgröße wie im roten Kästchen
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if (_selectedLocation != null)
              Positioned(
                bottom: 16,
                left: MediaQuery.of(context).size.width * 0.25,
                right: MediaQuery.of(context).size.width * 0.25,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE07A5F),
                    foregroundColor: const Color(0xFF3D405B),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final address =
                        'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}';
                    widget.onLocationSelected(_selectedLocation!, address);
                    Navigator.pop(context);
                  },
                  child: const Text('Select'),
                ),
              ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Search powered by OpenStreetMap',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
