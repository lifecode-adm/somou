/// Como a lista é usada: montada durante a compra (padrão) ou antes dela.
enum ListMode {
  shopping('shopping', 'Em compra'),
  planning('planning', 'Planejamento');

  const ListMode(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static ListMode fromDb(String value) =>
      values.firstWhere((mode) => mode.dbValue == value);
}
