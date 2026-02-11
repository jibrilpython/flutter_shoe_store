import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_store/home_screen/measurements.dart';
// import 'package:shoe_store/providers/shoe_details_provider.dart';
// import 'providers.dart';

// Enums for structured data
enum PadMaterial { beech, maple, aluminum, plastic, other }

extension PadMaterialExtension on PadMaterial {
  String get name {
    switch (this) {
      case PadMaterial.beech: return 'Beech';
      case PadMaterial.maple: return 'Maple';
      case PadMaterial.aluminum: return 'Aluminum';
      case PadMaterial.plastic: return 'Plastic';
      case PadMaterial.other: return 'Other';
    }
  }
}

class AddPadScreen extends ConsumerStatefulWidget {
  const AddPadScreen({super.key});

  @override
  ConsumerState<AddPadScreen> createState() => _AddPadScreenState();
}

class _AddPadScreenState extends ConsumerState<AddPadScreen> {
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  
  String _selectedSize = '35';
  PadMaterial _selectedMaterial = PadMaterial.beech;
  bool _hasPhoto = false; // Simulating photo attachment for this demo

  final List<String> _sizes = ['35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45'];

  @override
  void dispose() {
    _nameController.dispose();
    _manufacturerController.dispose();
    super.dispose();
  }

  void _handlePickPhoto() {
    // In a real app, you would use image_picker here.
    // For this simulation, we toggle the photo state to show UI changes.
    setState(() {
      _hasPhoto = !_hasPhoto;
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF9F6F1);
    const primaryBrown = Color(0xFF6D523B);
    // const textSecondary = Color(0xFF8C7A6B);
    const fieldBg = Color(0xFFF3EFE9);

    return Scaffold( 
      backgroundColor: backgroundColor, 
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        // toolbarHeight: 56,
        flexibleSpace: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 11),
              child: const Text(
                'Add New Pads',
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Color(0xFFD0CBCB).withOpacity(0.5),
          )
        ),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            // Photo Section
            GestureDetector(
              onTap: _handlePickPhoto,
              child: Container(
                width: double.infinity,
                height: 156,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFD0CBCB)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF533721).withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  image: _hasPhoto 
                    ? const DecorationImage(
                        image: AssetImage('assets/img/shoe1.png'), // Mocking the saved photo
                        fit: BoxFit.cover,
                      )
                    : null,
                  // border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: !_hasPhoto 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 42, color: Color(0xFF70635D)),
                        const SizedBox(height: 4),
                        const Text('Add photo', style: TextStyle(color: Color(0xFF70635D))),
                      ],
                    )
                  : null,
              ),
            ),
            const SizedBox(height: 16),
            
            // Basic Information Section
            Container(
              width: double.infinity,
              // padding: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Colors.black.withOpacity(0.05)),
                border: Border.all(color: Color(0xFFD0CBCB)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF533721).withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Basic information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'SF Pro Text', ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildLabel('Name'),
                  _buildTextField(_nameController, 'Oxford Classic', fieldBg),
                  
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Size (EU)'),
                            _buildDropdown<String>(
                              value: _selectedSize,
                              items: _sizes,
                              onChanged: (val) => setState(() => _selectedSize = val!),
                              bg: fieldBg,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Material'),
                            _buildDropdown<PadMaterial>(
                              value: _selectedMaterial,
                              items: PadMaterial.values,
                              onChanged: (val) => setState(() => _selectedMaterial = val!),
                              bg: fieldBg,
                              itemLabel: (m) => m.name,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  _buildLabel('Manufacturer'),
                  _buildTextField(_manufacturerController, 'Heritage Craft', fieldBg),
                ],
              ),
            ),
            // const SizedBox(height: 40),
            
            // Next Button removed from body and moved to Scaffold.bottomNavigationBar
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 42),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => KeyMeasurementsScreen(
                  name: _nameController.text.isEmpty ? "Unnamed Pad" : _nameController.text,
                  manufacturer: _manufacturerController.text.isEmpty ? "Unknown" : _manufacturerController.text,
                  size: _selectedSize,
                  material: _selectedMaterial.name,
                  hasPhoto: _hasPhoto,
                  )
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBrown,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'SF Pro Display')),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward, size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Color(0xFF4A494F), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD0CBCB))
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color:Color(0xFFD0CBCB), fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text'),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required Color bg,
    String Function(T)? itemLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD0CBCB))
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel != null ? itemLabel(item) : item.toString(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF2B2B2B), fontWeight: FontWeight.w400 ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}