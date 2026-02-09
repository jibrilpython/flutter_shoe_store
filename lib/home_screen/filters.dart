import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_store/providers/shoe_details_provider.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late TextEditingController _manufacturerController;
//   String selectedSize = '38';
//   String selectedMaterial = 'Beech';
//   bool withPhoto = true;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current state from provider
    final currentState = ref.read(filterProvider);
    _manufacturerController = TextEditingController(text: currentState.manufacturerSearch);
  }

  @override
  void dispose() {
    _manufacturerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);

    const primaryBrown = Color(0xFF6B4E37);
    const fieldBg = Color(0xFFF3EFE9);

    final List<String> sizes = ['35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45'];
    final List<String> materials = ['Beech', 'Maple', 'Aluminum', 'Plastic', 'Other'];

    return Container(
      height: MediaQuery.of(context).size.height * 0.94,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 65,
              height: 5,
              decoration: BoxDecoration(
                color: Color(0xFFD0CBCB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Center(
                child: const Text('Filters', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF2B2B2B), fontFamily: 'SF Pro Text')),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF6B4E37)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _sectionTitle('Size (EU)'),
          Wrap(
            spacing: 4,
            // runSpacing: 2,
            children: sizes.map((size) => _buildChip(
              size, 
              filterState.selectedSize == size, 
              (isSelected) {
                // If it was already selected and clicked again, clear it
                if (!isSelected) {
                   // ChoiceChip provides the new state. If we clicked a selected chip, 
                   // isSelected will be false. But we want to send null to clear it.
                }
                filterNotifier.updateSize(isSelected ? size : "");
              },
              // setState(() => selectedSize = size);
            )).toList(),
          ),

          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF3EFE9), height: 0),
          const SizedBox(height: 20),

          _sectionTitle('Material'),
          Wrap(
            spacing: 4,
            // runSpacing: 8,
            children: materials.map((m) => _buildChip(
              m, 
              filterState.selectedMaterial == m, 
              (isSelected) => filterNotifier.updateMaterial(isSelected ? m : ""),
            )).toList(),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF3EFE9), height: 0),
          const SizedBox(height: 20),

          _sectionTitle('Manufacturer'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFD0CBCB)),
            ),
            child: TextField(
              controller: _manufacturerController,
              onChanged: (value) {
                  // Update the global state as the user types
                  filterNotifier.updateManufacturer(value);
                },
              decoration: InputDecoration(
                hintText: 'Enter manufacturer name',
                hintStyle: TextStyle(color: Color(0xFFD0CBCB), fontSize: 14, fontFamily: 'SF Pro Text', fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF3EFE9), height: 0),
          const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text('With photo', style: TextStyle(fontSize: 16, color: Color(0xFF70635D))),
          //     Switch(
          //       value: withPhoto,
          //       onChanged: (val) => setState(() => withPhoto = val),
          //       activeColor: Colors.white,
          //       activeTrackColor: primaryBrown,
          //     ),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('With photo', style: TextStyle(fontSize: 16, color: Color(0xFF70635D))),
              Switch(
                value: filterState.withPhotoOnly,
                onChanged: filterNotifier.updateWithPhoto,
                activeColor: Colors.white,
                activeTrackColor: primaryBrown,
              ),
            ],
          ),

          Expanded(child:
            const SizedBox(height: 32),
          ),

          
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Final sync before closing
                filterNotifier.updateManufacturer(_manufacturerController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBrown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Apply', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF70635D), fontFamily: 'SF Pro Display'),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, Function(bool) onSelected) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontFamily: 'SF Pro Text', fontWeight: FontWeight.w500)),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: const Color(0xFF6B4E37),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Color(0xFFD0CBCB),
        fontSize: 18,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? Colors.transparent : Colors.black12),
      ),
      showCheckmark: false,
    );
  }
}