import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/language_bloc.dart';
import '../../domain/models/language_listing_model.dart';

class LanguageListWidget extends StatelessWidget {
  final BuildContext cont;
  final List<LocaleLanguageList> languageList;
  const LanguageListWidget(
      {super.key, required this.cont, required this.languageList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<LanguageBloc>(),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return SizedBox(
            height: size.height * 0.65,
            child: RawScrollbar(
              radius: const Radius.circular(20),
              child: ListView.builder(
                itemCount: languageList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 8),
                    child: InkWell(
                        onTap: () {
                          context.read<LanguageBloc>().add(LanguageSelectEvent(
                              selectedLanguageIndex: index));
                          context.read<LocalizationBloc>().add(
                              LocalizationInitialEvent(
                                  isDark: Theme.of(context).brightness ==
                                      Brightness.dark,
                                  locale: Locale(languageList[index].lang)));
                        },
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  (context.read<LanguageBloc>().selectedIndex ==
                                          index)
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: MyText(
                                  text: languageList[index].name,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                ),
                              ),
                              Radio<int>(
                                value: index,
                                groupValue:
                                    context.read<LanguageBloc>().selectedIndex,
                                activeColor: AppColors.primary,
                                onChanged: (value) {
                                  context.read<LanguageBloc>().add(
                                      LanguageSelectEvent(
                                          selectedLanguageIndex: value!));

                                  context.read<LocalizationBloc>().add(
                                        LocalizationInitialEvent(
                                          isDark:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark,
                                          locale: Locale(
                                            languageList[value].lang,
                                          ),
                                        ),
                                      );
                                },
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
