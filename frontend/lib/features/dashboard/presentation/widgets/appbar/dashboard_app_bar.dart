import 'package:flutter/material.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';
import 'package:flutter_web_app/core/widgets/gradient_background.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/appbar/notification_bell.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/appbar/profile_dropdown.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/appbar/search_bar_widget.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isMobile;

  const DashboardAppBar({
    super.key,
    this.isMobile = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withOpacity(0.7)
            : Colors.white.withOpacity(0.7),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF334155)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            if (isMobile) ...[
              _buildLogo(isDark),
              const Spacer(),
            ] else ...[
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 24),
              const Expanded(child: SearchBarWidget()),
              const SizedBox(width: 24),
            ],
            const NotificationBell(),
            const SizedBox(width: 16),
            const ProfileDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.rocket_launch,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Academy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
