import 'package:flutter/widgets.dart';

import '../models/list_mode.dart';
import '../models/list_totals.dart';
import '../models/unit.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Português para qualquer variante de pt; inglês para todo o resto.
Locale resolveAppLocale(Locale? device) =>
    device?.languageCode == 'pt' ? const Locale('pt') : const Locale('en');

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension ListModeL10n on ListMode {
  String label(AppLocalizations l10n) => switch (this) {
    ListMode.shopping => l10n.modeShopping,
    ListMode.planning => l10n.modePlanning,
  };
}

extension BudgetStatusL10n on BudgetStatus {
  /// "82% do orçamento", ou "Acima do orçamento" quando ele é zero.
  String percentLabel(AppLocalizations l10n) => switch (percent) {
    final value? => l10n.budgetPercent(value),
    null => l10n.overBudget,
  };
}

/// O banco guarda o símbolo fixo (`un`, `pct`…); a tela mostra o traduzido.
extension UnitL10n on Unit {
  String label(AppLocalizations l10n) => switch (this) {
    Unit.un => l10n.unitPiece,
    Unit.pct => l10n.unitPackage,
    _ => symbol,
  };
}
