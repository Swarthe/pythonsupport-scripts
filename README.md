# DTU Python Support Scripts

## Usage

### Remote (end-user install)

```bash
# Install
curl -fsSL https://raw.githubusercontent.com/dtudk/pythonsupport-scripts/dev/Core/Orchestration/install_all_macOS.sh | bash

# Uninstall
curl -fsSL https://raw.githubusercontent.com/dtudk/pythonsupport-scripts/dev/Core/Orchestration/uninstall_all_macOS.sh | bash
```

### Local development

Set `REPO_BASE_URL` to your local repo and run any script directly:

```bash
export REPO_BASE_URL="file://$PWD"
bash Core/Orchestration/install_all_macOS.sh
bash Core/VsCode/config/settings_macOS.sh
bash Core/VsCode/config/extensions_macOS.sh
```

### How it works

All scripts use `curl -fsSL "$REPO_BASE_URL/..."` to reference other files in the repo.

- **Orchestration scripts** default `REPO_BASE_URL` to the GitHub raw URL and export it so child scripts inherit it.
- **Child scripts** expect `REPO_BASE_URL` to be set in the environment.
- For local testing, `export REPO_BASE_URL="file://$PWD"` makes `curl` read from the local filesystem instead.

### Error handling

All scripts use `set -euo pipefail`.

- `-e`: Exit immediately if a command fails.
- `-u`: Using an unset variable yields an error.
- `-o pipefail`: Pipes return the error code of the first failure.

### TODO

- Directory structure too complex, i.e. do we need separate install uninstall dirs?
- Should we prefix all env vars with `PS_`?
  * Use lowercase for local script variables?
- Should we merge/warn/overwrite `settings.json` in config installer?
