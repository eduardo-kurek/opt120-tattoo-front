# Tattoo Book

## Sobre

Tattoo Book é um app para tatuadores que querem controlar sua agenda, e para usuários que desejam fazer tatuagens. Um usuário pode se cadastrar e se tornar um tatuador, quando ele fizer isso, poderá cadastrar tatuagens, ver seus agendamentos futuros e cancelar caso necessário. Já os usuários comuns podem procurar por tatuagens a agendar e também ver os agendamentos e cancela-los.

## Como executar o Frontend

A versão do [Flutter](https://flutter.dev/docs/get-started/install) utilizada no projeto é a **3.24**, e o [Dart](https://dart.dev/get-dart) é a versão **3.5**.

### Baixar o projeto

Para baixar o frontend do projeto, basta clonar o repositório em sua máquina local:

```bash	
git clone https://github.com/eduardo-kurek/opt120-tattoo-front.git
```

### Baixar as dependências

```bash
flutter pub get
```

### Executar o projeto

- Para verificar os seus dispositivos disponíveis:

  ```bash
  flutter devices
  ```

- Para executar o código em um determinado device:

  ```bash
  flutter run -d %device_name%
  ```

O front-end considera que o back-end esta rodando na url `http://localhost:3001`, caso necessário alterar a URL, pode ser feito no arquivo lib/services/Api.dart:

```dart
class ApiService {
  static String baseUrl = "http://localhost:3001";

  ...
}
```

## Como executar o Backend

O Backend do projeto se encontra no repositório [TattooArt-Api](https://github.com/hebertCardoso63/TattooArt-Api), e para executar o projeto, basta seguir as instruções do README do repositório.

## Funcionalidades

- Usuário
  - Cadastro
  - Login
  - Virar tatuador
  - Listar tatuagens disponíveis
  - Agendar tatuagem
  - Cancelar agendamento
  - Ver agendamentos

- Tatuador
  - Criar tatuagem
  - Editar tatuagem
  - Deletar tatuagem
  - Listar tatuagens criadas
  - Cancelar agendamento
  - Ver agendamentos de tatuagens criadas