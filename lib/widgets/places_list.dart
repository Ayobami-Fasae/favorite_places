import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList(
      {super.key, required this.places, required this.onSelectedPlace});

  final List<Place> places;
  final void Function(Place) onSelectedPlace;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(places[index].image),
          ),
          onTap: () {
            onSelectedPlace(places[index]);
          },
          title: Text(
            places[index].title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          subtitle: Text(
            places[index].location.address,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        );
      },
    );
  }
}
