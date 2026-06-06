import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/app_images.dart';
import 'package:restart_tagxi/common/local_data.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_dialoges.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/help/page/help_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/history/page/history_page.dart';
import 'package:restart_tagxi/features/account/presentation/widgets/menu_options.dart';
import 'package:restart_tagxi/features/auth/presentation/pages/login_page.dart';
import '../../../../common/app_arguments.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../driverprofile/presentation/pages/driver_profile_pages.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import 'dashboard/page/owner_dashboard.dart';
import 'driver_report/pages/reports_page.dart';
import 'earnings/page/earnings_page.dart';
import 'fleet_driver/page/fleet_drivers_page.dart';
import 'incentive/page/incentive_page.dart';
import 'levelup/page/driver_levels_page.dart';
import 'myroute_booking/page/myroute_booking.dart';
import 'notification/page/notification_page.dart';
import 'profile/page/profile_info_page.dart';
import 'refferal/page/referral_page.dart';
import 'rewards/page/rewards_page.dart';
import 'settings/page/settings_page.dart';
import 'sos/page/sos_page.dart';
import 'subscription/page/subscription_page.dart';
import 'vehicle_info/page/vehicle_data_page.dart';
import 'wallet/page/wallet_page.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/accountPage';
  final AccountPageArguments arg;

  const AccountPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(AccGetUserDetailsEvent())
        ..add(UserDataInitEvent(userDetails: arg.userData)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          }
          if (state is UserDetailState) {
            Navigator.pushNamed(
              context,
              ProfileInfoPage.routeName,
            ).then((value) {
              if (!context.mounted) return;
              context.read<AccBloc>().add(AccGetUserDetailsEvent());
            });
          }
          if (state is LogoutSuccess || state is LogoutFailureState) {
            await AppSharedPreference.getUserTypeStatus();
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginPage.routeName,
                (route) => false,
              );
            }
            await AppSharedPreference.logoutRemove();
          } else if (state is DeleteAccountSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, ChooseLanguagePage.routeName, (route) => false,
                arguments: ChangeLanguageArguments(from: 0));
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          } else if (state is DeleteAccountFailureState) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();

          return SafeArea(
            child: Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                // Use CustomScrollView for Sliver performance
                body: CustomScrollView(
                  slivers: [
                    /// 1. TOP HEADER (Static part converted to Sliver)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor, // important for shadow visibility
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset:
                                    const Offset(0, 4), // natural drop shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: size.width * 0.020),
                                      circleProfile(size, context),
                                      SizedBox(width: size.width * 0.04),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /// NAME
                                            MyText(
                                              text: userData!.name,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w100,
                                                    decorationThickness: 9,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 1),
                                            Text(
                                              userData!.mobile,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            /// RATING CAPSULE (Only for Driver)
                                            if (userData!.role == "driver")
                                              if (userData!.role == "driver")
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffE7F7D9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        size: 16,
                                                        color: Colors.green,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${userData!.rating} Rating',
                                                        style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, HelpPage.routeName);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline,
                                          size: size.width * 0.05,
                                          color: AppColors.grey2),
                                      SizedBox(width: size.width * 0.01),
                                      MyText(
                                        text:
                                            AppLocalizations.of(context)!.help,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.grey2,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// 2. SCROLLABLE CONTENT
                    SliverPadding(
                      padding: EdgeInsets.all(size.width * 0.04),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          MyText(
                            text: AppLocalizations.of(context)!.yourAccount,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                          SizedBox(height: size.width * 0.03),

                          // --- ACCOUNT SECTION ---
                          MenuSectionCard(children: [
                            MenuOptions(
                              icon: Icons.person_outline,
                              iconColor: Colors.blue.shade500,
                              iconbackground: Colors.blue.shade50,
                              label: AppLocalizations.of(context)!
                                  .personalInformation,
                              subtitle: 'Manage your profile',
                              imagePath: AppImages.user,
                              onTap: () {
                                Navigator.pushNamed(
                                        context, ProfileInfoPage.routeName,
                                        arguments: arg)
                                    .then((value) {
                                  if (!context.mounted) return;
                                  context.read<AccBloc>().add(UpdateEvent());
                                });
                              },
                            ),
                            customDivider(context),
                            MenuOptions(
                              icon: Icons.directions_car_outlined,
                              subtitle: 'Vehicle details & docs',
                              iconColor: Colors.indigo.shade500,
                              iconbackground: Colors.indigo.shade50,
                              label: userData!.role != 'owner'
                                  ? AppLocalizations.of(context)!.myVehicle
                                  : AppLocalizations.of(context)!.manageFleet,
                              imagePath: AppImages.vehicleMakeImage,
                              onTap: () => Navigator.pushNamed(
                                  context, VehicleDataPage.routeName,
                                  arguments: VehicleDataArguments(from: 0)),
                            ),
                            customDivider(context),
                            MenuOptions(
                              //icon: Icons.folder,
                              icon: Icons.description_outlined,
                              subtitle: 'Licenses & certificates',
                              iconColor: Colors.teal.shade600,
                              iconbackground: Colors.teal.shade50,
                              label: AppLocalizations.of(context)!.documents,
                              onTap: () {
                                Navigator.pushNamed(
                                        context, DriverProfilePage.routeName,
                                        arguments: VehicleUpdateArguments(
                                            from: 'docs'))
                                    .then((value) {
                                  if (!context.mounted) return;
                                  context.read<AccBloc>().add(UpdateEvent());
                                });
                              },
                            ),
                            customDivider(context),
                            if (userData!.showWalletFeatureOnMobileApp == '1')
                              MenuOptions(
                                icon: Icons.account_balance_wallet_outlined,
                                subtitle: 'Balance & transactions',
                                iconColor: Colors.purple.shade500,
                                iconbackground: Colors.purple.shade50,
                                label: AppLocalizations.of(context)!.wallet,
                                imagePath: AppImages.creditCard,
                                onTap: () => Navigator.pushNamed(
                                    context, WalletHistoryPage.routeName),
                              ),
                            if (userData!.role == 'owner') ...[
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.local_shipping_outlined,
                                iconColor: Colors.deepOrange.shade600,
                                iconbackground: Colors.deepOrange.shade50,
                                label: AppLocalizations.of(context)!.drivers,
                                onTap: () => Navigator.pushNamed(
                                    context, FleetDriversPage.routeName),
                              ),
                              customDivider(context),
                              MenuOptions(
                                // 2. Dashboard
                                icon: Icons.dashboard_outlined,
                                iconColor: Colors.green.shade600,
                                iconbackground: Colors.green.shade50,
                                label: AppLocalizations.of(context)!.dashboard,
                                onTap: () => Navigator.pushNamed(
                                    context, OwnerDashboard.routeName,
                                    arguments:
                                        OwnerDashboardArguments(from: '')),
                              ),
                            ],
                          ]),

                          // --- BENEFITS SECTION ---
                          SizedBox(height: size.width * 0.05),
                          if (userData!.role == 'driver')
                            MyText(
                              text: AppLocalizations.of(context)!.benefits,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          SizedBox(height: size.width * 0.05),
                          if (userData!.role == 'driver')
                            MenuSectionCard(children: [
                              MenuOptions(
                                icon: Icons.attach_money,
                                subtitle: 'Earnings & payouts',
                                iconColor: Colors.green,
                                iconbackground: Color(0xFFDDF8DD),
                                label: AppLocalizations.of(context)!.myEarnings,
                                imagePath: AppImages.wallet,
                                onTap: () => Navigator.pushNamed(
                                    context, EarningsPage.routeName,
                                    arguments:
                                        EarningArguments(from: 'dashboard')),
                              ),
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.history,
                                subtitle: 'Ride & payment history',
                                iconColor: Colors.orange,
                                iconbackground: Color(0xFFFFF0CC),
                                label: AppLocalizations.of(context)!.history,
                                // icon: Icons.history,
                                onTap: () => Navigator.pushNamed(
                                    context, HistoryPage.routeName,
                                    arguments: HistoryAccountPageArguments(
                                      isFrom: 'account',
                                      isSupportTicketEnabled:
                                          userData!.enableSupportTicketFeature,
                                    )),
                              ),
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.bar_chart_outlined,
                                subtitle: 'Performance analytics',
                                iconColor: Colors.orange.shade600,
                                iconbackground: Colors.orange.shade50,
                                label:
                                    AppLocalizations.of(context)!.reportsText,
                                imagePath: AppImages.fileText,
                                onTap: () => Navigator.pushNamed(
                                    context, ReportsPage.routeName),
                              ),
                              customDivider(context),
                              if (userData!.showDriverLevel == true)
                                MenuOptions(
                                  icon: Icons.card_giftcard,
                                  subtitle: 'Bonuses & incentives',
                                  iconColor: Colors.red,
                                  iconbackground: Color(0xFFFFE5E8),
                                  label:
                                      AppLocalizations.of(context)!.rewardsText,
                                  imagePath: AppImages.award,
                                  onTap: () => Navigator.pushNamed(
                                      context, RewardsPage.routeName),
                                ),
                              customDivider(context),
                              if (userData!.showIncentiveFeatureForDriver ==
                                      "1" &&
                                  userData!.availableIncentive != null)
                                MenuOptions(
                                  icon: Icons.workspace_premium_outlined,
                                  subtitle: 'Extra earning opportunities',
                                  iconColor: Colors.deepOrange.shade600,
                                  iconbackground: Colors.deepOrange.shade50,
                                  label:
                                      AppLocalizations.of(context)!.incentives,
                                  imagePath: AppImages.dollarSign,
                                  onTap: () => Navigator.pushNamed(
                                      context, IncentivePage.routeName),
                                ),
                              customDivider(context),
                              if (userData!.showDriverLevel == true)
                                MenuOptions(
                                  icon: Icons.trending_up,
                                  subtitle: 'Progress & achievements',
                                  iconColor: Colors.blue,
                                  iconbackground: Color(0xFFDDF8FF),
                                  label:
                                      AppLocalizations.of(context)!.levelupText,
                                  onTap: () => Navigator.pushNamed(
                                      context, DriverLevelsPage.routeName),
                                ),
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.group_outlined,
                                iconColor: Colors.amber.shade700,
                                subtitle: 'Invite friends & earn rewards',
                                iconbackground: Colors.amber.shade50,
                                label:
                                    AppLocalizations.of(context)!.referAndEarn,
                                imagePath: AppImages.share,
                                onTap: () => Navigator.pushNamed(
                                    context, ReferralPage.routeName,
                                    arguments: ReferralArguments(
                                        title: AppLocalizations.of(context)!
                                            .referAndEarn,
                                        userData: arg.userData)),
                              ),
                            ]),

                          // --- PREFERENCES SECTION ---
                          SizedBox(height: size.width * 0.05),
                          MyText(
                            text: AppLocalizations.of(context)!.preferences,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          MenuSectionCard(children: [
                            if (userData!.role == 'driver' &&
                                userData!.hasSubscription! &&
                                (userData!.driverMode == 'subscription' ||
                                    userData!.driverMode == 'both'))
                              MenuOptions(
                                icon: Icons.credit_card_outlined,
                                iconColor: Colors.indigo.shade500,
                                subtitle: "Manage your plan",
                                iconbackground: Colors.indigo.shade50,
                                label: AppLocalizations.of(context)!
                                    .mySubscription,
                                imagePath: AppImages.giftIcon,
                                onTap: () {
                                  Navigator.pushNamed(
                                          context, SubscriptionPage.routeName,
                                          arguments: SubscriptionPageArguments(
                                              isFromAccPage: true))
                                      .then((value) {
                                    if (!context.mounted) return;
                                    context.read<AccBloc>().add(UpdateEvent());
                                  });
                                },
                              ),
                            customDivider(context),
                            if (userData!.role != 'owner')
                              MenuOptions(
                                icon: Icons.notifications_none,
                                iconColor: Colors.red.shade400,
                                iconbackground: Colors.red.shade50,
                                label: "Notifications",
                                subtitle: "Manage alerts & updates",
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  NotificationPage.routeName,
                                ),
                              ),
                            customDivider(context),
                            MenuOptions(
                              icon: Icons.language,
                              iconColor: Colors.blue.shade600,
                              iconbackground: Colors.blue.shade50,
                              label: "Language",
                              subtitle: "English",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ChooseLanguagePage.routeName,
                                  arguments: ChangeLanguageArguments(from: 1),
                                );
                              },
                            ),
                            if (userData!.role != 'owner' &&
                                userData!.enableMyRouteFeature == '1')
                              customDivider(context),
                            MenuOptions(
                              icon: Icons.location_on_outlined,
                              subtitle: "Scheduled route bookings",
                              iconColor: Colors.teal.shade600,
                              iconbackground: Colors.teal.shade50,
                              label:
                                  AppLocalizations.of(context)!.myRouteBooking,
                              showroute: true,
                              showrouteValue:
                                  userData!.enableMyRouteBooking == '1',
                              onTap: () {
                                Navigator.pushNamed(
                                        context, RouteBooking.routeName)
                                    .then((value) {
                                  accBloc.add(AccGetUserDetailsEvent());
                                });
                              },
                            ),
                            customDivider(context),
                            MenuOptions(
                              icon: Icons.support_agent,
                              iconColor: Colors.red.shade600,
                              iconbackground: Colors.red.shade50,
                              subtitle: "Emergency contacts & safety",
                              label: AppLocalizations.of(context)!.sosText,
                              onTap: () {
                                Navigator.pushNamed(context, SosPage.routeName,
                                        arguments: SOSPageArguments(
                                            sosData: userData!.sos!.data))
                                    .then((value) {
                                  if (!context.mounted || value == null) return;
                                  final sos = value as List<SOSDatum>;
                                  context.read<AccBloc>().sosdata = sos;
                                  userData!.sos!.data = sos;
                                  context.read<AccBloc>().add(UpdateEvent());
                                });
                              },
                            ),
                          ]),

                          // --- SETTINGS SECTION ---
                          SizedBox(height: size.width * 0.05),
                          MyText(
                            text: "Support",
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          MenuSectionCard(
                            children: [
                              MenuOptions(
                                icon: Icons.settings_outlined,
                                iconColor: Colors.grey.shade700,
                                iconbackground: Colors.grey.shade100,
                                label: "App Settings",
                                subtitle: "App preferences & controls",
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    SettingsPage.routeName,
                                  );
                                },
                              ),
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.help_outline,
                                iconColor: Colors.orange,
                                iconbackground: Colors.orange.shade50,
                                label: "Help Center",
                                subtitle: "Get support and assistance",
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    HelpPage.routeName,
                                  );
                                },
                              ),
                            ],
                          ),
                          // Bottom padding for scrollability
                          SizedBox(height: size.width * 0.05),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFFFD6D6),
                              ),
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFFFFFAFA),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.red.shade400,
                                ),
                              ),
                              title: const Text(
                                'Logout Account',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext _) {
                                    return BlocProvider.value(
                                      value: BlocProvider.of<AccBloc>(context),
                                      child: CustomDoubleButtonDialoge(
                                        title: AppLocalizations.of(context)!
                                            .comeBackSoon,
                                        content: AppLocalizations.of(context)!
                                            .logoutSure,
                                        noBtnName:
                                            AppLocalizations.of(context)!.no,
                                        yesBtnName:
                                            AppLocalizations.of(context)!.yes,
                                        yesBtnFunc: () {
                                          context
                                              .read<AccBloc>()
                                              .add(LogoutEvent());
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Menu Group Card Widget ---------------------------------------------------
class MenuSectionCard extends StatelessWidget {
  final List<Widget> children;

  const MenuSectionCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 4, // Increase blur
            spreadRadius: 0.5, // Spread evenly
            offset: const Offset(0, 0), // Center shadow (all sides)
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

Widget circleProfile(Size size, BuildContext context) {
  return CircleAvatar(
      radius: size.width * 0.09,
      backgroundColor: Theme.of(context).dividerColor,
      backgroundImage: userData!.profilePicture.isNotEmpty
          ? NetworkImage(userData!.profilePicture)
          : null);
}

Widget customDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Divider(
      height: 1,
      thickness: 0.4,
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    ),
  );
}

Widget weeklyEarningsWidget(BuildContext context, Size size) {
  final bloc = context.watch<AccBloc>(); // 👈 FIXED

  final amount = (bloc.earningsList.isNotEmpty)
      ? '${bloc.earningCurrency} ${bloc.earningsList[bloc.choosenEarningsWeeks!].totalAmount}'
      : '';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.weeklyEarnings,
                textStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),
              MyText(
                text: amount,
                textStyle: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
      ],
    ),
  );
}
