# Bee CLI (novo) — instalador

Baixa o binário das releases do repositório `arcotech-services/poc-bee-humanitec`.

```bash
curl -fsSL https://raw.githubusercontent.com/arcotech-services/platform-engineering/main/bee-platform/install.sh | sh
```

O script instala em `/usr/local/bin/bee` e substitui o Bee antigo. Para manter os
dois, instale com outro nome: `curl ... | BIN=bee-next sh`.

Por padrão instala o último release estável (sem pre-release `-rc.N`). Para fixar
uma versão:

```bash
curl -fsSL https://raw.githubusercontent.com/arcotech-services/platform-engineering/main/bee-platform/install.sh | BEE_VERSION=v1.0.0 sh
```
