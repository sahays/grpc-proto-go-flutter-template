import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/navigation/navigation_cubit.dart';

class NavigationMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isCollapsed;
  final bool isNested;
  final VoidCallback? onTap;

  const NavigationMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
    this.isCollapsed = false,
    this.isNested = false,
    this.onTap,
  });

  @override
  State<NavigationMenuItem> createState() => _NavigationMenuItemState();
}

class _NavigationMenuItemState extends State<NavigationMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = context.watch<NavigationCubit>().isActive(widget.route);

    return Padding(
      padding: EdgeInsets.only(
        left: widget.isNested ? 16 : 0,
        bottom: 4,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                } else {
                  context.go(widget.route);
                  context.read<NavigationCubit>().navigateTo(widget.route);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: isActive ? AppTheme.primaryGradient : null,
                  color: isActive
                      ? null
                      : (_isHovered
                          ? (isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.03))
                          : null),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: widget.isNested ? 20 : 24,
                      color: isActive
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.grey.shade700),
                    ),
                    if (!widget.isCollapsed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: widget.isNested ? 14 : 15,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                            color: isActive
                                ? Colors.white
                                : (isDark
                                    ? Colors.white70
                                    : Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
