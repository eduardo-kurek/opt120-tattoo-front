# Tattoo Book

## Sobre

Tattoo Book é um app para tatuadores que querem controlar sua agenda, e para usuários que desejam fazer tatuagens. Um usuário pode se cadastrar e se tornar um tatuador, quando ele fizer isso, poderá cadastrar tatuagens, ver seus agendamentos futuros e cancelar caso necessário. Já os usuários comuns podem procurar por tatuagens a agendar e também ver os agendamentos e cancela-los.

## Build

* Para buildar o projeto, basta ter o flutter instalado na máquina, depois clonar o repositório em uma pasta, usar o comando `flutter pub get` para instalar as dependencias. Você pode ver os seus dispositivos disponíveis com o comando `flutter devices`, e pode executar o código em um determinado device com o comando `flutter run -d %device_name%`. O front-end considera que o back-end esta rodando na url `http://localhost:3001`, caso necessário alterar a URL, pode ser feito no arquivo lib/services/Api.dart:

```dart
class ApiService {
  static String baseUrl = "http://localhost:3001";

  ...
}
```


## Tecnologias usadas

* http: ^1.2.2
* jwt_decoder: ^2.0.1
* provider: ^6.1.2
* image_picker: ^0.8.5+3
* omni_datetime_picker: ^2.0.4
* intl: ^0.17.0
