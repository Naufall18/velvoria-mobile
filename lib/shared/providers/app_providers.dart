import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Theme Mode Provider ──────────────────────────────────────────────
final themeModeProvider = StateProvider<bool>((ref) => false); // false = light

// ── Bottom Navigation Index ──────────────────────────────────────────
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ── Connectivity Provider ────────────────────────────────────────────
final isOnlineProvider = StateProvider<bool>((ref) => true);
