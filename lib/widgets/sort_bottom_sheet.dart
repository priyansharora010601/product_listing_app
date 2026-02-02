// lib/widgets/sort_bottom_sheet.dart
import 'package:flutter/material.dart';

enum SortOption {
  nameAsc,
  nameDesc,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  newest,
}

class SortBottomSheet extends StatelessWidget {
  final SortOption currentSort;
  final Function(SortOption) onSortChanged;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildSortOption(
            context,
            'Name (A-Z)',
            Icons.sort_by_alpha,
            SortOption.nameAsc,
          ),
          _buildSortOption(
            context,
            'Name (Z-A)',
            Icons.sort_by_alpha,
            SortOption.nameDesc,
          ),
          _buildSortOption(
            context,
            'Price: Low to High',
            Icons.arrow_upward,
            SortOption.priceLowToHigh,
          ),
          _buildSortOption(
            context,
            'Price: High to Low',
            Icons.arrow_downward,
            SortOption.priceHighToLow,
          ),
          _buildSortOption(
            context,
            'Rating: High to Low',
            Icons.star,
            SortOption.ratingHighToLow,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSortOption(
      BuildContext context,
      String title,
      IconData icon,
      SortOption option,
      ) {
    final isSelected = currentSort == option;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.primary,
      )
          : null,
      onTap: () {
        onSortChanged(option);
        Navigator.pop(context);
      },
    );
  }
}