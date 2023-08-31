import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place_provider.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    var userPlaces = ref.watch(placesProvider);

    void onSelectedPlace(Place place) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(place: place)),
      );
    }

    void addNewPlace() async {
      final newPlace = await Navigator.of(context).push<Place>(
        MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
      );
      if (newPlace == null) {
        return;
      }

      userPlaces = ref.read(placesProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(onPressed: addNewPlace, icon: const Icon(Icons.add))
        ],
      ),
      body: userPlaces.isEmpty
          ? Center(
              child: Text('No place added yet',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: _placesFuture,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : PlacesList(
                            places: userPlaces,
                            onSelectedPlace: onSelectedPlace,
                          ),
              ),
            ),
    );
  }
}
