# 🛒 App Carrinho de Compras - Flutter (Arquitetura MVVM)

## 🎯 Objetivo

Aplicativo Flutter desenvolvido com **arquitetura MVVM**, simulando o fluxo completo de um carrinho de compras com consumo de API, estados reativos e persistência global de dados.

---

## 🧠 Avaliação Baseada em

* Aderência à arquitetura **MVVM** (Model-View-ViewModel)
* Organização e clareza do código
* Uso de **ChangeNotifier** e **Provider**
* Tratamento de **loading**, **erro** e **sucesso**
* Navegação via **rotas nomeadas**
* UX consistente e regras de negócio aplicadas corretamente

---

## 🧱 Estrutura de Pastas

```
lib/
│
├── core/
│   ├── result.dart              # Classe Result<T> para padronizar sucesso/erro
│   └── routes/app_routes.dart   # Rotas nomeadas do app
│
├── data/
│   ├── datasource/
│   │   └── product_remote_data_source.dart  # Busca dados da API FakeStore
│   ├── models/
│   │   └── product_model.dart   # Modelo de dados do produto
│   └── services/
│       └── product_service.dart # Serviço com Dio para requisições HTTP
│
├── domain/
│   └── commands/
│       └── fetch_products_command.dart  # Lógica de busca de produtos
│
├── injections/
│   └── app_injection.dart       # Injeção de dependências (Dio, Commands, ViewModel)
│
├── presentation/
│   ├── viewmodel/
│   │   └── product_view_model.dart   # Lógica de estado, carrinho e checkout
│   └── widgets/
│       ├── home_screen.dart         # Tela de listagem de produtos
│       ├── cart_screen.dart         # Tela do carrinho
│       ├── order_complete_screen.dart # Tela de pedido finalizado
│       └── connection_error_page.dart # Tela de erro de conexão
│
└── main.dart                   # Ponto de entrada do app
```

---

## ⚙️ Tecnologias Utilizadas

* **Flutter 3.x**
* **Dio** → Consumo de API REST (`https://fakestoreapi.com/products`)
* **Provider / ChangeNotifier** → Gerenciamento de estado reativo
* **Arquitetura MVVM** → Separação clara de camadas
* **Rotas Nomeadas** → Navegação entre telas

---

## 🧩 Arquitetura MVVM no Projeto

### 🧱 Model

Define as entidades de dados (ex: `ProductModel`).

### 🎨 View

Widgets “burros”, apenas exibem UI e reagem ao estado do ViewModel.

### 🧠 ViewModel

Contém toda a lógica de negócio e de estado:

* Gerencia lista de produtos
* Controla carrinho
* Expõe estados (`isLoading`, `error`, `products`)
* Simula checkout com sucesso/erro

### ⚙️ Commands

Encapsulam ações de domínio (ex: `FetchProductsCommand` chama o DataSource).

### 🌐 DataSource / Service

Responsável por buscar dados via API (FakeStore).

---

## 💡 Funcionalidades Implementadas

✅ Catálogo de produtos com imagens, título e preço
✅ Adição e remoção de produtos no carrinho
✅ Controles de quantidade (+ / −)
✅ Limite de 10 produtos diferentes
✅ Badge de contagem no ícone do carrinho
✅ Tela de erro de conexão com botão de tentar novamente
✅ Tela de resumo do pedido com:

* Subtotal, frete simulado e total
  ✅ Checkout simulado (com atraso e chance de erro)
  ✅ Tela de pedido finalizado com opção “Novo Pedido”
  ✅ Navegação com **rotas nomeadas**


---

## 🚀 Execução do Projeto

```bash
# Clonar o repositório
git clone https://github.com/seu-usuario/app_carrinho_mvvm.git

# Entrar na pasta
cd app_carrinho_mvvm

# Instalar dependências
flutter pub get

# Rodar o projeto
flutter run
```

---

## 🧭 Fluxo de Navegação

1. **HomeScreen** → Lista de produtos
2. **CartScreen** → Exibe produtos adicionados e resumo
3. **OrderCompleteScreen** → Confirmação de pedido + botão “Novo Pedido”

---

## 📊 Diagrama Simplificado (Arquitetura)

```
          ┌──────────────────────┐
          │     main.dart        │
          └────────┬─────────────┘
                   │
          ┌────────▼────────┐
          │    View (UI)    │
          └────────┬────────┘
                   │ Provider
          ┌────────▼────────┐
          │  ViewModel      │
          └────────┬────────┘
                   │ chama
          ┌────────▼────────┐
          │  Commands       │
          └────────┬────────┘
                   │ usa
          ┌────────▼────────┐
          │  DataSource     │
          └────────┬────────┘
                   │
          ┌────────▼────────┐
          │     API REST    │
          └─────────────────┘
```

---

## 👨‍💻 Autor

**Cassiano Simas**
Desenvolvido como desafio Flutter com foco em boas práticas, arquitetura limpa e fluidez de experiência de compra.


