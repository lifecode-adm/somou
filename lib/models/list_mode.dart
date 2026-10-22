/// Como a lista é usada: montada antes da compra ou durante ela.
enum ListMode {
  planning('planning', 'Planejamento'),
  shopping('shopping', 'Em compra');

  const ListMode(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static ListMode fromDb(String value) =>
      values.firstWhere((mode) => mode.dbValue == value);
}
