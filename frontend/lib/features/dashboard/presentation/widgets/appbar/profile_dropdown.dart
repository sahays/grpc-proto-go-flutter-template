import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_state.dart';

class ProfileDropdown extends StatelessWidget {
  const ProfileDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String fullName = 'User';
        String email = '';
        String initials = 'U';

        if (state is AuthAuthenticated) {
          fullName = state.user.fullName;
          email = state.user.email;
          final nameParts = fullName.split(' ');
          initials = nameParts.length >= 2
              ? '${nameParts[0][0]}${nameParts[1][0]}'
              : fullName.isNotEmpty
                  ? fullName[0]
                  : 'U';
        }

        return PopupMenuButton(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (context) => <PopupMenuEntry<dynamic>>[
            PopupMenuItem<dynamic>(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<dynamic>(
              onTap: () {
                // TODO: Navigate to profile page
              },
              child: const Row(
                children: [
                  Icon(Icons.person_outline, size: 20),
                  SizedBox(width: 12),
                  Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem<dynamic>(
              onTap: () {
                context.go('/dashboard/settings');
              },
              child: const Row(
                children: [
                  Icon(Icons.settings_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<dynamic>(
              onTap: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
