import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/core/utils/custom_appbar.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../application/acc_bloc.dart';
import '../widget/chat_history_widget.dart';

class AdminChat extends StatelessWidget {
  static const String routeName = '/adminchat';

  const AdminChat({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetUserDetailsEvent())
        ..add(GetAdminChatHistoryListEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.adminChat,
              automaticallyImplyLeading: true,
              titleFontSize: 18,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      controller: context.read<AccBloc>().scroolController,
                      child: Column(
                        children: [
                          AdminChatHistoryWidget(
                              cont: context,
                              adminChatList:
                                  context.read<AccBloc>().adminChatList),
                        ],
                      ),
                    )),
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: context.read<AccBloc>().adminchatText,
                              minLines: 1,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message...',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (context
                                  .read<AccBloc>()
                                  .adminchatText
                                  .text
                                  .isNotEmpty) {
                                context.read<AccBloc>().add(
                                      SendAdminMessageEvent(
                                        newChat: context
                                                .read<AccBloc>()
                                                .adminChatList
                                                .isEmpty
                                            ? '0'
                                            : '1',
                                        message: context
                                            .read<AccBloc>()
                                            .adminchatText
                                            .text,
                                        chatId: context
                                                .read<AccBloc>()
                                                .adminChatList
                                                .isEmpty
                                            ? ""
                                            : context
                                                .read<AccBloc>()
                                                .adminChatList[0]
                                                .conversationId,
                                      ),
                                    );

                                context.read<AccBloc>().adminchatText.clear();
                              }
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Color(0xFF07128F),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    )
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
