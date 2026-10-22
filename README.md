<h1 align="center">🛒 Somou</h1>

<p align="center">
  <strong>Lista de compras com total na hora.</strong><br>
  Monte sua lista, marque o que já está no carrinho e saiba quanto vai gastar antes de chegar ao caixa.
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white">
  <img alt="Plataformas" src="https://img.shields.io/badge/plataformas-Android%20%7C%20iOS-3DDC84">
  <img alt="Offline" src="https://img.shields.io/badge/100%25-offline-success">
  <img alt="Versão" src="https://img.shields.io/badge/vers%C3%A3o-1.0.0-informational">
</p>

---

## Índice

- [Sobre](#sobre)
- [Funcionalidades](#funcionalidades)
- [Regras de negócio](#regras-de-negócio)
- [Tecnologias](#tecnologias)
- [Arquitetura](#arquitetura)
- [Banco de dados](#banco-de-dados)
- [Como rodar](#como-rodar)
- [Instalando no celular](#instalando-no-celular)
- [Testes](#testes)
- [Padrão de commits](#padrão-de-commits)

---

## Sobre

O **Somou** é um app de lista de compras focado em uma pergunta: **quanto isso vai dar?**
Cada item tem quantidade, unidade e preço, e o app soma tudo em tempo real. Você também acompanha
quanto já está no carrinho e se está dentro do orçamento.

Tudo fica salvo no próprio aparelho. O app não precisa de conta nem de internet; a conexão só é usada
para compartilhar a lista pelo WhatsApp.

---

## Funcionalidades

### 📋 Listas

| Funcionalidade | Descrição |
|---|---|
| **Criar lista** | Nome, supermercado e orçamento são opcionais. Sem nome, a lista recebe a data (`Lista 22/10/2026`). |
| **Dois modos de uso** | **Já estou comprando** (padrão): você monta a lista durante a compra, e cada item adicionado já entra marcado como no carrinho. **Vou planejar**: você monta a lista antes de sair de casa. |
| **Editar lista** | Altera nome, supermercado e orçamento. O modo é definido na criação e não muda depois. |
| **Duplicar lista** | Cria uma `Cópia de ...` com todos os itens desmarcados, em modo Planejamento. É útil para a compra do mês. |
| **Excluir lista** | Pede confirmação e remove a lista junto com todos os itens. |
| **Visão geral na Home** | Cada cartão mostra supermercado, data, total, valor no carrinho e contagem de itens. As listas mais recentes aparecem primeiro. |
| **Ações rápidas** | Toque para abrir a lista; pressione e segure para editar, duplicar ou excluir. |

### 🧾 Itens

| Funcionalidade | Descrição |
|---|---|
| **Adicionar item** | Produto, marca, quantidade, unidade e valor unitário, todos opcionais. |
| **Unidades** | `un`, `pct`, `kg`, `g`, `L` e `ml`. |
| **Quantidade fracionada** | Aceita até 3 casas decimais, com vírgula ou ponto (`1,5 kg`). |
| **Máscara de moeda** | O valor é digitado a partir dos centavos e formatado em `R$` automaticamente. |
| **Marcar no carrinho** | No modo Planejamento, um checkbox marca o item como pego e o deixa riscado. No modo Em compra, tudo já está no carrinho, então o checkbox dá lugar a uma lixeira. |
| **Editar item** | Toque no item para alterar qualquer campo. |
| **Remover com desfazer** | Arraste o item para o lado (ou toque na lixeira, no modo Em compra) para removê-lo. O botão **Desfazer** devolve o item à mesma posição. |

### 🔎 Autocompletar com histórico

- O app guarda o **último registro de cada produto** usado: marca, quantidade, unidade e preço.
- Ao digitar o nome, aparecem até **5 sugestões**. As que começam com o texto digitado vêm primeiro, depois as usadas mais recentemente.
- A busca **ignora acentos, maiúsculas e espaços extras** (`Pão` encontra `pao`).
- Ao escolher uma sugestão, o formulário é preenchido com os últimos valores do produto.

### 💰 Totais e orçamento

| Indicador | Como é calculado |
|---|---|
| **Total da lista** | Soma dos subtotais (quantidade × valor unitário) de todos os itens. |
| **No carrinho** | Soma dos subtotais dos itens marcados. |
| **Itens** | Número de linhas da lista. |
| **Produtos** | Soma das quantidades em `un` e `pct`; itens em peso ou volume contam como 1. |

Quando a lista tem orçamento, uma **barra de progresso** mostra o percentual usado:

| Cor | Situação |
|---|---|
| 🟢 Verde | até 80% do orçamento |
| 🟡 Amarela | de 80% a 100% |
| 🔴 Vermelha | acima do orçamento, com o aviso *"Passou R$ X do orçamento"* |

No modo **Planejamento**, o orçamento é comparado com o **total da lista**. No modo **Em compra**,
é comparado com o valor **no carrinho**.

### 📤 Compartilhar no WhatsApp

A lista é enviada como texto formatado, pronto para mandar para quem vai às compras:

```text
🛒 Compra do mês — Supermercado X
━━━━━━━━━━━━
✅ 2 un Leite integral (Piracanjuba) — R$ 9,58
⬜ 1,5 kg Banana — R$ 8,97
━━━━━━━━━━━━
Itens: 2 · Produtos: 3
Total: R$ 18,55
```

### 🎨 Interface

- Material Design 3, com **tema claro e escuro** que segue o sistema.
- Interface em **português do Brasil**, com moeda, datas e números em `pt-BR`.
- Telas vazias com orientação para o primeiro uso.

---

## Regras de negócio

As regras estão documentadas no código com códigos de referência (`RFxx` para requisitos funcionais
e `RNxx` para regras de negócio) e cobertas por testes.

| Código | Regra |
|---|---|
| RN01 | Lista sem nome recebe `Lista dd/MM/aaaa`. |
| RN02 | Item sem nome vira `Item sem nome`; sem quantidade vale 1; sem preço vale R$ 0,00. |
| RN03 | Subtotal = quantidade × valor unitário, arredondado ao centavo. |
| RN04 | Total soma todos os itens; carrinho soma só os marcados. |
| RN05 | Itens = número de linhas da lista. |
| RN06 | Produtos: `un` e `pct` somam a quantidade; peso e volume contam 1. |
| RN07 | No modo Planejamento o item entra desmarcado; no modo Em compra entra marcado. |
| RN08 | O orçamento usa o total (Planejamento) ou o carrinho (Em compra). |
| RN09 | Cores do orçamento: verde até 80%, amarela até 100%, vermelha acima. |
| RN10 | Nomes são normalizados (minúsculo, sem acento, espaços simples) para o histórico. |
| RN11 | Quantidade com até 3 casas decimais e sempre positiva. |

> Os valores monetários são armazenados em **centavos (inteiros)** para evitar erros de arredondamento com ponto flutuante.

---

## Tecnologias

| Pacote | Uso |
|---|---|
| [Flutter](https://flutter.dev) / Dart 3 | Framework e linguagem |
| [provider](https://pub.dev/packages/provider) | Injeção de dependências e gerenciamento de estado (`ChangeNotifier`) |
| [sqflite](https://pub.dev/packages/sqflite) | Banco SQLite local |
| [intl](https://pub.dev/packages/intl) + `flutter_localizations` | Formatação de moeda, data e números em pt-BR |
| [url_launcher](https://pub.dev/packages/url_launcher) | Abertura do WhatsApp |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi) | SQLite em memória nos testes |
| [flutter_lints](https://pub.dev/packages/flutter_lints) | Análise estática |

---

## Arquitetura

O projeto separa as responsabilidades em camadas:

```text
lib/
├── main.dart              # Abre o banco, registra os providers e inicia o app
├── data/                  # Acesso ao SQLite
│   ├── app_database.dart          # Criação do schema
│   ├── shopping_list_repository.dart
│   ├── list_item_repository.dart
│   └── product_history_repository.dart
├── models/                # Entidades e regras de negócio puras
│   ├── shopping_list.dart · list_item.dart · product_history.dart
│   ├── list_mode.dart · unit.dart
│   ├── list_totals.dart           # Totais e status do orçamento
│   └── form_inputs.dart           # Valores padrão dos formulários
├── controllers/           # Estado das telas (ChangeNotifier)
│   ├── home_controller.dart
│   └── list_detail_controller.dart
├── pages/                 # Telas
│   ├── home_page.dart
│   └── list_detail_page.dart
├── widgets/               # Componentes reutilizáveis (cards, formulários, barra de orçamento…)
├── theme/                 # Tema claro/escuro e paleta de cores
└── utils/                 # Formatadores, máscaras e texto de compartilhamento
```

**Fluxo:** `Page` → `Controller` → `Repository` → SQLite.
As regras de negócio ficam nos **models**, sem dependência de Flutter, o que permite testá-las isoladamente.

---

## Banco de dados

SQLite local (`somou.db`) com três tabelas:

```text
shopping_lists                list_items                       product_history
──────────────                ──────────                       ───────────────
id                 ◄──────┐   id                               id
name                      └── list_id (ON DELETE CASCADE)      name_key (UNIQUE)
store                         name                             name
mode                          brand                            brand
budget_cents                  quantity                         quantity
created_at                    unit                             unit
updated_at                    unit_price_cents                 unit_price_cents
                              picked                           last_used_at
                              created_at
                              updated_at
```

- `CHECK constraints` garantem valores válidos para modo, unidade, quantidade e preços.
- As chaves estrangeiras estão ativas, então excluir uma lista remove os itens em cascata.
- A gravação no histórico usa `UPDATE` + `INSERT` para funcionar no SQLite de versões antigas do Android.

---

## Como rodar

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.13`)
- Android Studio com Android SDK, **ou** Xcode (macOS) para iOS
- Um emulador ou aparelho físico

### Passos

```bash
# 1. Clone o repositório
git clone <url-do-repositorio>
cd somou

# 2. Instale as dependências
flutter pub get

# 3. Verifique o ambiente
flutter doctor

# 4. Rode o app
flutter run
```

### Splash screen

A imagem fica em `assets/splash/splash.png` e é desenhada pelo script `tool/make_splash.py`
(Python + Pillow). Depois de alterá-la, gere os arquivos nativos de Android e iOS:

```bash
python tool/make_splash.py assets/splash   # opcional: redesenha a imagem
dart run flutter_native_splash:create      # tema claro e escuro, incluindo Android 12+
```

---

## Instalando no celular

### Android via USB

1. No celular: **Configurações → Sobre o telefone** → toque 7× em **Número da versão**.
2. Em **Opções do desenvolvedor**, ative a **Depuração USB**.
3. Conecte o cabo, autorize o computador e rode:

```bash
flutter devices              # confirme que o aparelho aparece
flutter run -d <id-do-aparelho>
```

### Gerar APK

```bash
flutter build apk --release
```

O arquivo é gerado em `build/app/outputs/flutter-apk/app-release.apk`. Envie para o celular e
permita a instalação de apps de fontes desconhecidas.

> **iOS:** a compilação exige um Mac com Xcode.

---

## Testes

```bash
flutter test
```

| Arquivo | O que cobre |
|---|---|
| `test/rules_test.dart` | Formatação (moeda, quantidade, normalização) e regras RN01–RN11, além do texto do WhatsApp (RF06) |
| `test/database_test.dart` | Totais da Home, exclusão em cascata (RF04), duplicação (RF05), histórico (RF09/RN10) e desfazer remoção (RF11) |

Os testes de banco rodam em um SQLite em memória via `sqflite_common_ffi`, sem precisar de emulador.

Para a análise estática:

```bash
flutter analyze
```

---

## Padrão de commits

O projeto segue o [Conventional Commits](https://www.conventionalcommits.org/pt-br/):

```text
<tipo>(escopo opcional): descrição no imperativo
```

| Tipo | Uso |
|---|---|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `refactor` | Mudança de código sem alterar comportamento |
| `style` | Formatação |
| `docs` | Documentação |
| `test` | Testes |
| `chore` | Manutenção e dependências |
| `build` | Build, Gradle, versões |

Exemplo: `feat(lista): adiciona total em tempo real`
