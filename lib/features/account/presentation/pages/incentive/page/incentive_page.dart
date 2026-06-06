import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/local_data.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../auth/presentation/pages/login_page.dart';
import '../widget/incentive_date_widget.dart';
import '../widget/upcoming_incentives_widget.dart';

class IncentivePage extends StatelessWidget {
  static const String routeName = '/incentivePage';

  const IncentivePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(GetIncentiveEvent(
            type: userData!.availableIncentive == '0' ||
                    userData?.availableIncentive == '2'
                ? 0
                : 1)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is IncentiveLoadingStartState) {
            CustomLoader.loader(context);
          }

          if (state is ShowErrorState) {
            showToast(message: state.message);
          }

          if (state is IncentiveLoadingStopState) {
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
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.incentives,
                automaticallyImplyLeading: true,
                titleFontSize: 18,
              ),
              body: SafeArea(
                  child: Container(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  children: [
                    Column(
                      children: [
                        userData?.availableIncentive == '2'
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColors.borderColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: size.width * 0.15,
                                padding: EdgeInsets.all(size.width * 0.0125),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (context
                                                .read<AccBloc>()
                                                .choosenIncentiveData !=
                                            0) {
                                          context
                                              .read<AccBloc>()
                                              .add(GetIncentiveEvent(type: 0));
                                        }
                                      },
                                      child: Container(
                                          width: size.width * 0.42,
                                          decoration: BoxDecoration(
                                            color: (context
                                                        .read<AccBloc>()
                                                        .choosenIncentiveData ==
                                                    0)
                                                ? AppColors.white
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .dailyCaps,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: (context
                                                              .read<AccBloc>()
                                                              .choosenIncentiveData ==
                                                          0)
                                                      ? AppColors.hintColorGrey
                                                      : Theme.of(context)
                                                          .hintColor,
                                                ),
                                          )),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (context
                                                .read<AccBloc>()
                                                .choosenIncentiveData !=
                                            1) {
                                          context
                                              .read<AccBloc>()
                                              .add(GetIncentiveEvent(type: 1));
                                        }
                                      },
                                      child: Container(
                                          width: size.width * 0.42,
                                          decoration: BoxDecoration(
                                            color: (context
                                                        .read<AccBloc>()
                                                        .choosenIncentiveData ==
                                                    1)
                                                ? AppColors.white
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .weeklyCaps,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: (context
                                                              .read<AccBloc>()
                                                              .choosenIncentiveData ==
                                                          1)
                                                      ? AppColors.hintColorGrey
                                                      : Theme.of(context)
                                                          .hintColor,
                                                ),
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            : userData?.availableIncentive == '0'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.05),
                                        child: MyText(
                                          text: AppLocalizations.of(context)!
                                              .dailyCaps,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              ),
                                        ),
                                      ),
                                    ],
                                  )
                                : userData?.availableIncentive == '1'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                                size.width * 0.05),
                                            child: MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .weeklyCaps,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                        SizedBox(
                          height: size.width * 0.05,
                        ),
                        SizedBox(
                          height: size.width * 0.185,
                          child: IncentiveDateWidget(cont: context),
                        ),
                        SizedBox(
                          height: size.width * 0.05,
                        ),
                        if (context.read<AccBloc>().selectedIncentiveHistory !=
                            null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E5E5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Active Boosts',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Live Now',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'WEEKEND WARRIOR',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Complete ${context.read<AccBloc>().selectedIncentiveHistory!.upcomingIncentives.last.rideCount} Trips',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                LinearProgressIndicator(
                                  value: 0.60,
                                  minHeight: 8,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${context.read<AccBloc>().selectedIncentiveHistory!.totalRides} completed',
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${userData!.currencySymbol}${context.read<AccBloc>().selectedIncentiveHistory!.earnUpto}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    (context.read<AccBloc>().incentiveHistory.isNotEmpty &&
                            context.read<AccBloc>().incentiveDates.isNotEmpty)
                        ? Expanded(
                            child: BlocBuilder<AccBloc, AccState>(
                              builder: (context, state) {
                                if (state is ShowUpcomingIncentivesState) {
                                  return ShowUpcomingIncentivesWidget(
                                      cont: context,
                                      upcomingIncentives:
                                          state.upcomingIncentives);
                                }
                                return Center(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .selectDateForIncentives,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              },
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .incentiveEmptyText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              )));
        }),
      ),
    );
  }
}
