// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTagline => 'Lista de compras com total na hora';

  @override
  String get edit => 'Editar';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get undo => 'Desfazer';

  @override
  String get remove => 'Remover';

  @override
  String get yourLists => 'Suas listas';

  @override
  String get newList => 'Nova lista';

  @override
  String get listDuplicated => 'Lista duplicada.';

  @override
  String get emptyHomeTitle => 'Nenhuma lista ainda';

  @override
  String get emptyHomeMessage =>
      'Toque em \"Nova lista\" e veja o total subir a cada item.';

  @override
  String get listNotFound => 'Lista não encontrada.';

  @override
  String get shareOnWhatsApp => 'Compartilhar no WhatsApp';

  @override
  String get addItemButton => 'Item';

  @override
  String get emptyListMessage =>
      'Nenhum item ainda. Toque em \"Item\" para adicionar.';

  @override
  String itemRemoved(String name) {
    return '\"$name\" removido.';
  }

  @override
  String get picked => 'Já peguei';

  @override
  String get deleteListTitle => 'Excluir lista?';

  @override
  String deleteListMessage(String name) {
    return '\"$name\" e todos os itens dela serão apagados. Não dá para desfazer.';
  }

  @override
  String get whatsAppError => 'Não foi possível abrir o WhatsApp.';

  @override
  String get editList => 'Editar lista';

  @override
  String get listName => 'Nome da lista';

  @override
  String get listNameHint => 'Ex.: Compra do mês';

  @override
  String get storeOptional => 'Supermercado (opcional)';

  @override
  String get budgetOptional => 'Orçamento (opcional)';

  @override
  String get modeQuestion => 'Como você vai usar esta lista?';

  @override
  String get modeShoppingOption => 'Já estou comprando';

  @override
  String get modeShoppingDescription => 'Cada item entra como pego';

  @override
  String get modePlanningOption => 'Vou planejar';

  @override
  String get modePlanningDescription =>
      'Monto antes e marco \"já peguei\" no mercado';

  @override
  String get createList => 'Criar lista';

  @override
  String get addItem => 'Adicionar item';

  @override
  String get editItem => 'Editar item';

  @override
  String get product => 'Produto';

  @override
  String get productHint => 'Ex.: Leite integral';

  @override
  String get filledFromHistory => 'Preenchido com a última compra';

  @override
  String get brandOptional => 'Marca (opcional)';

  @override
  String get brandHint => 'Ex.: Piracanjuba';

  @override
  String get quantity => 'Quantidade';

  @override
  String get unit => 'Unidade';

  @override
  String get unitPrice => 'Valor unitário';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get add => 'Adicionar';

  @override
  String get modeShopping => 'Em compra';

  @override
  String get modePlanning => 'Planejamento';

  @override
  String get unitPiece => 'un';

  @override
  String get unitPackage => 'pct';

  @override
  String get listTotal => 'Total da lista';

  @override
  String get inCart => 'no carrinho';

  @override
  String pickedCount(int count) {
    return '$count no carrinho';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String itemsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'itens',
      one: 'item',
    );
    return '$_temp0';
  }

  @override
  String productsLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'produtos',
      one: 'produto',
    );
    return '$_temp0';
  }

  @override
  String get noStore => 'Sem supermercado';

  @override
  String budgetPercent(int percent) {
    return '$percent% do orçamento';
  }

  @override
  String get overBudget => 'Acima do orçamento';

  @override
  String budgetOf(String label, String budget) {
    return '$label de $budget';
  }

  @override
  String budgetExceeded(String amount) {
    return 'Passou $amount do orçamento';
  }

  @override
  String defaultListName(String date) {
    return 'Lista $date';
  }

  @override
  String copyOf(String name) {
    return 'Cópia de $name';
  }

  @override
  String get unnamedItem => 'Item sem nome';

  @override
  String shareSummary(int items, String products) {
    return 'Itens: $items · Produtos: $products';
  }

  @override
  String shareTotal(String total) {
    return 'Total: $total';
  }
}
