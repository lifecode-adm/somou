/// Como a lista é usada: montada durante a compra (padrão) ou antes dela.
enum ListMode {
  shopping('shopping'),
  planning('planning');

  const ListMode(this.dbValue);

  final String dbValue;

  static ListMode fromDb(String value) =>
      values.firstWhere((mode) => mode.dbValue == value);
}
