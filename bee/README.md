# Bee CLI — instalador

Baixa o binário das releases do repositório em `BEE_REPO` (padrão `arcotech-services/platform-bee`). Exige acesso de leitura no GitHub a esse repo (ex.: `gh auth login`) e, com `BEE_VERSION=latest`, `git` com acesso ao mesmo repositório.

```bash
curl -fsSL https://raw.githubusercontent.com/arcotech-services/platform-engineering/main/bee/install.sh | sh
```

Versão fixa: `BEE_VERSION=v1.0.0` antes do comando.
