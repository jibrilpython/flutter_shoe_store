import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

// Define the Data Model
class ShoePad {
  final String id;
  final String title;
  final String size;
  final String measure;
  final String material;
  final String manufacturer;
  final bool isFavorite;
  final String? imagePath;

    // New dynamic fields
  final String ballGirth;
  final String instepGirth;
  final String heelHeight;
  final String notes;

  ShoePad({
    required this.id,
    required this.title,
    required this.size,
    required this.measure,
    required this.material,
    required this.manufacturer,
    this.isFavorite = false,
    this.imagePath,
    this.ballGirth = '',
    this.instepGirth = '',
    this.heelHeight = '',
    this.notes = '',

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'size': size,
      'measure': measure,
      'material': material,
      'manufacturer': manufacturer,
      'isFavorite': isFavorite,
      'imagePath': imagePath,
      'ballGirth': ballGirth,
      'instepGirth': instepGirth,
      'heelHeight': heelHeight,
      'notes': notes,
    };
  }

  // Create a ShoePad from a Map
  factory ShoePad.fromMap(Map<String, dynamic> map) {
    return ShoePad(
      id: map['id'],
      title: map['title'],
      size: map['size'],
      measure: map['measure'],
      material: map['material'],
      manufacturer: map['manufacturer'],
      isFavorite: map['isFavorite'] ?? false,
      imagePath: map['imagePath'],
      ballGirth: map['ballGirth'] ?? '',
      instepGirth: map['instepGirth'] ?? '',
      heelHeight: map['heelHeight'] ?? '',
      notes: map['notes'] ?? '',
    );
  }

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
      imagePath: imagePath,
      ballGirth: ballGirth,
      instepGirth: instepGirth,
      heelHeight: heelHeight,
      notes: notes,
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





// ChangeNotifier for Image Picking
class ImagePickerProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  XFile? get selectedImage => _selectedImage;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        _selectedImage = pickedFile;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }
}

final imagePickerProvider = ChangeNotifierProvider((ref) => ImagePickerProvider());




// Define the Notifier to manage the list
class PadListNotifier extends Notifier<List<ShoePad>> {
  static const _storageKey = 'archived_pads_list';

  @override
  List<ShoePad> build() {

      // Initial load
    _loadFromPrefs();
    return []; // Start empty, will be populated by _loadFromPrefs
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? padsJson = prefs.getString(_storageKey);
    
    if (padsJson != null) {
      final List<dynamic> decoded = jsonDecode(padsJson);
      state = decoded.map((item) => ShoePad.fromMap(item)).toList();
    } else {
      // Default data if first time
      state = [
        ShoePad(
        id: '1',
        title: 'Boot High',
        size: '41',
        measure: '240 mm',
        material: 'Beech',
        manufacturer: 'Heritage Craft',
      ),
      ShoePad(
        id: '2',
        title: 'Stiletto Elegant',
        size: '38',
        measure: '220 mm',
        material: 'Aluminum',
        manufacturer: 'PrecisionLast',
        isFavorite: true,
      ),
      ShoePad(
        id: '3',
        title: 'Oxford Classic',
        size: '42',
        measure: '245 mm',
        material: 'Beech',
        manufacturer: 'Springline',
      ),
      ];
      _saveToPrefs();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(state.map((pad) => pad.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }
  

  // Future function to add pads
  void addPad(ShoePad pad) {
    state = [...state, pad];
    _saveToPrefs();
  }

  void deletePad(String id) {
    state = state.where((pad) => pad.id != id).toList();
    _saveToPrefs();
  }

  void toggleFavorite(String id) {
    state = [
      for (final pad in state)
        if (pad.id == id) pad.copyWith(isFavorite: !pad.isFavorite) else pad,
    ];
    _saveToPrefs();
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