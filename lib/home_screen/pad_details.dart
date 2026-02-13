import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_store/home_screen/bottom_list.dart';
import 'package:shoe_store/providers/shoe_details_provider.dart';

class PadDetailsScreen extends ConsumerWidget {
  final ShoePad pad;

  const PadDetailsScreen({super.key, required this.pad});

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        actionsPadding: EdgeInsets.zero,
        title: const Text(
          'Deleting this Pad?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'SF Pro Display', color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to delete the Pad?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text', color: Colors.black),
        ),
        actions: [
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'SF Pro Display', fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(width: 1, height: 50, color: Colors.black12),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    ref.read(padListProvider.notifier).deletePad(pad.id);
                    Navigator.pop(context); // Go back to Home
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'SF Pro Display', fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _showMoreOptions(BuildContext context, WidgetRef ref) {
    const primaryBrown = Color(0xFF6D523B);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              // Container(
              //   width: 65,
              //   height: 5,
              //   decoration: BoxDecoration(
              //     color: Color(0xFFD0CBCB),
              //     borderRadius: BorderRadius.circular(2),
              //   ),
              // ),
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
              const SizedBox(height: 8),
              ListLengths(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_outlined, color: primaryBrown),
                    title: const Text('Edit a Pad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2B2B2B), fontFamily: 'SF Pro Sidplay')),
                    onTap: () {
                      Navigator.pop(context);
                      // Edit logic placeholder
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: primaryBrown),
                    title: const Text('Delete a Pads', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2B2B2B), fontFamily: 'SF Pro Sidplay')),
                    onTap: () {
                      Navigator.pop(context); // Close bottom sheet
                      _showDeleteConfirmation(context, ref);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const backgroundColor = Color(0xFFF9F6F1);
    // const primaryBrown = Color(0xFF6D523B);
    // const labelColor = Color(0xFF8C7A6B);
    final currentPads = ref.watch(padListProvider);
    // final currentPad = currentPads.firstWhere((p) => p.id == pad.id, orElse: () => pad);
    final currentPad = currentPads.any((p) => p.id == pad.id) 
        ? currentPads.firstWhere((p) => p.id == pad.id) 
        : pad;


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Color(0xFFD0CBCB).withOpacity(0.5),
          )
        ),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          currentPad.title,
          style: const TextStyle(color: Color(0xFF2B2B2B), fontWeight: FontWeight.w500, fontSize: 22, fontFamily: 'SF Pro Display'),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              currentPad.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: currentPad.isFavorite ? Colors.red : Colors.black45,
            ),
            onPressed: () => ref.read(padListProvider.notifier).toggleFavorite(currentPad.id),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => _showMoreOptions(context, ref),
          ),
        
        ],
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            // Pad Photo
            Container(
              width: double.infinity,
              height: 156,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFD0CBCB)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF533721).withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                // image: DecorationImage(
                //   image: AssetImage(currentPad.hasPhoto ? 'assets/img/shoe1.png' :
                //    'assets/img/shoe1.png'),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: currentPad.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(currentPad.imagePath!), fit: BoxFit.cover),
                    )
                  : const Center(child: Icon(Icons.camera_alt, size: 42, color: Color(0xFF70635D))),

            ),
            const SizedBox(height: 16),

            // Basic Information Card
            _buildCard(
              title: 'Basic information',
              children: [
                Row(
                  children: [
                  //   _buildDetailItem('Size', '${widget.pad.size} EU'),
                  //   Container(width: 1, height: 50, color: Colors.black12),
                  //   _buildDetailItem('Material', widget.pad.material),
                  
                  Expanded(child: _buildDetailItem('Size', '${currentPad.size} EU')),

                  Expanded(child: _buildDetailItem('Material', currentPad.material))
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailItem('Manufacturer', currentPad.manufacturer),
              ],
            ),
            const SizedBox(height: 8),

            // Key Measurements Card
            _buildCard(
              title: 'Key Measurements',
              children: [
                // _buildMeasurementRow('Ball Girth', '240 mm', 'Circumference at widest part of forefoot'),
                // _buildMeasurementRow('Instep Girth', '255 mm', 'Circumference over instep'),
                // _buildMeasurementRow('Lenght', '280 mm', 'Total length heel to toe'),
                // _buildMeasurementRow('Heel Height', '280 mm', 'Height of heel from ground'),
                _buildMeasurementRow(
                  'Ball Girth', 
                  currentPad.ballGirth.isEmpty ? 'N/A' : '${currentPad.ballGirth} mm', 
                  'Circumference at widest part of forefoot'
                ),
                _buildMeasurementRow(
                  'Instep Girth', 
                  currentPad.instepGirth.isEmpty ? 'N/A' : '${currentPad.instepGirth} mm', 
                  'Circumference over instep'
                ),
                _buildMeasurementRow(
                  'Length', 
                  currentPad.measure, 
                  'Total length heel to toe'
                ),
                _buildMeasurementRow(
                  'Heel Height', 
                  currentPad.heelHeight.isEmpty ? 'N/A' : '${currentPad.heelHeight} mm', 
                  'Height of heel from ground'
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Notes Card
            _buildCard(
              title: 'Notes',
              children: [
                Text(
                  // 'Excellent for boots, high instep accommodation. Perfect for ankle boots and work boot styles.',
                  currentPad.notes.isEmpty ? 'No additional notes provided.' : currentPad.notes,
                  style: TextStyle(fontSize: 14, color: Color(0xFF70635D), height: 1.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      // height: 194,
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    // return Flexible(
        return Column(
      // child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF70635D), fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text'),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'SF Pro Display'),
          ),
        ],
      );
    // );
  }

  Widget _buildMeasurementRow(String label, String value, String subtext) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text'),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'SF Pro Display'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtext,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'SF Pro Text', color: Color(0xFF70635D)),
          ),
        ],
      ),
    );
  }
}


