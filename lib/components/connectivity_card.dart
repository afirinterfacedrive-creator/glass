import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/glass_enums.dart';
import '../theme/glass_effects.dart';

import '../components/glass_button.dart';
import '../components/icon_glass_bubble.dart';
import '../provider/glass_button_provider.dart';

class ConnectivityCard extends ConsumerStatefulWidget {
  final GlassEffects effects;
  final GlassShapeType shape;
  final GlassStyle style;

  const ConnectivityCard({
    super.key,
    required this.effects,
    required this.shape,
    required this.style,
  });

  @override
  ConsumerState<ConnectivityCard> createState() => _ConnectivityCardState();
}

class _ConnectivityCardState extends ConsumerState<ConnectivityCard> {
  // ============================================================
  // IDENTIFIANTS UNIQUES
  // ============================================================

  static const String airplaneId = 'connectivity_airplane';
  static const String dataId = 'connectivity_data';
  static const String wifiId = 'connectivity_wifi';
  static const String bluetoothId = 'connectivity_bluetooth';

  @override
  void initState() {
    super.initState();

    // Initialisation des boutons après la création du widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(glassButtonProvider.notifier);

      notifier.initButton(airplaneId, false);
      notifier.initButton(dataId, false);
      notifier.initButton(wifiId, false);
      notifier.initButton(bluetoothId, false);
    });
  }

  // ============================================================
  // BOUTON
  // ============================================================

  Widget _buildConnectivityButton({
    required String id,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    final buttonState = ref.watch(
      glassButtonProvider.select((state) => state[id]),
    );

    final bool isActive = buttonState?.isActive ?? false;

    return Tooltip(
      message: label,
      child: IconGlassBubble(
        icon: icon,
        baseColor: color,
        isActive: isActive,
        onTap: () {
          ref.read(glassButtonProvider.notifier).toggleActive(id);

          debugPrint('$label: ${!isActive}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      width: 160,
      height: 160,
      shape: widget.shape,
      effects: widget.effects,
      style: widget.style,
      onTap: () {},

      child: GridView.count(
        crossAxisCount: 2,

        padding: const EdgeInsets.all(16),

        mainAxisSpacing: 14,
        crossAxisSpacing: 14,

        physics: const NeverScrollableScrollPhysics(),

        children: [
          // ======================================================
          // MODE AVION
          // ======================================================
          _buildConnectivityButton(
            id: airplaneId,
            icon: Icons.flight,
            color: Colors.blue.shade600,
            label: 'Mode avion',
          ),

          // ======================================================
          // DONNÉES MOBILES
          // ======================================================
          _buildConnectivityButton(
            id: dataId,
            icon: Icons.swap_calls,
            color: Colors.redAccent.shade400,
            label: 'Données mobiles',
          ),

          // ======================================================
          // WI-FI
          // ======================================================
          _buildConnectivityButton(
            id: wifiId,
            icon: Icons.wifi,
            color: Colors.teal.shade400,
            label: 'Wi-Fi',
          ),

          // ======================================================
          // BLUETOOTH
          // ======================================================
          _buildConnectivityButton(
            id: bluetoothId,
            icon: Icons.bluetooth,
            color: Colors.amber.shade700,
            label: 'Bluetooth',
          ),
        ],
      ),
    );
  }
}
