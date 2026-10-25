import 'package:equatable/equatable.dart';

import '../../../catalog/domain/entities/device.dart';

class HomeBriefing extends Equatable {
  const HomeBriefing({
    required this.greeting,
    required this.headline,
    required this.reason,
    required this.pick,
    required this.others,
  });

  final String greeting;
  final String headline;
  final String reason;
  final Device pick;
  final List<Device> others;

  @override
  List<Object?> get props => <Object?>[
    greeting,
    headline,
    reason,
    pick,
    others,
  ];
}
