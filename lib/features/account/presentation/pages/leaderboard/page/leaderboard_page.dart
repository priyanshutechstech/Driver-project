import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_arguments.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/app_images.dart';
import 'package:restart_tagxi/common/local_data.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/core/utils/extensions.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../../../core/utils/custom_header.dart';
import '../../../../../auth/presentation/pages/login_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/notification/page/notification_page.dart';

class LeaderboardPage extends StatelessWidget {
  static const String routeName = '/leaderboardPage';
  final LeaderBoardArguments? args;
  const LeaderboardPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()..add(GetLeaderBoardEvent(type: 0)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is LeaderBoardLoadingStartState) {
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
          if (state is ShowErrorState) {
            context.showSnackBar(color: AppColors.red, message: state.message);
          }

          if (state is LeaderBoardLoadingStopState) {
            CustomLoader.dismiss(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Scaffold(
              appBar: CustomHeader(
                title: AppLocalizations.of(context)!.leaderboard,
                automaticallyImplyLeading: false,
                titleFontSize: 18,
                textColor: Theme.of(context).primaryColorDark,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NotificationPage.routeName,
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          height: 240,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child:
                              context.read<AccBloc>().leaderBoardData != null &&
                                      context
                                          .read<AccBloc>()
                                          .leaderBoardData!
                                          .isNotEmpty
                                  ? ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: context
                                          .read<AccBloc>()
                                          .leaderBoardData!
                                          .length,
                                      itemBuilder: (context, index) {
                                        final driver = context
                                            .read<AccBloc>()
                                            .leaderBoardData![index];

                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(driver.profile),
                                          ),
                                          title: Text(driver.driverName),
                                          subtitle: Text(
                                            context
                                                        .read<AccBloc>()
                                                        .choosenLeaderboardData ==
                                                    0
                                                ? "${userData!.currencySymbol} ${driver.commission}"
                                                : "${driver.trips} Trips",
                                          ),
                                          trailing: Text(
                                            "#${index + 1}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Text(
                                        "No Rankings Available",
                                      ),
                                    ),
                        ),
                      ),
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
