# Bee CLI — instalador

Este diretório contém o script [`install.sh`](install.sh) usado para instalar o **Bee CLI** a partir das [releases](https://github.com/arcotech-services/platform-bee/releases) do repositório privado `arcotech-services/platform-bee`.

## Requisitos

- **GitHub CLI** (`gh`) autenticado (`gh auth login`) com permissão para ler releases do repositório das releases, **ou** acesso HTTP(S)/SSH ao mesmo repositório conforme sua configuração de credenciais.
- Com `BEE_VERSION=latest` (padrão): **git** acessível e credenciais que permitam `git ls-remote` no repositório das releases (listar tags). O script tenta primeiro a URL SSH (`git@github.com:...`); se não houver tags, tenta HTTPS.
- **Linux/macOS:** instalação em `/usr/local/bin` (usa `sudo` se necessário).

## Uso

```bash
curl -fsSL https://raw.githubusercontent.com/arcotech-services/platform-engineering/main/bee/install.sh | sh
```

Versão específica:

```bash
BEE_VERSION=v1.0.0 curl -fsSL https://raw.githubusercontent.com/arcotech-services/platform-engineering/main/bee/install.sh | sh
```

Variável opcional: `BEE_REPO` (padrão `arcotech-services/platform-bee`), se as releases estiverem noutro fork ou espelho.

## Integração na aplicação

Documentação de integração de recursos (variáveis, Secret Manager, external-secrets): [Integração de recursos](https://sites.google.com/arcoeducacao.com.br/sre/plataforma/integra%C3%A7%C3%A3o-de-recursos) (Google Sites).
