import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shoe_store/home_screen/filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_store/home_screen/pad_details.dart';
import 'package:shoe_store/providers/shoe_details_provider.dart';
import 'package:shoe_store/home_screen/add_pad.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isAllTab = true;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterSheet(),
    );
  }

  late TextEditingController _manufacturerController;

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
    const backgroundColor = Color(0xFFF9F6F1);
    const primaryBrown = Color(0xFF6B4E37);
    const secondaryContainer = Color(0xFFF3EFE9);

    final allPads = ref.watch(padListProvider);
    final filters = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);
    
    // const textSecondary = Color(0xFF70635D);




    // final displayedPads = isAllTab 
    //     ? allPads 
    //     : allPads.where((p) => p.isFavorite).toList();


    // Dynamic filtering logic
    final displayedPads = allPads.where((pad) {
      // Tab filter
      if (!isAllTab && !pad.isFavorite) return false;
      
      // 2. Size filter: Only filter if a size is actually selected
      if (filters.selectedSize != null && filters.selectedSize!.isNotEmpty) {
        if (pad.size != filters.selectedSize) return false;
      }
      
      // 3. Material filter: Only filter if a material is actually selected
      if (filters.selectedMaterial != null && filters.selectedMaterial!.isNotEmpty) {
        if (pad.material != filters.selectedMaterial) return false;
      }
      
      // 4. Manufacturer filter: Case-insensitive partial match
      if (filters.manufacturerSearch.isNotEmpty) {
        final search = filters.manufacturerSearch.toLowerCase();
        if (!pad.manufacturer.toLowerCase().contains(search)) return false;
      }
      
      // 5. Photo filter: Only filter if the switch is ON
      if (filters.withPhotoOnly && (pad.imagePath == null || pad.imagePath!.isEmpty)) return false;

      return true;
    }).toList();



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
                'List of pads',
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
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


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            // Search and Filter Row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFD0CBCB)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFFD0CBCB)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            // controller: _manufacturerController,
                            // onChanged: (value) {
                            //   // Update the global state as the user types
                            //   filterNotifier.updateManufacturer(value);
                            // },
                            controller: _manufacturerController,
                            onChanged: (value) {
                              // Check if the entire input can be parsed as a number (int or double)
                              if (value.isEmpty) {
                                // Clear ALL filters when the field is emptied
                                filterNotifier.updateManufacturer('');
                                filterNotifier.updateMaterial('');
                                filterNotifier.updateSize('');
                              } else if (double.tryParse(value) != null) {
                                // Numeric input → update only size filter
                                filterNotifier.updateSize(value);
                              } else {
                                // Non‑numeric, non‑empty input → update both manufacturer and material
                                filterNotifier.updateManufacturer(value);
                                // filterNotifier.updateMaterial(value);
                              }
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Search by name, size, measurements...',
                              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFD0CBCB), fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Container(
                //   height: 44,
                //   width: 44,
                //   decoration: BoxDecoration(
                //     color: primaryBrown,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: const Icon(Icons.tune, color: Colors.white),
                // ),

                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: primaryBrown,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Custom Toggle Switch

            Container(
              height: 49,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTabButton('All', isAllTab, () => setState(() => isAllTab = true)),
                  _buildTabButton('Favorites', !isAllTab, () => setState(() => isAllTab = false)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${displayedPads.length} pads found',
                style: const TextStyle(color: Color(0xFF70635D), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Display'),
              ),
            ),
            const SizedBox(height: 16),
            // Content: Empty State vs List State
            Expanded(
              child: displayedPads.isEmpty
                  ? _buildEmptyState(primaryBrown, Color(0xFF70635D))
                  : _buildPadList(displayedPads, Color(0xFF70635D))
                  // : GestureDetector(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     // context,
                  //     // MaterialPageRoute(
                  //     //   builder: (_) => PadDetailsScreen(pad: pad),
                  //     // ),
                  //     // );
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (_) => PadDetailsScreen(pad: pad))
                  //     );
                  //   },
                  //   child: _buildPadList(displayedPads, Color(0xFF70635D)),
                  // ),
                  // : _buildPadList(context, ref, allPads),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 12),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddPadScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, color: backgroundColor),
                  label: const Text('Add Pads'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBrown,
                    foregroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Color(0xFFF9F6F1) : Color(0xFFF3EFE9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [BoxShadow(color: Color(0x53372111).withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? Colors.black : const Color(0xFF70635D),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color primary, Color secondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 84, color: primary.withOpacity(0.8)),
          const SizedBox(height: 12),
          const Text('No pads found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Try adjusting your search terms or filters to find what you\'re looking for.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF4A494F), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPadList(List<ShoePad> pads, Color secondary) {
    return ListView.separated(
      itemCount: pads.length,
      // itemCount: pads.itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final pad = pads[index];
        final bool hasImage = pad.imagePath != null && pad.imagePath!.isNotEmpty;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFD0CBCB)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF533721).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PadDetailsScreen(pad: pad),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE7),
                    borderRadius: BorderRadius.circular(12),
                    // image: pad.hasPhoto
                    //   ? const DecorationImage(
                    //       image: AssetImage('assets/img/shoe1.png'),
                    //       fit: BoxFit.cover,
                    //     )
                    //   : null,
                  ),
                  // child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF70635D)),
                  // child: !pad.hasPhoto
                  //   ? const Icon(Icons.camera_alt_rounded, color: Color(0xFF70635D))
                  //   : null,

                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: hasImage
                      ? Image.file(
                          File(pad.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.broken_image_outlined, color: Colors.black12),
                        )
                      : const Icon(Icons.camera_alt_rounded, color: Color(0xFF70635D)),
                ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pad.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: Color(0xFF1D1D1D), fontFamily: 'SF Pro Display' )),
                      const SizedBox(height: 4),
                      Text('${pad.size} EU  •  ${pad.measure} BG', style: TextStyle(color: secondary, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text')),
                      Text('${pad.material}  •  ${pad.manufacturer}', style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text')),
                    ],
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(padListProvider.notifier).toggleFavorite(pad.id);
                      },
                      child: Icon(
                        pad.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: pad.isFavorite ? const Color(0xFFE57373) : Colors.grey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.chevron_right, color: Color(0xFF70635D))
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (_) => PadDetailsScreen(pad: pad))
                    //     );
                    //   },
                    //   child: const Icon(Icons.chevron_right, color: Color(0xFF70635D)),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}