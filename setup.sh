#!/usr/bin/env bash
set -euo pipefail

#SET PYTHON VERSION HERE:
PYTHON_VER="${PYTHON_VER:-3.12}"
################################

VENV_DIR="${VENV_DIR:-venv}"
KERNEL_NAME="${KERNEL_NAME:-projekt-venv}"
KERNEL_DISPLAY="${KERNEL_DISPLAY:-Python (projekt-venv)}"

# Voraussetzungen prüfen
command -v uv >/dev/null 2>&1 || {
  echo "Fehler: 'uv' nicht gefunden. Installiere uv (z.B. pacman/paru/aur)."
  exit 1
}

# Passende Python-Version via uv bereitstellen
uv python install "$PYTHON_VER"

# venv erstellen/neu erstellen
# Wenn venv existiert, prüfen wir die Python-Version darin. Falls sie nicht passt: neu bauen.
if [[ -d "$VENV_DIR" ]]; then
  VENV_PY_VER="$("$VENV_DIR/bin/python" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || true)"
  if [[ "$VENV_PY_VER" != "$PYTHON_VER" ]]; then
    echo "Hinweis: $VENV_DIR nutzt Python $VENV_PY_VER, erwartet $PYTHON_VER -> venv wird neu erstellt."
    rm -rf "$VENV_DIR"
  else
    echo "Hinweis: $VENV_DIR existiert schon, wird weiterverwendet."
  fi
fi

if [[ ! -d "$VENV_DIR" ]]; then
  uv venv --python "$PYTHON_VER" "$VENV_DIR"
fi

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

# Sicherstellen, dass pip im venv vorhanden ist
if ! python -c "import pip" >/dev/null 2>&1; then
  echo "Hinweis: pip fehlt im venv -> installiere via ensurepip."
  python -m ensurepip --upgrade
fi

# pip auf die neueste Version updaten
python -m pip install --upgrade pip

# Installationen (uv pip ist ok; pip upgrade ist optional)
uv pip install -r requirements.txt

# Jupyter Kernel
uv pip install -U ipykernel
python -m ipykernel install --user --name "$KERNEL_NAME" --display-name "$KERNEL_DISPLAY"

echo "Fertig. venv='$VENV_DIR' (Python $PYTHON_VER), Kernel='$KERNEL_DISPLAY'."
