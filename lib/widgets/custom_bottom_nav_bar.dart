import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;
  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap, required this.onCenterTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 88,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background bar
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 16,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.home_rounded,
                      label: 'الرئيسية',
                      selected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                    _NavBarItem(
                      icon: Icons.list_alt_rounded,
                      label: 'طلباتي',
                      selected: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                    const SizedBox(width: 56), // Space for center button
                    _NavBarItem(
                      icon: Icons.shopping_cart_rounded,
                      label: 'السلة',
                      selected: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                    _NavBarItem(
                      icon: Icons.notifications_rounded,
                      label: 'الإشعارات',
                      selected: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ],
                ),
              ),
            ),
            // Center FAB
            Positioned(
              top: -24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onCenterTap,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                   colors: [
                     Color(0xFF667EEA),
                     Color(0xFF764BA2),],),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 34),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavBarItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.ease,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF667EEA) : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFF667EEA),
                size: 26,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: selected ? const Color(0xFF667EEA) : Colors.grey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: selected ? 14 : 13,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 1),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.ease,
              height: 4,
              width: selected ? 28 : 0,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF667EEA) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}