import 'package:flutter/material.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';
import 'package:flutter_web_app/core/widgets/gradient_background.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final double? trend;
  final Color? trendColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.trend,
    this.trendColor,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        child: GlassmorphicCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              if (widget.trend != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      widget.trend! >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      size: 16,
                      color: widget.trendColor ??
                          (widget.trend! >= 0 ? Colors.green : Colors.red),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.trend!.abs()}% from last month',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.trendColor ??
                            (widget.trend! >= 0 ? Colors.green : Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
