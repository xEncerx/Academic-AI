#!/usr/bin/env bash
set -e

REPO="https://raw.githubusercontent.com/xEncerx/Academic-AI/main"
REPO_GIT="https://github.com/xEncerx/Academic-AI.git"

LOCAL_VERSION=$(cat .version 2>/dev/null || echo "0.0.0")
REMOTE_VERSION=$(curl -fsSL "$REPO/.version")

if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
  echo "✅ Уже актуальная версия: $LOCAL_VERSION"
  exit 0
fi

echo "🔄 Обновление с $LOCAL_VERSION → $REMOTE_VERSION"

# Папки шаблона для обновления
TEMPLATE_DIRS=("settings" ".agents")
TEMPLATE_FILES=("main.typ" "docs.md" "README.md" "AGENTS.md" ".version")

# Клонируем во временную директорию
TMP_DIR=$(mktemp -d)
git clone --depth=1 "$REPO_GIT" "$TMP_DIR" 2>/dev/null

# Обновляем папки шаблона
for dir in "${TEMPLATE_DIRS[@]}"; do
  rm -rf "./$dir"
  cp -r "$TMP_DIR/$dir" "./$dir"
done

# Обновляем файлы шаблона
for file in "${TEMPLATE_FILES[@]}"; do
  cp "$TMP_DIR/$file" "./$file"
done

rm -rf "$TMP_DIR"
echo "✅ Шаблон обновлён до версии $REMOTE_VERSION"