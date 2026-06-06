// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_arguments.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/app_images.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
// import 'package:restart_tagxi/core/utils/custom_button.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/vehicle_info/widget/vehicle_owner_shimmer.dart';
import 'package:restart_tagxi/features/driverprofile/presentation/pages/driver_profile_pages.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../widget/assigned_drivers_widget.dart';
import '../widget/fleet_vehicle_details.dart';

class VehicleDataPage extends StatefulWidget {
  static const String routeName = '/vehicleInformation';
  final VehicleDataArguments? args;

  const VehicleDataPage({super.key, this.args});

  @override
  State<VehicleDataPage> createState() => _VehicleDataPageState();
}

class _VehicleDataPageState extends State<VehicleDataPage> {
  Color _parseCarColor(String? value) {
    final colorValue = (value ?? '').trim();
    if (colorValue.isEmpty) return AppColors.primary;

    try {
      final normalized =
          colorValue.startsWith('#') ? colorValue.substring(1) : colorValue;
      final hex = normalized.startsWith('0x') || normalized.startsWith('0X')
          ? normalized
          : '0xFF$normalized';
      return Color(int.parse(hex));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return BlocProvider(
        create: (context) => AccBloc()..add(GetVehiclesEvent()),
        child: BlocListener<AccBloc, AccState>(listener: (context, state) {
          if (state is VehiclesLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is VehiclesLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is ShowAssignDriverState) {
            if (context.read<AccBloc>().driverData.isNotEmpty) {
              showModalBottomSheet(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  context: context,
                  builder: (_) {
                    return AssignedDriversWidget(cont: context);
                  });
            } else {
              showModalBottomSheet(
                  backgroundColor: AppColors.white,
                  context: context,
                  builder: (builder) {
                    return Container(
                        height: size.height * 0.3,
                        width: size.width,
                        padding: EdgeInsets.all(size.width * 0.05),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                        ),
                        child: Center(
                          child: MyText(
                            text:
                                AppLocalizations.of(context)!.noDriverAvailable,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.red),
                            maxLines: 5,
                          ),
                        ));
                  });
            }
          }
        }, child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.vehicleInfo,
              automaticallyImplyLeading: true,
              titleFontSize: 18,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.width * 0.05,
                          ),
                          (userData!.role == 'driver')
                              ? (userData!.vehicleTypeName != '')
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 180,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/car_banner.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 12,
                                                  bottom: 42,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF9BF28A),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.verified,
                                                            size: 14,
                                                            color:
                                                                Colors.green),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          'Verified Vehicle',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 12,
                                                  bottom: 12,
                                                  child: Text(
                                                    '${userData!.carMake} ${userData!.carModel}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .vehicleType,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: size.width * 0.025,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFE5E5E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.category_outlined,
                                                      size: 22,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        userData!
                                                            .vehicleTypeName,
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

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .vehicleMake,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: size.width * 0.025,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFE5E5E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.assignment_outlined,
                                                      size: 22,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        userData!.carMake,
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

                                          // vehicle model
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .vehicleModel,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: size.width * 0.025,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFE5E5E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .directions_car_filled_outlined,
                                                      size: 22,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        userData!.carModel,
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

                                          // vehicle number
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .vehicleNumber,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: size.width * 0.025,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFE5E5E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.badge_outlined,
                                                      size: 22,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                        child: MyText(
                                                      text: userData!.carNumber,
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                fontSize: 14,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark,
                                                              ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.width * 0.05,
                                              )
                                            ],
                                          ),

                                          // vehicle color
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .vehicleColor,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: size.width * 0.025,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFE5E5E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.palette_outlined,
                                                      size: 22,
                                                    ),
                                                    
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: MyText(
                                                        text:
                                                            userData!.carColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: size.height * 0.05),
                                          if (userData!.ownerId == null ||
                                              userData!.ownerId == '')
                                            SizedBox(
                                              width: double.infinity,
                                              height: 52,
                                              child: ElevatedButton.icon(
                                                onPressed: () async {
                                                  await Navigator.pushNamed(
                                                    context,
                                                    DriverProfilePage.routeName,
                                                    arguments:
                                                        VehicleUpdateArguments(
                                                      from: 'vehicle',
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.white),
                                                label: const Text(
                                                  'Edit Information',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF07128F),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 14),

                                          const Text(
                                            'Updating vehicle details may require a new document verification for security purposes.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Image.asset(AppImages.historyNoData),
                                        MyText(
                                          text: AppLocalizations.of(context)!
                                              .vehicleNotAssigned,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    )
                              : (context.read<AccBloc>().vehicleData.isEmpty)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.noVehicleInfo,
                                          width: 300,
                                        ),
                                        MyText(
                                          text: AppLocalizations.of(context)!
                                              .noVehicleCreated,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    )
                                  : FleetVehicleDetailsWidget(cont: context)
                        ],
                      ),
                    ),
                  ),
                  if (userData!.role == 'owner')
                    Column(
                      children: [
                        SizedBox(height: size.width * 0.05),
                        if (context.read<AccBloc>().isLoading)
                          VehicleOwnerShimmerWidget.circular(
                              width: size.width, height: size.height),
                        if (!context.read<AccBloc>().isLoading)
                          SizedBox(
                            width: size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var nav = await Navigator.pushNamed(
                                        context, DriverProfilePage.routeName,
                                        arguments: VehicleUpdateArguments(
                                            from: 'owner'));
                                    if (nav != null && nav == true) {
                                      if (!context.mounted) return;
                                      context
                                          .read<AccBloc>()
                                          .add(GetVehiclesEvent());
                                    }
                                  },
                                  child: Container(
                                    width: size.width * 0.128,
                                    height: size.width * 0.128,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: size.width * 0.075,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  SizedBox(height: size.width * 0.05)
                ],
              ),
            ),
          );
        })));
  }
}
