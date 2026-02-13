import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_store/providers/shoe_details_provider.dart';

class KeyMeasurementsScreen extends ConsumerStatefulWidget {
  final String name;
  final String manufacturer;
  final String size;
  final String material;
  final String? imagePath;

  const KeyMeasurementsScreen({
    super.key,
    required this.name,
    required this.manufacturer,
    required this.size,
    required this.material,
    this.imagePath,
  });

  
  @override
  ConsumerState<KeyMeasurementsScreen> createState() => _KeyMeasurementsScreenState();
}

class _KeyMeasurementsScreenState extends ConsumerState<KeyMeasurementsScreen> {
  final _ballGirthController = TextEditingController();
  final _instepGirthController = TextEditingController();
  final _lengthController = TextEditingController();
  final _heelHeightController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _ballGirthController.dispose();
    _instepGirthController.dispose();
    _lengthController.dispose();
    _heelHeightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showSaveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white, 
          // surfaceTintColor: Colors.white, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16) ),
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 8),
                child: Text('Add this Pads?', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'SF Pro Display', color: Colors.black)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Are you sure you want to save this entry?', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text', color: Colors.black)),
              ),
              const SizedBox(height: 24),
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('No', style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'SF Pro Display', fontWeight: FontWeight.w500)))),
                  Container(width: 1, height: 50, color: Colors.black12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // 1. CREATE THE NEW PAD OBJECT
                        final newPad = ShoePad(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: widget.name,
                          size: widget.size,
                          measure: "${_lengthController.text.isEmpty ? '0' : _lengthController.text} mm",
                          material: widget.material,
                          manufacturer: widget.manufacturer,
                          isFavorite: false,
                          // hasPhoto: widget.hasPhoto,
                          imagePath: widget.imagePath, // Saving the actual path
                          ballGirth: _ballGirthController.text.trim(),
                          instepGirth: _instepGirthController.text.trim(),
                          heelHeight: _heelHeightController.text.trim(),
                          notes: _notesController.text.trim(),
                        );

                        // 2. SAVE TO THE PROVIDER
                        ref.read(padListProvider.notifier).addPad(newPad);

                        // CLEAR IMAGE PICKER STATE
                        ref.read(imagePickerProvider).clearImage();

                        // 3. GO BACK TO HOME
                        Navigator.pop(context); // Close dialog
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Yes', style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'SF Pro Display', fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }










  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF9F6F1);
    const primaryBrown = Color(0xFF6D523B);
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.all(24.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                          'Key Measurements',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'SF Pro Text'),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildLabel('Ball Girth (mm)'),
                        _buildTextField(_ballGirthController, 'Example: 240', fieldBg, isNumber: true),
                        _buildSubtext('Circumference at widest part of forefoot'),

                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Instep Girth (mm)'),
                                  _buildTextField(_instepGirthController, 'Example: 260', fieldBg, isNumber: true),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Lenght (mm)'),
                                  _buildTextField(_lengthController, 'Example: 285', fieldBg, isNumber: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                             Expanded(child: _buildSubtext('Circumference over instep')),
                             const SizedBox(width: 16),
                             Expanded(child: _buildSubtext('Total length heel to toe')),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _buildLabel('Heel Height (mm)'),
                        _buildTextField(_heelHeightController, 'Example: 25', fieldBg, isNumber: true),
                        _buildSubtext('Height of heel from ground'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                          'Notes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'SF Pro Display'),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: fieldBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD0CBCB)),
                          ),
                          child: TextField(
                            controller: _notesController,
                            maxLines: 2,
                            maxLength: 250,
                            
                            buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
                            decoration: const InputDecoration(
                              hintText: 'Describe the fit characteristics, best use cases, any special considerations...',
                              hintStyle: TextStyle(fontSize: 14, color:Color(0xFFD0CBCB), fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text'),
                              border: InputBorder.none,
                            ),
                            
                            onChanged: (val) => setState(() {}),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_notesController.text.length}\\250',
                            style: const TextStyle(fontSize: 12, color:Color(0xFF70635D), fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // padding: const EdgeInsets.all(24.0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 42),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showSaveConfirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF4A494F), fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSubtext(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text(text, style: const TextStyle(fontSize: 12, color:Color(0xFF70635D), fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text')),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, Color bg, {bool isNumber = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bg, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD0CBCB))
        ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color:Color(0xFFD0CBCB), fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text'),
          border: InputBorder.none,
        ),
      ),
    );
  }
}