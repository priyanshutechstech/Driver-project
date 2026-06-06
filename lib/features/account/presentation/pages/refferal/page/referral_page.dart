import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restart_tagxi/common/app_constants.dart';
import 'package:restart_tagxi/core/utils/custom_header.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../auth/application/auth_bloc.dart';
import '../../../../application/acc_bloc.dart';

class ReferralPage extends StatefulWidget {
  final ReferralArguments args;

  static const String routeName = '/ReferralPage';

  const ReferralPage({super.key, required this.args});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool showReferralHistory = false;

  Future<void> _copyReferralCode() async {
    await Clipboard.setData(
      ClipboardData(text: widget.args.userData.refferalCode),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral code copied!')),
    );
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return '';
    final normalized = status.toLowerCase();
    return normalized[0].toUpperCase() + normalized.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) {
        final bloc = AccBloc();
        bloc.add(AccGetDirectionEvent());
        bloc.add(ReferralResponseEvent());
        return bloc;
      },
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomHeader(
                      title: widget.args.title,
                      automaticallyImplyLeading: true,
                      titleFontSize: 18,
                      textColor: Theme.of(context).primaryColorDark,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF07128F), Color(0xFF1B2CFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Refer a friend and earn ₹30',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Share your invite code and grow your earnings together.',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 14),
                            DottedBorder(
                              color: Colors.white24,
                              strokeWidth: 1,
                              dashPattern: const [6, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.args.userData.refferalCode,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _copyReferralCode,
                                      icon: const Icon(Icons.copy,
                                          color: Colors.white),
                                      tooltip: 'Copy code',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.05, right: size.width * 0.05),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.borderColors,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(size.width * 0.0125),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<AccBloc>().add(
                                      ReferralTabChangeEvent(
                                          showReferralHistory: false));
                                },
                                child: Container(
                                  width: size.width * 0.425,
                                  padding: EdgeInsets.all(size.width * 0.025),
                                  decoration: BoxDecoration(
                                    color: !context
                                            .watch<AccBloc>()
                                            .showReferralHistory
                                        ? AppColors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .referAndEarn,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontSize: (choosenLanguage ==
                                                        'fr' ||
                                                    choosenLanguage == 'az' ||
                                                    choosenLanguage == 'es' ||
                                                    choosenLanguage == 'sq')
                                                ? 12
                                                : 16,
                                            color: !context
                                                    .watch<AccBloc>()
                                                    .showReferralHistory
                                                ? AppColors.hintColorGrey
                                                : AppColors.hintColor),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.read<AccBloc>().add(
                                      ReferralTabChangeEvent(
                                          showReferralHistory: true));
                                  context
                                      .read<AccBloc>()
                                      .add(ReferalHistoryEvent());
                                },
                                child: Container(
                                  width: size.width * 0.425,
                                  padding: EdgeInsets.all(size.width * 0.025),
                                  decoration: BoxDecoration(
                                    color: context
                                            .watch<AccBloc>()
                                            .showReferralHistory
                                        ? AppColors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .referralHistory,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontSize: (choosenLanguage ==
                                                        'fr' ||
                                                    choosenLanguage == 'az' ||
                                                    choosenLanguage == 'es' ||
                                                    choosenLanguage == 'sq')
                                                ? 12
                                                : 16,
                                            color: context
                                                    .watch<AccBloc>()
                                                    .showReferralHistory
                                                ? AppColors.hintColorGrey
                                                : AppColors.hintColor),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: size.width * 0.05),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Builder(
                          builder: (context) {
                            final bloc = context.watch<AccBloc>();
                            if (bloc.showReferralHistory) {
                              if (state is ReferalHistoryLoadingState) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              // Render history whenever data is available
                              if (state is ReferalHistorySuccessState) {
                                final historyList = bloc.referralHistory;

                                if (historyList.isNotEmpty) {
                                  return ListView.separated(
                                    itemCount: historyList.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: size.width * 0.025),
                                    itemBuilder: (context, index) {
                                      final item = historyList[index];
                                      return Container(
                                        padding:
                                            EdgeInsets.all(size.width * 0.035),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: AppColors.borderColors),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Name
                                                MyText(
                                                  text: item.name,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .hintColorGrey,
                                                      ),
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.01),
                                                // Date
                                                MyText(
                                                  text: item.createdAt
                                                      .split(' ')
                                                      .first,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 13,
                                                        color:
                                                            AppColors.hintColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      AppImages.referGift,
                                                      height: size.width * 0.05,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * 0.015),
                                                    MyText(
                                                      text:
                                                          '${item.currencySymbol}${item.earning}',
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .hintColorGrey,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.01),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.02,
                                                    vertical: size.width * 0.01,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.borderColors,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: MyText(
                                                    text: _formatStatus(
                                                        item.referralStatus),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color: AppColors
                                                              .hintColorGrey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              }

                              // Empty state for referral history
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImages.referal,
                                      height: 180,
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'No Referrals Yet!',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Start inviting your friends to see your progress and earnings here.',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    OutlinedButton(
                                      onPressed: () {
                                        context.read<AccBloc>().add(
                                              ReferralTabChangeEvent(
                                                showReferralHistory: false,
                                              ),
                                            );
                                      },
                                      child: const Text(
                                        'Start Inviting',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // Show "Refer and Earn" tab content
                            if (state is ReferralResponseLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final referralResponse = bloc.referralResponse;
                            if (referralResponse == null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.referal,
                                    height: size.width * 0.65,
                                  ),
                                  SizedBox(height: size.width * 0.025),
                                  Center(
                                    child: MyText(
                                      text:
                                          'Referral content is unavailable. Please try again later.',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppColors.hintColor,
                                          ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            final referralHtml = referralResponse
                                .data.referralContent.data.description;

                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'How it works',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (referralHtml.trim().isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryLight,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                            color: AppColors.borderColors),
                                      ),
                                      child: Html(
                                        data: referralHtml,
                                        shrinkWrap: true,
                                        style: {
                                          'body': Style(
                                            margin: Margins.zero,
                                            padding: HtmlPaddings.zero,
                                            color: AppColors.hintColorGrey,
                                            fontSize: FontSize(14),
                                          ),
                                        },
                                      ),
                                    )
                                  else
                                    _stepCard(
                                      '1',
                                      'Share your code',
                                      'Send your unique referral code to fellow drivers.',
                                    ),
                                  const SizedBox(height: 12),
                                  _stepCard(
                                    '1',
                                    'Share your code',
                                    'Send your unique referral code to fellow drivers.',
                                  ),
                                  _stepCard(
                                    '2',
                                    'Friend signs up',
                                    'They register using your referral code.',
                                  ),
                                  _stepCard(
                                    '3',
                                    'Earn Rewards',
                                    'Get ₹30 after completing referral requirements.',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: CustomButton(
                          buttonColor: AppColors.primary,
                          buttonName: AppLocalizations.of(context)!.invite,
                          width: size.width,
                          onTap: () async {
                            String androidUrl = widget.args.userData.androidApp;
                            String iosUrl = widget.args.userData.iosApp;

                            if (!context.mounted) return;
                            await Share.share(
                                "${AppLocalizations.of(context)!.referalShareOne.replaceAll('222', widget.args.userData.refferalCode).replaceAll('111', AppConstants.title)}\n$androidUrl \n$iosUrl");
                          }),
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

Widget _stepCard(
  String number,
  String title,
  String subtitle,
) {
  return Container(
    margin: const EdgeInsets.only(
      bottom: 12,
    ),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFFEAEAEA),
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 14,
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
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
