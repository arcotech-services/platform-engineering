#!/bin/sh
# Instalação do CLI Bee (binários em arcotech-services/platform-bee; repo privado — requer gh auth login).
# Obter este script:
#   curl -fsSL https://raw.githubusercontent.com/arcotech-services/platform-engineering/main/bee/install.sh | sh
# Versão fixa: BEE_VERSION=v1.0.0 curl -fsSL ... | sh

set -eu

BEE_REPO=${BEE_REPO:-arcotech-services/platform-bee}
BEE_VERSION=${BEE_VERSION:-latest}
BIN=${BIN:-bee}

os=$(uname -s)
arch=$(uname -m)
OS=${OS:-"${os}"}
ARCH=${ARCH:-"${arch}"}

unsupported_arch() {
  echo "Bee CLI não suporta $OS / $ARCH."
  exit 1
}

case $OS in
  Darwin)
    case $ARCH in
      x86_64 | amd64)  SUFFIX="darwin-amd64" ;;
      arm64)           SUFFIX="darwin-arm64" ;;
      *)               unsupported_arch "$OS" "$ARCH" ;;
    esac ;;
  Linux)
    case $ARCH in
      x86_64 | amd64)  SUFFIX="linux-amd64" ;;
      arm64 | aarch64) SUFFIX="linux-arm64" ;;
      *)               unsupported_arch "$OS" "$ARCH" ;;
    esac ;;
  MINGW* | MSYS* | CYGWIN*)
    SUFFIX="windows-amd64.exe" ;;
  *)
    unsupported_arch "$OS" "$ARCH" ;;
esac

if [ "$BEE_VERSION" = "latest" ]; then
  if ! command -v git >/dev/null 2>&1; then
    echo "Para instalar a última versão é necessário git. Use BEE_VERSION=vX.Y.Z"
    exit 1
  fi
  tags=$(git ls-remote --tags "https://github.com/${BEE_REPO}.git" 2>/dev/null | grep 'refs/tags/' | grep -v '\^{}' | sed 's|.*refs/tags/||')
  if [ -z "$tags" ]; then
    echo "Nenhum release em ${BEE_REPO}. Use BEE_VERSION=tag"
    exit 1
  fi
  latest=$(echo "$tags" | sed 's/^v//' | sort -t. -k1,1n -k2,2n -k3,3n 2>/dev/null | tail -1)
  [ -z "$latest" ] && echo "Nenhuma tag vX.Y.Z em ${BEE_REPO}. Use BEE_VERSION=tag" && exit 1
  VERSION="v${latest}"
else
  VERSION="$BEE_VERSION"
fi

ASSET_NAME="bee-${VERSION}-${SUFFIX}"
tmpfile=$(mktemp -t "bee-XXXXXX" 2>/dev/null || mktemp -t "bee" 2>/dev/null || echo "/tmp/bee-download-$$")

if command -v gh >/dev/null 2>&1; then
  gh_err=$(gh release download "${VERSION}" -R "${BEE_REPO}" -p "${ASSET_NAME}" -O "${tmpfile}" --clobber 2>&1) || true
  if [ ! -s "${tmpfile}" ]; then
    gh_err=$(gh release download "${VERSION}" -R "${BEE_REPO}" -p "bee-${SUFFIX}" -O "${tmpfile}" --clobber 2>&1) || true
  fi
  if [ ! -s "${tmpfile}" ]; then
    rm -f "${tmpfile}"
    echo "Download falhou (versão ${VERSION}, asset ${ASSET_NAME})."
    [ -n "$gh_err" ] && echo "$gh_err"
    echo "Verifique: gh release view ${VERSION} -R ${BEE_REPO}"
    exit 1
  fi
else
  url="https://github.com/${BEE_REPO}/releases/download/${VERSION}/${ASSET_NAME}"
  if ! curl -sfL "${url}" -o "${tmpfile}"; then
    rm -f "${tmpfile}"
    echo "Download falhou (repo privado?). Instale gh e faça gh auth login, ou use BEE_VERSION=${VERSION}"
    exit 1
  fi
fi

chmod +x "${tmpfile}"

case $OS in
  MINGW* | MSYS* | CYGWIN*)
    mv "${tmpfile}" "./${BIN}.exe"
    echo "Bee CLI baixado: ./${BIN}.exe. Adicione ao PATH."
    exit 0 ;;
esac

if [ ! -w /usr/local/bin ] && ! command -v sudo >/dev/null 2>&1; then
  echo "Sem permissão em /usr/local/bin e sudo indisponível. Salve manualmente: mv ${tmpfile} \${PATH}/${BIN}"
  exit 1
fi

if [ -w /usr/local/bin ]; then
  mv "${tmpfile}" "/usr/local/bin/${BIN}"
else
  sudo mv "${tmpfile}" "/usr/local/bin/${BIN}"
fi

if [ "$OS" = "Darwin" ]; then
  xattr -d com.apple.quarantine "/usr/local/bin/${BIN}" 2>/dev/null || sudo xattr -d com.apple.quarantine "/usr/local/bin/${BIN}" 2>/dev/null || true
fi

echo "Bee CLI instalado em /usr/local/bin/${BIN} (${VERSION}). Execute: ${BIN} --help"
