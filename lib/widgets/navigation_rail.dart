import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_application_try_0/utils/constants.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              // Logo/Brand
              const SizedBox(
                height: 80,
                child: Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.yellow,
                    child: Text(
                      'AJ',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Navigation Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildNavItem(0, Iconsax.home, 'Dashboard'),
                    _buildNavItem(1, Iconsax.people, 'Clients'),
                    _buildNavItem(2, Iconsax.activity, 'Goals'),
                    _buildNavItem(3, Iconsax.ticket, 'Subscriptions'),
                  ],
                ),
              ),
              
              // Logout at bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildNavItem(4, Iconsax.logout, 'Logout', isLogout: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isLogout = false}) {
    final isSelected = selectedIndex == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onDestinationSelected(index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.yellow : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.yellow.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected 
                      ? AppColors.black 
                      : (isLogout ? Colors.red.shade300 : Colors.white.withValues(alpha: 0.8)),
                  size: 22,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected 
                          ? AppColors.black 
                          : (isLogout ? Colors.red.shade300 : Colors.white.withValues(alpha: 0.8)),
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}