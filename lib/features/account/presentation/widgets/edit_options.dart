import 'package:flutter/material.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';

class EditOptions extends StatelessWidget {
  final String text;
  final String header;
  final Function()? onTap;
  final Icon? icon;
  final String? imagePath;
  final bool? showUnderLine;
  final bool? showEditIcon;

  const EditOptions(
      {super.key,
      required this.text,
      required this.header,
      required this.onTap,
      this.icon,
      this.imagePath,
      this.showUnderLine,
      this.showEditIcon});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: header == 'Name'
                          ? const Color(0xFFEAE6FF)
                          : header == 'Mobile'
                              ? const Color(0xFFDDF8DD)
                              : const Color(0xFFFFE8D8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                        color: header == 'Name'
                            ? Colors.indigo
                            : header == 'Mobile'
                                ? Colors.green
                                : Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.025,
                  ),
                  SizedBox(
                    width: size.width * 0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: header,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontSize: 15,
                                  color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: 2),
                        MyText(
                          text: text,
                          textStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              (showEditIcon == true)
                  ? MyText(
                      text: AppLocalizations.of(context)!.edit,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (showUnderLine == true)
          const Divider(
            height: 1,
            color: Color(0xFFD9D9D9),
          ),
        const SizedBox(height: 25),
      ],
    );
  }
}
