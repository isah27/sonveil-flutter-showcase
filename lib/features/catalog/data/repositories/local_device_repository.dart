import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

/// Fictional catalogue. Every name, price and spec is invented.
class LocalDeviceRepository implements DeviceRepository {
  const LocalDeviceRepository();

  static const List<Device> _devices = <Device>[
    Device(
      id: 'halo-one',
      name: 'Halo One',
      kind: DeviceKind.overEar,
      tagline: 'Over-ear. Silence, sculpted.',
      asset: 'assets/products/halo_one.webp',
      price: r'$449',
      battery: '60 h',
      layers: <DeviceLayer>[
        DeviceLayer(
          name: 'Titanium shell',
          spec: 'Brushed, 0.6 mm',
          widthFactor: 0.62,
          depth: 16,
        ),
        DeviceLayer(
          name: 'Mic array',
          spec: '6 mics, beamforming',
          widthFactor: 0.56,
          depth: 6,
        ),
        DeviceLayer(
          name: 'Battery',
          spec: '60 h playback',
          widthFactor: 0.46,
          depth: 12,
        ),
        DeviceLayer(
          name: 'Driver',
          spec: '40 mm beryllium',
          widthFactor: 0.52,
          depth: 10,
        ),
        DeviceLayer(
          name: 'Acoustic mesh',
          spec: 'Tuned damping',
          widthFactor: 0.58,
          depth: 4,
        ),
        DeviceLayer(
          name: 'Memory cushion',
          spec: 'Protein leather',
          widthFactor: 0.66,
          depth: 18,
        ),
      ],
    ),
    Device(
      id: 'drift-buds',
      name: 'Drift Buds',
      kind: DeviceKind.earbuds,
      tagline: 'In-ear. Made to move.',
      asset: 'assets/products/drift_buds.webp',
      price: r'$229',
      battery: '9 h + 27 h case',
      layers: <DeviceLayer>[
        DeviceLayer(
          name: 'Touch cap',
          spec: 'Sweat-proof glass',
          widthFactor: 0.40,
          depth: 10,
        ),
        DeviceLayer(
          name: 'Motion sensor',
          spec: 'Head tracking',
          widthFactor: 0.30,
          depth: 5,
        ),
        DeviceLayer(
          name: 'Cell',
          spec: '9 h playback',
          widthFactor: 0.34,
          depth: 12,
        ),
        DeviceLayer(
          name: 'Driver',
          spec: '11 mm dynamic',
          widthFactor: 0.38,
          depth: 8,
        ),
        DeviceLayer(
          name: 'Ear tip',
          spec: 'Foam-core silicone',
          widthFactor: 0.32,
          depth: 14,
        ),
      ],
    ),
    Device(
      id: 'orbit',
      name: 'Orbit',
      kind: DeviceKind.speaker,
      tagline: 'Room speaker. Sound that fills.',
      asset: 'assets/products/orbit_speaker.webp',
      price: r'$349',
      battery: 'Mains + 12 h',
      layers: <DeviceLayer>[
        DeviceLayer(
          name: 'Halo ring',
          spec: 'Ambient light',
          widthFactor: 0.66,
          depth: 6,
        ),
        DeviceLayer(
          name: 'Touch top',
          spec: 'Glass, 4 gestures',
          widthFactor: 0.62,
          depth: 8,
        ),
        DeviceLayer(
          name: 'Tweeters',
          spec: '3 × 20 mm',
          widthFactor: 0.56,
          depth: 10,
        ),
        DeviceLayer(
          name: 'Woofer',
          spec: '100 mm long-throw',
          widthFactor: 0.64,
          depth: 22,
        ),
        DeviceLayer(
          name: 'Knit sleeve',
          spec: 'Recycled yarn',
          widthFactor: 0.70,
          depth: 8,
        ),
      ],
    ),
  ];

  @override
  List<Device> all() => _devices;
}
