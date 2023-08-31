import 'dart:io';

import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place_provider.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState {
  final _formKey = GlobalKey<FormState>();
  var _enteredPlaceTitle = '';
  File? _selectedImage;
  final _titleController = TextEditingController();
  PlaceLocation? _selectedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _savePlace() {
    if (_selectedImage == null || _selectedLocation == null) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(placesProvider.notifier).addNewPlace(Place(
            title: _enteredPlaceTitle,
            image: _selectedImage!,
            location: _selectedLocation!,
          ));
    }

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  controller: _titleController,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return 'Must be greater than 1 character.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPlaceTitle = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                LocationInput(onSelectLocation: (location) {
                  _selectedLocation = location;
                }),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _savePlace();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                ),
              ],
            ),
          )),
    );
  }
}
