import 'package:equatable/equatable.dart';

enum DeviceKind { overEar, earbuds, speaker }

/// One internal part, drawn by the X-Ray painter.
class DeviceLayer extends Equatable {
  const DeviceLayer({
    required this.name,
    required this.spec,
    required this.widthFactor,
    required this.depth,
  });

  final String name;
  final String spec;

  /// Width of the layer relative to the stage, 0–1.
  final double widthFactor;

  /// Thickness of the disc, in logical pixels.
  final double depth;

  @override
  List<Object?> get props => <Object?>[name, spec, widthFactor, depth];
}

class Device extends Equatable {
  const Device({
    required this.id,
    required this.name,
    required this.kind,
    required this.tagline,
    required this.asset,
    required this.price,
    required this.battery,
    required this.layers,
  });

  final String id;
  final String name;
  final DeviceKind kind;
  final String tagline;
  final String asset;
  final String price;
  final String battery;
  final List<DeviceLayer> layers;

  @override
  List<Object?> get props => <Object?>[id];
}
