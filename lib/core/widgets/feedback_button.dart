import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class FeedbackButton extends StatelessWidget {
  const FeedbackButton({super.key});

  static const _feedbackUrl = 'https://forms.gle/kMmLuWQH967CLg1MA';

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return GestureDetector(
      onTap: () => launchUrl(
        Uri.parse(_feedbackUrl),
        mode: LaunchMode.externalApplication,
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: palette.gold.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.feedback_outlined,
          color: palette.gold,
          size: 18,
        ),
      ),
    );
  }
}
