import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_routes.dart';
import '../../data/mock_data.dart';
import '../../models/doctor_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/medi_app_bar.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final _searchController = TextEditingController();
  String? _selectedSpecialty;
  String? _selectedLocation;
  List<DoctorModel> _filteredDoctors = MockData.doctors;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredDoctors = MockData.doctors.where((doctor) {
        final matchesSearch = _searchController.text.isEmpty ||
            doctor.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            doctor.specialty.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            doctor.hospital.toLowerCase().contains(_searchController.text.toLowerCase());

        final matchesSpecialty =
            _selectedSpecialty == null || doctor.specialty == _selectedSpecialty;

        final matchesLocation =
            _selectedLocation == null || doctor.location == _selectedLocation;

        return matchesSearch && matchesSpecialty && matchesLocation;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedSpecialty = null;
      _selectedLocation = null;
      _filteredDoctors = MockData.doctors;
    });
  }

  bool get _hasActiveFilters =>
      _selectedSpecialty != null ||
      _selectedLocation != null ||
      _searchController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MediAppBar(
        title: 'Find Doctors',
        style: MediAppBarStyle.primary,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                hintText: 'Search doctors, specialties...',
                prefixIcon: const Icon(CupertinoIcons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(CupertinoIcons.xmark),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: [
                // Specialty Filter
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_selectedSpecialty ?? 'Specialty'),
                    selected: _selectedSpecialty != null,
                    onSelected: (_) => _showSpecialtyPicker(),
                    avatar: const Icon(CupertinoIcons.heart, size: 18),
                  ),
                ),
                // Location Filter
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_selectedLocation ?? 'Location'),
                    selected: _selectedLocation != null,
                    onSelected: (_) => _showLocationPicker(),
                    avatar: const Icon(CupertinoIcons.location, size: 18),
                  ),
                ),
                // Clear Filters
                if (_hasActiveFilters)
                  ActionChip(
                    label: const Text('Clear All'),
                    onPressed: _clearFilters,
                    avatar: const Icon(CupertinoIcons.xmark, size: 18),
                  ),
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filteredDoctors.length} doctor${_filteredDoctors.length != 1 ? 's' : ''} found',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          // Doctor List
          Expanded(
            child: _filteredDoctors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.search,
                            size: 64, color: AppColors.textSecondary.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('No doctors found', style: AppTextStyles.heading3),
                        const SizedBox(height: 8),
                        Text('Try adjusting your filters',
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.doctorProfile,
                          arguments: doctor,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showSpecialtyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(
        title: 'Select Specialty',
        items: MockData.specialties,
        selected: _selectedSpecialty,
        onSelected: (value) {
          setState(() => _selectedSpecialty = value);
          _applyFilters();
          Navigator.pop(context);
        },
        onClear: () {
          setState(() => _selectedSpecialty = null);
          _applyFilters();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(
        title: 'Select Location',
        items: MockData.locations,
        selected: _selectedLocation,
        onSelected: (value) {
          setState(() => _selectedLocation = value);
          _applyFilters();
          Navigator.pop(context);
        },
        onClear: () {
          setState(() => _selectedLocation = null);
          _applyFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selected;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  const _FilterBottomSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.heading3),
              if (selected != null)
                TextButton(onPressed: onClear, child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selected;
                return ListTile(
                  title: Text(item),
                  trailing: isSelected
                      ? const Icon(CupertinoIcons.checkmark, color: AppColors.primary)
                      : null,
                  selected: isSelected,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () => onSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
