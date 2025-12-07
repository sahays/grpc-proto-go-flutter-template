import 'package:flutter/material.dart';
import 'package:flutter_web_app/core/widgets/gradient_background.dart';

class DashboardCard extends StatelessWidget {
  final String? title;
  final Widget? action;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const DashboardCard({
    super.key,
    this.title,
    this.action,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassmorphicCard(
      padding: padding ?? const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}
