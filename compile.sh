#!/bin/sh
set -eu
cd "$(dirname "$0")"

# Prefer the managed runtime; fall back to an existing PATH installation.
for texbin in "$HOME"/.cache/codex-runtimes/codex-texlive/full/bin/*; do
    if [ -x "$texbin/xelatex" ] && [ -x "$texbin/latexmk" ]; then
        PATH="$texbin:$PATH"
        export PATH
        break
    fi
done
if ! command -v xelatex >/dev/null 2>&1 || ! command -v latexmk >/dev/null 2>&1; then
    printf '%s\n' 'XeLaTeX and latexmk are required but were not found.' >&2
    exit 1
fi
mkdir -p build
exec latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error -synctex=1 -outdir=build main.tex "$@"
