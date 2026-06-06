import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:restart_tagxi/common/common.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../../../core/utils/custom_header.dart';
import '../../../../../auth/presentation/pages/login_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/history/page/history_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/wallet/page/wallet_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/incentive/page/incentive_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/notification/page/notification_page.dart';

class EarningsPage extends StatefulWidget {
  static const String routeName = '/earningsPage';
  final EarningArguments? args;

  const EarningsPage({super.key, this.args});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

List dragValue = [];

class _EarningsPageState extends State<EarningsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
        create: (context) => AccBloc()..add(GetEarningsEvent()),
        child:
            BlocListener<AccBloc, AccState>(listener: (context, state) async {
          if (state is EarningsLoadingStartState) {
            CustomLoader.loader(context);
          }
          if (state is EarningsLoadingStopState) {
            CustomLoader.dismiss(context);
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
          if (state is ShowErrorState) {
            return showToast(message: state.message);
          }
        }, child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            body: ((context.read<AccBloc>().earningsList.isNotEmpty))
                ? Column(
                    children: [
                      CustomHeader(
                        title: AppLocalizations.of(context)!.earnings,
                        automaticallyImplyLeading: (widget.args != null &&
                                widget.args!.from! == 'dashboard')
                            ? true
                            : false,
                        titleFontSize: 18,
                        actions: [
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    NotificationPage.routeName,
                                  );
                                },
                              ),
                              Positioned(
                                right: 12,
                                top: 12,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.025,
                      ),
                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.all(size.width * 0.025),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A128F),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            MyText(
                              text:
                                  AppLocalizations.of(context)!.weeklyEarnings,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            MyText(
                              text: (context
                                      .read<AccBloc>()
                                      .earningsList
                                      .isNotEmpty)
                                  ? '${context.read<AccBloc>().earningCurrency} ${context.read<AccBloc>().earningsList[context.read<AccBloc>().choosenEarningsWeeks!].totalAmount}'
                                  : '',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: size.width * 0.025,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.greenAccent,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '0% from last week',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.width * 0.05,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.025,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _earningsActionCard(
                                Icons.directions_car_filled_outlined,
                                'Trips',
                                () {
                                  Navigator.pushNamed(
                                      context, IncentivePage.routeName);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _earningsActionCard(
                                Icons.account_balance_wallet,
                                'Wallet',
                                () {
                                  Navigator.pushNamed(
                                      context, WalletHistoryPage.routeName);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _earningsActionCard(
                                Icons.access_time_filled,
                                'History',
                                () {
                                  Navigator.pushNamed(
                                    context,
                                    HistoryPage.routeName,
                                    arguments: HistoryAccountPageArguments(
                                      isFrom: 'account',
                                      isSupportTicketEnabled:
                                          userData!.enableSupportTicketFeature,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Daily Overview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd').format(DateTime.now()),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (context.read<AccBloc>().earningsList.isNotEmpty)
                        GestureDetector(
                          onHorizontalDragStart: (v) {
                            dragValue.clear();
                          },
                          onHorizontalDragUpdate: (v) {
                            dragValue.add(v.globalPosition.dx);
                          },
                          onHorizontalDragEnd: (v) {
                            if (dragValue[dragValue.length - 1] >
                                dragValue[dragValue.length - 2]) {
                              if (context.read<AccBloc>().earningsList.length -
                                      1 >
                                  context
                                      .read<AccBloc>()
                                      .choosenEarningsWeeks!) {
                                context.read<AccBloc>().add(
                                    ChangeEarningsWeekEvent(
                                        week: context
                                                .read<AccBloc>()
                                                .choosenEarningsWeeks! +
                                            1));
                              }
                            }
                            if (dragValue[dragValue.length - 1] <
                                dragValue[dragValue.length - 2]) {
                              if (context
                                      .read<AccBloc>()
                                      .choosenEarningsWeeks! !=
                                  0) {
                                context.read<AccBloc>().add(
                                    ChangeEarningsWeekEvent(
                                        week: context
                                                .read<AccBloc>()
                                                .choosenEarningsWeeks! -
                                            1));
                              }
                            }
                          },
                          child: SizedBox(
                            width: size.width * 0.9,
                            height: size.width * 0.21,
                            child: PageView(
                              reverse: true,
                              controller:
                                  context.read<AccBloc>().earningsController,
                              onPageChanged: (v) {
                                final accBloc = context.read<AccBloc>();
                                final earningsList = accBloc.earningsList;
                                context.read<AccBloc>().choosenEarningsWeeks =
                                    v;
                                accBloc.add(ChangeEarningsWeekEvent(week: v));
                                final selectedWeekData = earningsList[v];
                                final firstDateKey =
                                    selectedWeekData.dates.keys.first;
                                if (v == earningsList.length - 1) {
                                  context.read<AccBloc>().add(
                                        GetDailyEarningsEvent(
                                          date: selectedWeekData.fromDate
                                              .toString()
                                              .replaceFirst(
                                                selectedWeekData.fromDate
                                                    .toString()
                                                    .split('-')[0],
                                                firstDateKey
                                                    .toString()
                                                    .split('-')[1],
                                              ),
                                        ),
                                      );
                                } else {
                                  context.read<AccBloc>().add(
                                        GetDailyEarningsEvent(date: 'today'),
                                      );
                                }
                              },
                              scrollDirection: Axis.horizontal,
                              children: context
                                  .read<AccBloc>()
                                  .earningsList
                                  .asMap()
                                  .map((k, v) {
                                    return MapEntry(
                                        k,
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: context
                                                  .read<AccBloc>()
                                                  .earningsList[context
                                                      .read<AccBloc>()
                                                      .choosenEarningsWeeks!]
                                                  .dates
                                                  .map((k, v) {
                                                    bool display = false;
                                                    if (int.parse(context
                                                            .read<AccBloc>()
                                                            .earningsList[context
                                                                .read<AccBloc>()
                                                                .choosenEarningsWeeks!]
                                                            .toDate
                                                            .toString()
                                                            .split('-')[0]) <
                                                        int.parse(k
                                                            .toString()
                                                            .split('-')[1])) {
                                                      if (DateTime.now()
                                                              .difference(DateFormat('dd-MMM-yy').parse(context
                                                                  .read<
                                                                      AccBloc>()
                                                                  .earningsList[context
                                                                      .read<
                                                                          AccBloc>()
                                                                      .choosenEarningsWeeks!]
                                                                  .fromDate
                                                                  .toString()
                                                                  .replaceFirst(
                                                                      context
                                                                          .read<
                                                                              AccBloc>()
                                                                          .earningsList[context
                                                                              .read<AccBloc>()
                                                                              .choosenEarningsWeeks!]
                                                                          .fromDate
                                                                          .toString()
                                                                          .split('-')[0],
                                                                      k.toString().split('-')[1])))
                                                              .inHours >=
                                                          0) {
                                                        display = true;
                                                      }
                                                    } else {
                                                      if (DateTime.now()
                                                              .difference(DateFormat('dd-MMM-yy').parse(context
                                                                  .read<
                                                                      AccBloc>()
                                                                  .earningsList[context
                                                                      .read<
                                                                          AccBloc>()
                                                                      .choosenEarningsWeeks!]
                                                                  .toDate
                                                                  .toString()
                                                                  .replaceFirst(
                                                                      context
                                                                          .read<
                                                                              AccBloc>()
                                                                          .earningsList[context
                                                                              .read<AccBloc>()
                                                                              .choosenEarningsWeeks!]
                                                                          .toDate
                                                                          .toString()
                                                                          .split('-')[0],
                                                                      k.toString().split('-')[1])))
                                                              .inHours >=
                                                          0) {
                                                        display = true;
                                                      }
                                                    }
                                                    return MapEntry(
                                                        k,
                                                        Container(
                                                          width:
                                                              size.width * 0.11,
                                                          margin: EdgeInsets.only(
                                                              right:
                                                                  size.width *
                                                                      0.015),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  size.width *
                                                                      0.01),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color: (context
                                                                          .read<
                                                                              AccBloc>()
                                                                          .choosenEarningsDate ==
                                                                      k)
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : AppColors
                                                                      .borderColor),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                            children: [
                                                              MyText(
                                                                text: k
                                                                    .toString()
                                                                    .split(
                                                                        '-')[0],
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            size.width *
                                                                                0.035,
                                                                        color: (context.read<AccBloc>().choosenEarningsDate ==
                                                                                k)
                                                                            ? AppColors.white
                                                                            : Theme.of(context).hintColor),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    size.width *
                                                                        0.015,
                                                              ),
                                                              Material(
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius: BorderRadius
                                                                    .circular(size
                                                                            .width *
                                                                        0.045),
                                                                child: InkWell(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          size.width *
                                                                              0.045),
                                                                  onTap:
                                                                      (display)
                                                                          ? () {
                                                                              if (display) {
                                                                                if (int.parse(context.read<AccBloc>().earningsList[context.read<AccBloc>().choosenEarningsWeeks!].toDate.toString().split('-')[0]) < int.parse(k.toString().split('-')[1])) {
                                                                                  context.read<AccBloc>().add(GetDailyEarningsEvent(date: context.read<AccBloc>().earningsList[context.read<AccBloc>().choosenEarningsWeeks!].fromDate.toString().replaceFirst(context.read<AccBloc>().earningsList[context.read<AccBloc>().choosenEarningsWeeks!].fromDate.toString().split('-')[0], k.toString().split('-')[1])));
                                                                                } else {
                                                                                  context.read<AccBloc>().add(GetDailyEarningsEvent(date: context.read<AccBloc>().earningsList[context.read<AccBloc>().choosenEarningsWeeks!].toDate.toString().replaceFirst(context.read<AccBloc>().earningsList[context.read<AccBloc>().choosenEarningsWeeks!].toDate.toString().split('-')[0], k.toString().split('-')[1])));
                                                                                }
                                                                              }
                                                                            }
                                                                          : null,
                                                                  child: MyText(
                                                                    text: k
                                                                        .toString()
                                                                        .split(
                                                                            '-')[1],
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                size.width * 0.035,
                                                                            color: (display)
                                                                                ? (context.read<AccBloc>().choosenEarningsDate != k)
                                                                                    ? Theme.of(context).hintColor
                                                                                    : AppColors.white
                                                                                : Theme.of(context).disabledColor),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ));
                                                  })
                                                  .values
                                                  .toList(),
                                            ),
                                            if (context
                                                    .read<AccBloc>()
                                                    .earningsList
                                                    .length >
                                                1)
                                              SizedBox(
                                                height: size.width * 0.025,
                                              ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                (context
                                                                .read<AccBloc>()
                                                                .earningsList
                                                                .length -
                                                            1 >
                                                        context
                                                            .read<AccBloc>()
                                                            .choosenEarningsWeeks!)
                                                    ? InkWell(
                                                        onTap: () {},
                                                        child: MyText(
                                                          text: '<<',
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize:
                                                                      size.width *
                                                                          0.035,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorDark),
                                                        ),
                                                      )
                                                    : Container(),
                                                (context
                                                            .read<AccBloc>()
                                                            .choosenEarningsWeeks! !=
                                                        0)
                                                    ? InkWell(
                                                        onTap: () {},
                                                        child: MyText(
                                                          text: '>>',
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize:
                                                                      size.width *
                                                                          0.035,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorDark),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          ],
                                        ));
                                  })
                                  .values
                                  .toList(),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: size.width * 0.025,
                      ),
                      SizedBox(
                        height: size.width * 0.75,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.width * 0.5,
                                width: size.width * 0.8,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: SizedBox(
                                      width: size.width * 0.7,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: context
                                            .read<AccBloc>()
                                            .earningsList[context
                                                .read<AccBloc>()
                                                .choosenEarningsWeeks!]
                                            .dates
                                            .map((k, v) {
                                              dynamic higher = 0;
                                              context
                                                  .read<AccBloc>()
                                                  .earningsList[context
                                                      .read<AccBloc>()
                                                      .choosenEarningsWeeks!]
                                                  .dates
                                                  .forEach((k, v) {
                                                if (v > higher) {
                                                  higher = v;
                                                }
                                              });
                                              return MapEntry(
                                                k,
                                                Container(
                                                  width: size.width * 0.08,
                                                  height: context
                                                              .read<AccBloc>()
                                                              .earningsList[context
                                                                  .read<
                                                                      AccBloc>()
                                                                  .choosenEarningsWeeks!]
                                                              .dates[k] >
                                                          0
                                                      ? size.width *
                                                          0.4 *
                                                          (v / higher)
                                                      : 1,
                                                  color: Theme.of(context)
                                                      .primaryColorDark
                                                      .withAlpha(
                                                          (0.5 * 255).toInt()),
                                                ),
                                              );
                                            })
                                            .values
                                            .toList(),
                                      ),
                                    )),
                                    SizedBox(
                                      height: size.width * 0.015,
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      height: 1,
                                      color: AppColors.black,
                                    ),
                                    SizedBox(
                                      height: size.width * 0.015,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Row(
                                        children: context
                                            .read<AccBloc>()
                                            .earningsList[context
                                                .read<AccBloc>()
                                                .choosenEarningsWeeks!]
                                            .dates
                                            .map((k, v) {
                                              return MapEntry(
                                                k,
                                                SizedBox(
                                                    width: size.width * 0.1,
                                                    child: MyText(
                                                      text: k.toString()[0],
                                                      textAlign:
                                                          TextAlign.center,
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize:
                                                                  size.width *
                                                                      0.035,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                    )),
                                              );
                                            })
                                            .values
                                            .toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (context.read<AccBloc>().dailyEarningsList !=
                                  null)
                                Column(
                                  children: [
                                    SizedBox(
                                      height: size.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFE5E5E5),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFEDE7FF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.access_time_filled,
                                                      color: Color(0xFF6C63FF),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    'Login Hours',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    context
                                                        .read<AccBloc>()
                                                        .dailyEarningsList!
                                                        .totalHoursWorked,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFE5E5E5),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFE8FFE8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.route,
                                                      color: Colors.green,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    'Total Dist.',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${context.read<AccBloc>().dailyEarningsList!.totalTripsKm.toStringAsFixed(1)} ${userData!.distanceUnit}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.width * 0.05,
                                    ),
                                    Container(
                                      width: size.width * 0.9,
                                      height: 1,
                                      color: AppColors.borderColors,
                                    ),
                                    SizedBox(
                                      height: size.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: MyText(
                                        text: AppLocalizations.of(context)!
                                            .summary,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .disabledColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.width * 0.05,
                                    ),
                                    (context
                                            .read<AccBloc>()
                                            .dailyEarningsList!
                                            .data
                                            .isNotEmpty)
                                        ? Column(children: [
                                            for (var i = 0;
                                                i <
                                                    context
                                                        .read<AccBloc>()
                                                        .dailyEarningsList!
                                                        .data
                                                        .length;
                                                i++)
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: size.width * 0.025),
                                                width: size.width * 0.9,
                                                padding: EdgeInsets.all(
                                                    size.width * 0.05),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withAlpha(
                                                          (0.3 * 255).toInt()),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          MyText(
                                                            text: AppLocalizations
                                                                    .of(context)!
                                                                .trips,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColorDark),
                                                          ),
                                                          MyText(
                                                            text: context
                                                                .read<AccBloc>()
                                                                .dailyEarningsList!
                                                                .data[i]
                                                                .tripTime,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColorDark),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    MyText(
                                                      text:
                                                          '${context.read<AccBloc>().dailyEarningsList!.currency} ${context.read<AccBloc>().dailyEarningsList!.data[i].tripCommission}',
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 16,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ])
                                        : Column(
                                            children: [
                                              Image.asset(
                                                AppImages.earningsNoData,
                                                width: size.width * 0.5,
                                                height: size.width * 0.5,
                                                fit: BoxFit.contain,
                                              ),
                                              const SizedBox(height: 8),
                                              MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .noSummaryText),
                                              const SizedBox(height: 15),
                                            ],
                                          )
                                  ],
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
          );
        })));
  }
}

Widget _earningsActionCard(
  IconData icon,
  String title,
  VoidCallback onTap,
) {
  return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E5E5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: title == 'Trips'
                    ? const Color(0xFFE8F0FF)
                    : title == 'Wallet'
                        ? const Color(0xFFE8FFE8)
                        : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: title == 'Trips'
                    ? Colors.blue
                    : title == 'Wallet'
                        ? Colors.green
                        : Colors.orange,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ));
}
