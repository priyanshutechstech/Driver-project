import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/app_images.dart';
import 'package:restart_tagxi/common/local_data.dart';
import 'package:restart_tagxi/core/utils/custom_appbar.dart';
import 'package:restart_tagxi/core/utils/custom_button.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/levelup/widget/level_grid_shimmer.dart';
import 'package:restart_tagxi/features/auth/application/auth_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../../auth/presentation/pages/login_page.dart';

class DriverLevelsPage extends StatelessWidget {
  static const String routeName = '/driverLevelsPage';

  const DriverLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()..add(DriverLevelnitEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
          if (state is UserUnauthenticatedState) {
            await AppSharedPreference.getUserType();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPage.routeName,
              (route) => false,
            );
          }
          if (state is DriverLevelPopupState) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (builder) {
                  return AlertDialog(
                      content: SizedBox(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: size.width * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyText(
                              text: state.driverLevelList.data.createdAt,
                              textStyle: const TextStyle(
                                  color: AppColors.greyHintColor),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                AppImages.successLevelPopup,
                                height: size.width * 0.3,
                                width: size.width * 0.3,
                              ),
                            ),
                            Positioned(
                              top: size.width * 0.05,
                              left: size.width * 0.2,
                              right: size.width * 0.2,
                              child: Align(
                                alignment: Alignment.center,
                                child: Image(
                                  height: size.width * 0.20,
                                  width: size.width * 0.20,
                                  image: NetworkImage(
                                      state.driverLevelList.data.levelIcon),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width * 0.03),
                        MyText(
                          text:
                              "${state.driverLevelList.data.levelName} ${state.driverLevelList.data.level}",
                          textStyle: const TextStyle(
                              fontSize: 16,
                              color: AppColors.yellowColor,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: size.width * 0.04,
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!
                              .levelupSuccessText
                              .replaceAll(
                                  "1", "${state.driverLevelList.data.level}")
                              .replaceAll(
                                  "25", state.driverLevelList.data.totalRides)
                              .replaceAll("500",
                                  state.driverLevelList.data.totalEarnings),
                          textStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: size.width * 0.06,
                        ),
                        CustomButton(
                          borderRadius: 30,
                          buttonName: AppLocalizations.of(context)!.ok,
                          buttonColor: AppColors.primary,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ));
                });
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.levelupText,
                automaticallyImplyLeading: true,
              ),
              body: SizedBox(
                height: size.height,
                child: (context.read<AccBloc>().isLoading &&
                        context.read<AccBloc>().firstLoadLevel &&
                        !context.read<AccBloc>().loadMoreLevel)
                    ? const LevelsGridShimmer()
                    : context.read<AccBloc>().driverLevelsList.isNotEmpty ||
                            true
                        ? Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 8,
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'CURRENT STANDING',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              '12,450 XP',
                                              style: TextStyle(
                                                fontSize: 34,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF5B4CF0),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child:
                                                  const LinearProgressIndicator(
                                                value: 0.82,
                                                minHeight: 8,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '2,550 XP To Level 5',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        'Rewards Roadmap',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _roadmapTile(
                                        number: '✓',
                                        title: 'Early Adopter',
                                        subtitle:
                                            'Access to basic fleet dashboards and monthly reports.',
                                        badge: 'CLAIMED',
                                        badgeColor: Colors.green,
                                      ),
                                      _roadmapTile(
                                        number: '2',
                                        title: 'Fleet Enthusiast',
                                        subtitle:
                                            'Unlocked: Advanced route optimization algorithms.',
                                        badge: 'ACTIVE',
                                        badgeColor: Colors.deepPurple,
                                      ),
                                      _roadmapTile(
                                        number: '3',
                                        title: 'Logistics Pro',
                                        subtitle:
                                            'Unlock: Real-time driver behavior monitoring.',
                                        badge: 'LOCKED',
                                        badgeColor: Colors.grey,
                                      ),
                                      _roadmapTile(
                                        number: '4',
                                        title: 'Operations Master',
                                        subtitle:
                                            'Unlock: Predictive maintenance scheduling.',
                                        badge: 'LOCKED',
                                        badgeColor: Colors.grey,
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 52,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('Earn More XP'),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Center(
                                        child: Text(
                                          'Complete daily tasks to unlock rewards faster.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (context.read<AccBloc>().loadMoreLevel &&
                                  !context.read<AccBloc>().isLoading &&
                                  !context.read<AccBloc>().firstLoadLevel)
                                Center(
                                  child: SizedBox(
                                      height: size.width * 0.08,
                                      width: size.width * 0.08,
                                      child: const CircularProgressIndicator()),
                                ),
                            ],
                          )
                        : SizedBox(
                            height: size.width * 0.20,
                            width: size.width * 0.20,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Image(
                                    height: size.width * 0.20,
                                    width: size.width * 0.20,
                                    image:
                                        const AssetImage(AppImages.levelLocked),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.054,
                                        top: size.height * 0.031),
                                    child: Image(
                                        height: size.width * 0.10,
                                        image:
                                            const AssetImage(AppImages.lock)),
                                  ),
                                )
                              ],
                            ),
                          ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _roadmapTile({
  required String number,
  required String title,
  required String subtitle,
  required String badge,
  required Color badgeColor,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFEAEAEA),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Text(number),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
