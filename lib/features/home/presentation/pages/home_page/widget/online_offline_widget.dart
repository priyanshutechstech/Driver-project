import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_arguments.dart';
import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/home_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/sos/page/sos_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/notification/page/notification_page.dart';

class OnlineOfflineWidget extends StatelessWidget {
  final BuildContext cont;
  const OnlineOfflineWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return PremiumOnlineOfflineSwitch(
            value: userData!.active,
            onChanged: (value) {
              if (value == false) {
                userData!.active = false;
                context.read<HomeBloc>().add(UpdateEvent());

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext ctx) {
                    return CustomDoubleButtonDialoge(
                      title: AppLocalizations.of(context)!.confirmation,
                      content:
                          AppLocalizations.of(context)!.offlineConfirmation,
                      yesBtnName: AppLocalizations.of(context)!.confirm,
                      noBtnName: AppLocalizations.of(context)!.cancel,
                      yesBtnFunc: () {
                        context
                            .read<HomeBloc>()
                            .add(ChangeOnlineOfflineEvent());
                        Navigator.pop(ctx);
                      },
                      noBtnFunc: () {
                        userData!.active = true;
                        context.read<HomeBloc>().add(UpdateEvent());
                        Navigator.pop(ctx);
                      },
                    );
                  },
                );
              } else {
                userData!.active = value;
                context.read<HomeBloc>().add(ChangeOnlineOfflineEvent());
              }
            },
          );
        },
      ),
    );
  }
}

class PremiumOnlineOfflineSwitch extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;

  const PremiumOnlineOfflineSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<PremiumOnlineOfflineSwitch> createState() =>
      _PremiumOnlineOfflineSwitchState();
}

class _PremiumOnlineOfflineSwitchState
    extends State<PremiumOnlineOfflineSwitch> {
  late bool _currentValue;
  double _dragPosition = 0;

  final double _width = 130;
  final double _height = 40;
  final double _padding = 1;

  double get _thumbSize => _height - (_padding * 2.2);
  double get _maxDrag => _width - _thumbSize - (_padding * 6);

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _dragPosition = _currentValue ? 1 : 0;
  }

  @override
  void didUpdateWidget(covariant PremiumOnlineOfflineSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentValue = widget.value;
    _dragPosition = _currentValue ? 1 : 0;
  }

  void _updateState(bool newValue) {
    setState(() {
      _currentValue = newValue;
      _dragPosition = newValue ? 1 : 0;
    });
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _updateState(!_currentValue);
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            alignment: Alignment.center,
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentValue ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    _currentValue ? 'ONLINE' : 'OFFLINE',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              SosPage.routeName,
              arguments: SOSPageArguments(
                sosData: userData?.sos?.data ?? [],
              ),
            );
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              NotificationPage.routeName,
            );
          },
          child: Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                  size: 22,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
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
        ),
      ],
    );
  }
}
