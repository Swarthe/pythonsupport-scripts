#!/bin/bash
# @doc
# @name: VS Code Extensions (macOS)
# @description: Install VS Code extensions from extensions.txt
# @category: Core
# @usage: bash Core/VsCode/config/extensions_macOS.sh
# @requirements: macOS, VS Code installed
# @notes: Reads extension IDs from extensions.txt (one per line, # comments and blank lines skipped)
# @/doc

set -euo pipefail

STD_CODE_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

echo "=== Installing VS Code Extensions ==="
echo ""

if [ ! -x "$STD_CODE_CLI" ]; then
    CODE_CLI=$(command -v code 2>/dev/null || true)

    if [ ! -x "$CODE_CLI" ]; then
        echo "  ERROR: VS Code not found at $STD_CODE_CLI"
        exit 1
    fi
else
    CODE_CLI="$STD_CODE_CLI"
fi

while IFS= read -r line || [ -n "$line" ]; do
    [[ -z "$line" || "$line" == \#* ]] && continue

    if "$CODE_CLI" --install-extension "$line" --force 2>/dev/null; then
        echo "  [OK] $line"
    else
        echo "  [FAIL] $line"
    fi
done < <(curl -fsSL "$REPO_BASE_URL/Core/VsCode/config/extensions.txt")

echo ""
echo "=== Extensions complete! ==="
