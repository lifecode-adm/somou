/// Unidades aceitas por um item (CHECK da coluna `unit`).
enum Unit {
  un('un'),
  pct('pct'),
  kg('kg'),
  g('g'),
  liter('L'),
  ml('ml');

  const Unit(this.symbol);

  /// Texto exibido e salvo no banco.
  final String symbol;

  /// RN06: un e pct somam a quantidade; peso e volume contam como 1 produto.
  bool get countsQuantity => this == un || this == pct;

  static Unit fromDb(String value) =>
      values.firstWhere((unit) => unit.symbol == value);
}
