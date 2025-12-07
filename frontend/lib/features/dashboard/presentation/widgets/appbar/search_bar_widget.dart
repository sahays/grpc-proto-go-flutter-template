import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 300,
      height: 45,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : Colors.grey.shade300,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search students, coaches, classes...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          // TODO: Implement search functionality in later tasks
        },
      ),
    );
  }
}
