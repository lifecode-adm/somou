import 'package:flutter/material.dart';

import '../models/list_totals.dart';

/// Cores da paleta Feira fresca que o ColorScheme não cobre.
@immutable
class SomouColors extends ThemeExtension<SomouColors> {
  const SomouColors({
    required this.header,
    required this.onHeader,
    required this.onHeaderMuted,
    required this.primarySoft,
    required this.primaryContainer,
    required this.accent,
    required this.onAccent,
    required this.textMuted,
    required this.border,
    required this.metricBackground,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.danger,
    required this.dangerContainer,
    required this.shoppingChip,
    required this.onShoppingChip,
    required this.checkboxBorder,
  });

  static const light = SomouColors(
    header: Color(0xFF1F7A45),
    onHeader: Color(0xFFFFFFFF),
    onHeaderMuted: Color(0xFFCFE8D9),
    primarySoft: Color(0xFF2E9E5B),
    primaryContainer: Color(0xFFE6F4EC),
    accent: Color(0xFFFF7A30),
    onAccent: Color(0xFF3A1A05),
    textMuted: Color(0xFF6B7A71),
    border: Color(0xFFE3E8E4),
    metricBackground: Color(0xFFF6F8F6),
    warning: Color(0xFFF2B705),
    warningContainer: Color(0xFFFFF4D1),
    onWarningContainer: Color(0xFF7A5A00),
    danger: Color(0xFFD64045),
    dangerContainer: Color(0xFFFBE3E4),
    shoppingChip: Color(0xFFFFE9DC),
    onShoppingChip: Color(0xFF8A3A0E),
    checkboxBorder: Color(0xFFA9B5AE),
  );

  static const dark = SomouColors(
    header: Color(0xFF1A3324),
    onHeader: Color(0xFFECF2EE),
    onHeaderMuted: Color(0xFF9DAAA2),
    primarySoft: Color(0xFF2E9E5B),
    primaryContainer: Color(0xFF1A3324),
    accent: Color(0xFFFF8F4F),
    onAccent: Color(0xFF3A1A05),
    textMuted: Color(0xFF9DAAA2),
    border: Color(0xFF2A332E),
    metricBackground: Color(0xFF232B26),
    warning: Color(0xFFF2B705),
    warningContainer: Color(0xFF3A3112),
    onWarningContainer: Color(0xFFF2D266),
    danger: Color(0xFFFF6B6F),
    dangerContainer: Color(0xFF3A1E20),
    shoppingChip: Color(0xFF3A2516),
    onShoppingChip: Color(0xFFFFB98F),
    checkboxBorder: Color(0xFF5E6B63),
  );

  final Color header;
  final Color onHeader;
  final Color onHeaderMuted;
  final Color primarySoft;
  final Color primaryContainer;
  final Color accent;
  final Color onAccent;
  final Color textMuted;
  final Color border;
  final Color metricBackground;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color danger;
  final Color dangerContainer;
  final Color shoppingChip;
  final Color onShoppingChip;
  final Color checkboxBorder;

  /// RN09: cor da barra conforme o uso do orçamento.
  Color budgetColor(BudgetLevel level) => switch (level) {
    BudgetLevel.ok => primarySoft,
    BudgetLevel.warning => warning,
    BudgetLevel.over => danger,
  };

  @override
  SomouColors copyWith() => this;

  @override
  SomouColors lerp(SomouColors? other, double t) =>
      other != null && t >= 0.5 ? other : this;
}

extension SomouThemeContext on BuildContext {
  SomouColors get colors => Theme.of(this).extension<SomouColors>()!;
}

ThemeData buildTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final colors = isLight ? SomouColors.light : SomouColors.dark;
  final primary = isLight ? const Color(0xFF1F7A45) : const Color(0xFF4CC27E);
  final surface = isLight ? Colors.white : const Color(0xFF1C231F);
  final outline = isLight ? const Color(0xFFCBD3CE) : const Color(0xFF3A453F);

  final scheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF1F7A45),
        brightness: brightness,
      ).copyWith(
        primary: primary,
        onPrimary: isLight ? Colors.white : const Color(0xFF0E2418),
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: primary,
        secondary: colors.accent,
        onSecondary: colors.onAccent,
        error: colors.danger,
        surface: surface,
        onSurface: isLight ? const Color(0xFF1F2A24) : const Color(0xFFECF2EE),
        onSurfaceVariant: colors.textMuted,
        outline: outline,
        outlineVariant: colors.border,
      );

  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: isLight
        ? const Color(0xFFFFF9F2)
        : const Color(0xFF121714),
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: colors.header,
      foregroundColor: colors.onHeader,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: inputBorder(outline),
      enabledBorder: inputBorder(outline),
      focusedBorder: inputBorder(primary, 2),
      hintStyle: TextStyle(color: colors.textMuted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.accent,
      foregroundColor: colors.onAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      extendedTextStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: isLight
          ? const Color(0xFFD3D9D5)
          : const Color(0xFF3A453F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: BorderSide(color: colors.checkboxBorder, width: 2),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
