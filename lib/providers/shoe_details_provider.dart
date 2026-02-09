import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Define the Data Model
class ShoePad {
  final String id;
  final String title;
  final String size;
  final String measure;
  final String material;
  final String manufacturer;
  final bool isFavorite;
  final bool hasPhoto;

  ShoePad({
    required this.id,
    required this.title,
    required this.size,
    required this.measure,
    required this.material,
    required this.manufacturer,
    this.isFavorite = false,
    this.hasPhoto = false,
  });

  // Helper method to toggle favorite status
  ShoePad copyWith({bool? isFavorite}) {
    return ShoePad(
      id: id,
      title: title,
      size: size,
      measure: measure,
      material: material,
      manufacturer: manufacturer,
      isFavorite: isFavorite ?? this.isFavorite,
      hasPhoto: hasPhoto,
    );
  }
}

class FilterState {
  final String? selectedSize;
  final String? selectedMaterial;
  final String manufacturerSearch;
  final bool withPhotoOnly;

  FilterState({
    this.selectedSize,
    this.selectedMaterial,
    this.manufacturerSearch = '',
    this.withPhotoOnly = false,
  });

  FilterState copyWith({
    String? selectedSize,
    String? selectedMaterial,
    String? manufacturerSearch,
    bool? withPhotoOnly,
  }) {
    return FilterState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedMaterial: selectedMaterial ?? this.selectedMaterial,
      manufacturerSearch: manufacturerSearch ?? this.manufacturerSearch,
      withPhotoOnly: withPhotoOnly ?? this.withPhotoOnly,
    );
  }
}

// 2. Define the Notifier to manage the list
class PadListNotifier extends Notifier<List<ShoePad>> {
  @override
  List<ShoePad> build() {
    // Initial mock data moved from the UI to the Provider
    return [
      ShoePad(
        id: '1',
        title: 'Boot High',
        size: '41',
        measure: '240 mm BG',
        material: 'Beech',
        manufacturer: 'Heritage Craft',
      ),
      ShoePad(
        id: '2',
        title: 'Stiletto Elegant',
        size: '38',
        measure: '220 mm BG',
        material: 'Aluminum',
        manufacturer: 'PrecisionLast',
        isFavorite: true,
      ),
      ShoePad(
        id: '3',
        title: 'Oxford Classic',
        size: '42',
        measure: '245 mm BG',
        material: 'Beech',
        manufacturer: 'Springline',
      ),
    ];
  }

  // Future function to add pads
  void addPad(ShoePad pad) {
    state = [...state, pad];
  }

  // Toggle favorite status
  void toggleFavorite(String id) {
    state = [
      for (final pad in state)
        if (pad.id == id) pad.copyWith(isFavorite: !pad.isFavorite) else pad,
    ];
  }
}

class FilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() => FilterState();

  void updateSize(String size) => state = state.copyWith(selectedSize: size);
  void updateMaterial(String material) => state = state.copyWith(selectedMaterial: material);
  void updateManufacturer(String name) => state = state.copyWith(manufacturerSearch: name);
  void updateWithPhoto(bool value) => state = state.copyWith(withPhotoOnly: value);
  void resetFilters() => state = FilterState();
}

// 3. Define the Global Provider
final padListProvider = NotifierProvider<PadListNotifier, List<ShoePad>>(
  PadListNotifier.new,
);
final filterProvider = NotifierProvider<FilterNotifier, FilterState>(
  FilterNotifier.new);