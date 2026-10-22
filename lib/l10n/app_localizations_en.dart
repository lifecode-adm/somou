// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Shopping list with a running total';

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get undo => 'Undo';

  @override
  String get remove => 'Remove';

  @override
  String get yourLists => 'Your lists';

  @override
  String get newList => 'New list';

  @override
  String get listDuplicated => 'List duplicated.';

  @override
  String get emptyHomeTitle => 'No lists yet';

  @override
  String get emptyHomeMessage =>
      'Tap \"New list\" and watch the total grow with each item.';

  @override
  String get listNotFound => 'List not found.';

  @override
  String get shareOnWhatsApp => 'Share on WhatsApp';

  @override
  String get addItemButton => 'Item';

  @override
  String get emptyListMessage => 'No items yet. Tap \"Item\" to add one.';

  @override
  String itemRemoved(String name) {
    return '\"$name\" removed.';
  }

  @override
  String get picked => 'In the cart';

  @override
  String get deleteListTitle => 'Delete list?';

  @override
  String deleteListMessage(String name) {
    return '\"$name\" and all its items will be deleted. This can\'t be undone.';
  }

  @override
  String get whatsAppError => 'Couldn\'t open WhatsApp.';

  @override
  String get editList => 'Edit list';

  @override
  String get listName => 'List name';

  @override
  String get listNameHint => 'E.g. Monthly groceries';

  @override
  String get storeOptional => 'Store (optional)';

  @override
  String get budgetOptional => 'Budget (optional)';

  @override
  String get modeQuestion => 'How will you use this list?';

  @override
  String get modeShoppingOption => 'I\'m shopping now';

  @override
  String get modeShoppingDescription => 'Each item goes straight into the cart';

  @override
  String get modePlanningOption => 'I\'ll plan ahead';

  @override
  String get modePlanningDescription =>
      'Build it first and check items off at the store';

  @override
  String get createList => 'Create list';

  @override
  String get addItem => 'Add item';

  @override
  String get editItem => 'Edit item';

  @override
  String get product => 'Product';

  @override
  String get productHint => 'E.g. Whole milk';

  @override
  String get filledFromHistory => 'Filled in from your last purchase';

  @override
  String get brandOptional => 'Brand (optional)';

  @override
  String get brandHint => 'E.g. Horizon';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'Unit';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get add => 'Add';

  @override
  String get modeShopping => 'Shopping';

  @override
  String get modePlanning => 'Planning';

  @override
  String get unitPiece => 'pc';

  @override
  String get unitPackage => 'pkg';

  @override
  String get listTotal => 'List total';

  @override
  String get inCart => 'in the cart';

  @override
  String pickedCount(int count) {
    return '$count in the cart';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String itemsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$_temp0';
  }

  @override
  String productsLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'products',
      one: 'product',
    );
    return '$_temp0';
  }

  @override
  String get noStore => 'No store';

  @override
  String budgetPercent(int percent) {
    return '$percent% of budget';
  }

  @override
  String get overBudget => 'Over budget';

  @override
  String budgetOf(String label, String budget) {
    return '$label of $budget';
  }

  @override
  String budgetExceeded(String amount) {
    return '$amount over budget';
  }

  @override
  String defaultListName(String date) {
    return 'List $date';
  }

  @override
  String copyOf(String name) {
    return 'Copy of $name';
  }

  @override
  String get unnamedItem => 'Unnamed item';

  @override
  String shareSummary(int items, String products) {
    return 'Items: $items · Products: $products';
  }

  @override
  String shareTotal(String total) {
    return 'Total: $total';
  }
}
