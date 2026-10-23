import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In pt, this message translates to:
  /// **'Lista de compras com total na hora'**
  String get appTagline;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @duplicate.
  ///
  /// In pt, this message translates to:
  /// **'Duplicar'**
  String get duplicate;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @undo.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer'**
  String get undo;

  /// No description provided for @remove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// No description provided for @yourLists.
  ///
  /// In pt, this message translates to:
  /// **'Suas listas'**
  String get yourLists;

  /// No description provided for @newList.
  ///
  /// In pt, this message translates to:
  /// **'Nova lista'**
  String get newList;

  /// No description provided for @listDuplicated.
  ///
  /// In pt, this message translates to:
  /// **'Lista duplicada.'**
  String get listDuplicated;

  /// No description provided for @emptyHomeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma lista ainda'**
  String get emptyHomeTitle;

  /// No description provided for @emptyHomeMessage.
  ///
  /// In pt, this message translates to:
  /// **'Toque em \"Nova lista\" e veja o total subir a cada item.'**
  String get emptyHomeMessage;

  /// No description provided for @listNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Lista não encontrada.'**
  String get listNotFound;

  /// No description provided for @shareOnWhatsApp.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar no WhatsApp'**
  String get shareOnWhatsApp;

  /// No description provided for @addItemButton.
  ///
  /// In pt, this message translates to:
  /// **'Item'**
  String get addItemButton;

  /// No description provided for @emptyListMessage.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum item ainda. Toque em \"Item\" para adicionar.'**
  String get emptyListMessage;

  /// No description provided for @itemRemoved.
  ///
  /// In pt, this message translates to:
  /// **'\"{name}\" removido.'**
  String itemRemoved(String name);

  /// No description provided for @picked.
  ///
  /// In pt, this message translates to:
  /// **'Já peguei'**
  String get picked;

  /// No description provided for @deleteListTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir lista?'**
  String get deleteListTitle;

  /// No description provided for @deleteListMessage.
  ///
  /// In pt, this message translates to:
  /// **'\"{name}\" e todos os itens dela serão apagados. Não dá para desfazer.'**
  String deleteListMessage(String name);

  /// No description provided for @whatsAppError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir o WhatsApp.'**
  String get whatsAppError;

  /// No description provided for @editList.
  ///
  /// In pt, this message translates to:
  /// **'Editar lista'**
  String get editList;

  /// No description provided for @listName.
  ///
  /// In pt, this message translates to:
  /// **'Nome da lista'**
  String get listName;

  /// No description provided for @listNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Compra do mês'**
  String get listNameHint;

  /// No description provided for @storeOptional.
  ///
  /// In pt, this message translates to:
  /// **'Supermercado (opcional)'**
  String get storeOptional;

  /// No description provided for @budgetOptional.
  ///
  /// In pt, this message translates to:
  /// **'Orçamento (opcional)'**
  String get budgetOptional;

  /// No description provided for @modeQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Como você vai usar esta lista?'**
  String get modeQuestion;

  /// No description provided for @modeShoppingOption.
  ///
  /// In pt, this message translates to:
  /// **'Já estou comprando'**
  String get modeShoppingOption;

  /// No description provided for @modeShoppingDescription.
  ///
  /// In pt, this message translates to:
  /// **'Cada item entra como pego'**
  String get modeShoppingDescription;

  /// No description provided for @modePlanningOption.
  ///
  /// In pt, this message translates to:
  /// **'Vou planejar'**
  String get modePlanningOption;

  /// No description provided for @modePlanningDescription.
  ///
  /// In pt, this message translates to:
  /// **'Monto antes e marco \"já peguei\" no mercado'**
  String get modePlanningDescription;

  /// No description provided for @createList.
  ///
  /// In pt, this message translates to:
  /// **'Criar lista'**
  String get createList;

  /// No description provided for @addItem.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar item'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In pt, this message translates to:
  /// **'Editar item'**
  String get editItem;

  /// No description provided for @product.
  ///
  /// In pt, this message translates to:
  /// **'Produto'**
  String get product;

  /// No description provided for @productHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Leite integral'**
  String get productHint;

  /// No description provided for @filledFromHistory.
  ///
  /// In pt, this message translates to:
  /// **'Preenchido com a última compra'**
  String get filledFromHistory;

  /// No description provided for @brandOptional.
  ///
  /// In pt, this message translates to:
  /// **'Marca (opcional)'**
  String get brandOptional;

  /// No description provided for @brandHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Piracanjuba'**
  String get brandHint;

  /// No description provided for @quantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In pt, this message translates to:
  /// **'Unidade'**
  String get unit;

  /// No description provided for @unitPrice.
  ///
  /// In pt, this message translates to:
  /// **'Valor unitário'**
  String get unitPrice;

  /// No description provided for @subtotal.
  ///
  /// In pt, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @add.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get add;

  /// No description provided for @modeShopping.
  ///
  /// In pt, this message translates to:
  /// **'Em compra'**
  String get modeShopping;

  /// No description provided for @modePlanning.
  ///
  /// In pt, this message translates to:
  /// **'Planejamento'**
  String get modePlanning;

  /// No description provided for @unitPiece.
  ///
  /// In pt, this message translates to:
  /// **'un'**
  String get unitPiece;

  /// No description provided for @unitPackage.
  ///
  /// In pt, this message translates to:
  /// **'pct'**
  String get unitPackage;

  /// No description provided for @listTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total da lista'**
  String get listTotal;

  /// No description provided for @inCart.
  ///
  /// In pt, this message translates to:
  /// **'no carrinho'**
  String get inCart;

  /// No description provided for @pickedCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} no carrinho'**
  String pickedCount(int count);

  /// No description provided for @itemCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} itens}}'**
  String itemCount(int count);

  /// No description provided for @itemsLabel.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{item} other{itens}}'**
  String itemsLabel(int count);

  /// No description provided for @productsLabel.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{produto} other{produtos}}'**
  String productsLabel(num count);

  /// No description provided for @noStore.
  ///
  /// In pt, this message translates to:
  /// **'Sem supermercado'**
  String get noStore;

  /// No description provided for @budgetPercent.
  ///
  /// In pt, this message translates to:
  /// **'{percent}% do orçamento'**
  String budgetPercent(int percent);

  /// No description provided for @overBudget.
  ///
  /// In pt, this message translates to:
  /// **'Acima do orçamento'**
  String get overBudget;

  /// No description provided for @budgetOf.
  ///
  /// In pt, this message translates to:
  /// **'{label} de {budget}'**
  String budgetOf(String label, String budget);

  /// No description provided for @budgetExceeded.
  ///
  /// In pt, this message translates to:
  /// **'Passou {amount} do orçamento'**
  String budgetExceeded(String amount);

  /// No description provided for @defaultListName.
  ///
  /// In pt, this message translates to:
  /// **'Lista {date}'**
  String defaultListName(String date);

  /// No description provided for @copyOf.
  ///
  /// In pt, this message translates to:
  /// **'Cópia de {name}'**
  String copyOf(String name);

  /// No description provided for @unnamedItem.
  ///
  /// In pt, this message translates to:
  /// **'Item sem nome'**
  String get unnamedItem;

  /// No description provided for @shareSummary.
  ///
  /// In pt, this message translates to:
  /// **'Itens: {items} · Produtos: {products}'**
  String shareSummary(int items, String products);

  /// No description provided for @shareInCart.
  ///
  /// In pt, this message translates to:
  /// **'No carrinho: {amount} ({count, plural, =1{1 item} other{{count} itens}})'**
  String shareInCart(String amount, int count);

  /// No description provided for @shareRemaining.
  ///
  /// In pt, this message translates to:
  /// **'Falta pegar: {amount} ({count, plural, =1{1 item} other{{count} itens}})'**
  String shareRemaining(String amount, int count);

  /// No description provided for @shareTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total: {total}'**
  String shareTotal(String total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
