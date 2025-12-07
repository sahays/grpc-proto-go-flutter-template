import 'package:flutter/material.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';

class CollapsibleMenuSection extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isCollapsed;
  final List<Widget> children;

  const CollapsibleMenuSection({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
    required this.isCollapsed,
    required this.children,
  });

  @override
  State<CollapsibleMenuSection> createState() => _CollapsibleMenuSectionState();
}

class _CollapsibleMenuSectionState extends State<CollapsibleMenuSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isCollapsed) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 24,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Column(
                  children: widget.children,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
