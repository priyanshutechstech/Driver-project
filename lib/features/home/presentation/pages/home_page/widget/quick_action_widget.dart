import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/features/home/presentation/pages/home_page/page/diagnostic_page.dart';
import 'package:restart_tagxi/features/home/presentation/pages/home_page/widget/select_preference_widget.dart';

import '../../../../../../common/app_constants.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../account/presentation/pages/admin_chat/page/admin_chat.dart';
import '../../../../application/home_bloc.dart';

class QuickActionsWidget extends StatelessWidget {
  final BuildContext cont;
  const QuickActionsWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: SafeArea(
              child: Column(
                key: const Key('switcher1'),
                children: [
                  Container(
                    width: size.width,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.borderColors, // border color
                          width: 1, // border width
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: size.width * 0.05),
                    child: Column(
                      children: [
                        SizedBox(height: size.width * 0.05),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: size.width * 0.05),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Instant Activity",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8EE28C),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "• LIVE",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (userData!.showInstantRideFeatureForMobileApp == '1' &&
                      userData!.active) ...[
                    SizedBox(height: size.width * 0.05),
                    InkWell(
                      onTap: () {
                        context.read<HomeBloc>().bottomSize =
                            -(size.height * 0.8);
                        context.read<HomeBloc>().animatedWidget = null;
                        context.read<HomeBloc>().add(UpdateEvent());
                        context.read<HomeBloc>().add(ShowGetDropAddressEvent());
                      },
                      child: activityCard(
                        icon: Icons.flash_on,
                        iconColor: Colors.indigo,
                        bgColor: const Color(0xFFEFF2FF),
                        title: "Instant",
                        subtitle: "Get requests immediately",
                      ),
                    ),
                  ],
                  SizedBox(height: size.width * 0.05),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AdminChat.routeName);
                    },
                    child: activityCard(
                      icon: Icons.headset_mic,
                      iconColor: Colors.orange,
                      bgColor: const Color(0xFFFFF4E8),
                      title: "Help Center",
                      subtitle: "Support and resources",
                    ),
                  ),
                  SizedBox(height: size.width * 0.05),
                  if (Platform.isAndroid) ...[
                    activityCard(
                      icon: Icons.layers,
                      iconColor: Colors.grey,
                      bgColor: const Color(0xFFF1F1F1),
                      title: "Appear on Top",
                      subtitle: "See requests over other apps",
                      trailing: Switch(
                        value: showBubbleIcon,
                        onChanged: (v) {
                          context.read<HomeBloc>().add(EnableBubbleEvent(
                                isEnabled: v,
                              ));
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: size.width * 0.05),
                  if (userData!.enableSubVehicleFeature == "1")
                    InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(
                              GetSubVehicleTypesEvent(
                                serviceLocationId: userData!.serviceLocationId!,
                                vehicleType: userData!.vehicleTypes![0],
                              ),
                            );
                      },
                      child: activityCard(
                        icon: Icons.directions_car,
                        iconColor: Colors.orange,
                        bgColor: const Color(0xFFFFF4E8),
                        title: "My Services",
                        subtitle: "Manage vehicle services",
                      ),
                    ),
                  if (userData!.enableSubVehicleFeature == "1")
                    SizedBox(height: size.width * 0.05),
                  if (userData!.active && userData!.role == 'driver')
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          DiagnosticPage.routeName,
                        );
                      },
                      child: activityCard(
                        icon: Icons.notifications_off_outlined,
                        iconColor: Colors.red,
                        bgColor: const Color(0xFFFFECEC),
                        title: "Not Getting Requests?",
                        subtitle: "Run diagnostics check",
                      ),
                    ),
                  if (userData!.active && userData!.role == 'driver')
                    SizedBox(height: size.width * 0.05),
                  if (userData!.role == 'driver')
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            enableDrag: false,
                            isDismissible: false,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(
                                    20.0), // Adjust the radius to your liking
                              ),
                            ),
                            builder: (_) {
                              return SelectPreferenceWidget(cont: context);
                            });
                      },
                      child: activityCard(
                        icon: Icons.tune,
                        iconColor: Colors.green,
                        bgColor: const Color(0xFFE9FFE8),
                        title: "Preferences",
                        subtitle: "Customize your experience",
                      ),
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000B8F),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "TODAY'S EARNINGS",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${userData!.currencySymbol}${userData!.totalEarnings}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "TRIPS",
                                        style: TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        userData!.totalRidesTaken ?? "0",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "HOURS",
                                        style: TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        (Duration(
                                          minutes: (double.tryParse(
                                                    userData!
                                                        .totalMinutesOnline!,
                                                  ) ??
                                                  0)
                                              .toInt(),
                                        ).inHours)
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget activityCard({
  required IconData icon,
  required Color iconColor,
  required Color bgColor,
  required String title,
  required String subtitle,
  VoidCallback? onTap,
  Widget? trailing,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFEAEAEA),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        trailing ??
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
      ],
    ),
  );
}
