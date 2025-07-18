import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_profile.dart';

class DashboardHeader extends StatelessWidget {
  final UserProfile userProfile;
  final String greeting;

  const DashboardHeader({
    super.key,
    required this.userProfile,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingL,
        AppSizes.paddingXL,
        AppSizes.paddingL,
        AppSizes.paddingM,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusXL),
          bottomRight: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    userProfile.name,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: 'profile_image',
              child: GestureDetector(
                onTap: () {
                  // Navigate to profile page
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.onPrimary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: userProfile.profileImageUrl != null
                        ? Image.network(
                            userProfile.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(),
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.secondary,
      child: Icon(
        Icons.person,
        color: AppColors.onPrimary,
        size: AppSizes.iconL,
      ),
    );
  }
}
