import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/catalog/data/repositories/local_device_repository.dart';
import 'features/catalog/domain/repositories/device_repository.dart';
import 'features/listener/presentation/cubit/listener_cubit.dart';

class SonveilApp extends StatelessWidget {
  const SonveilApp({this.devices = const LocalDeviceRepository(), super.key});

  final DeviceRepository devices;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DeviceRepository>.value(
      value: devices,
      child: BlocProvider<ListenerCubit>(
        create: (_) => ListenerCubit(),
        child: MaterialApp(
          title: 'SONVEIL',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          initialRoute: AppRoutes.onboarding,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
