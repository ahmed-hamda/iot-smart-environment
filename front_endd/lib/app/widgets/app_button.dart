import 'package:flutter/material.dart';
import 'package:front_endd/app/widgets/app_colors.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  final int currentIndex;

  const AppButton({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return SafeArea( // ✅ évite la barre système
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7), // 🔼 augmente un peu
        margin: const EdgeInsets.only(bottom: 5), // 🔼 remonte la navbar
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem("Accueil", Icons.home, "/home", 0),
            _navItem("Historique", Icons.history, "/history", 1),
            _navItem("Alerte", Icons.notifications, "/alert", 2),
            _navItem("Prediction", Icons.analytics, "/prediction", 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String label, IconData icon, String route, int index) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () {
        Get.offAllNamed(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}