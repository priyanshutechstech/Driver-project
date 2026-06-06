import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
// import '../../../../../../core/utils/custom_text.dart';
// import '../../../../../../l10n/app_localizations.dart';z

class HistoryNodataWidget extends StatelessWidget {
  const HistoryNodataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                AppImages.noRideHistoryImage,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No History Available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Make new booking to view it here. Your trip summaries will appear once you complete your first ride.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Color(0xFF07128F),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Need help with your wallet?',
                    style: TextStyle(
                      color: Color(0xFF07128F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
