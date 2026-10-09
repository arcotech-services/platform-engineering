# Bee CLI (novo) — instalador

Baixa o binário das releases do repositório `arcotech-services/poc-bee-humanitec`.

```bash
curl -fsSL https://raw.githubusercontent.com/arcotech-services/platform-engineering/main/bee-platform/install.sh | sh
```

O script instala em `/usr/local/bin/bee` e substitui o Bee antigo. Para manter os
dois, instale com outro nome: `curl ... | BIN=bee-next sh`.
