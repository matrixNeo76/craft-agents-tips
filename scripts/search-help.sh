#!/usr/bin/env bash
# search-help.sh — Cerca nelle guide di Craft Agents Tips
# 
# Uso:
#   ./scripts/search-help.sh "errore OAuth"
#   ./scripts/search-help.sh "come installo"
#   ./scripts/search-help.sh --list        # Lista tutte le guide con domande
#   ./scripts/search-help.sh --sources     # Mostra i sources disponibili
#
# Cerca in tutti i file help/ il pattern specificato e mostra
# il contesto (3 righe prima e dopo) con il nome del file.
# Supporta regex e ricerca case-insensitive.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELP_DIR="$(dirname "$SCRIPT_DIR")/help"

if [ ! -d "$HELP_DIR" ]; then
    echo "Errore: directory help/ non trovata in $(dirname "$SCRIPT_DIR")"
    exit 1
fi

case "${1:-}" in
    --list|-l)
        echo "=== Guide Disponibili ==="
        for f in "$HELP_DIR"/*.md; do
            name=$(basename "$f" .md)
            questions=$(grep -c '^- \[' "$f" 2>/dev/null || echo 0)
            echo "  $name — $questions domande"
        done
        echo ""
        echo "Totale: $(ls -1 "$HELP_DIR"/*.md 2>/dev/null | wc -l) guide"
        ;;
    --sources|-s)
        echo "=== Source craft-agents-tips ==="
        echo "  Path: ~/repos/craft-agents-tips"
        echo "  Help: ~/repos/craft-agents-tips/help/"
        echo "  GitHub: https://github.com/matrixNeo76/craft-agents-tips"
        echo ""
        echo "=== Guide ==="
        for f in "$HELP_DIR"/*.md; do
            lines=$(wc -l < "$f")
            name=$(basename "$f")
            printf "  %-30s %3d righe\n" "$name" "$lines"
        done
        ;;
    "")
        echo "Uso: $0 <pattern> [--context N]"
        echo "     $0 --list"
        echo "     $0 --sources"
        echo ""
        echo "Esempi:"
        echo "  $0 OAuth"
        echo "  $0 \"MCP server\" --context 5"
        echo "  $0 installazione"
        exit 1
        ;;
    *)
        pattern="$1"
        context="${2:-3}"

        # Se il secondo arg è --context, usa il terzo come numero
        if [ "$context" = "--context" ] && [ -n "${3:-}" ]; then
            context="$3"
        fi

        echo "=== Ricerca: '$pattern' ==="
        echo ""
        found=0
        for f in "$HELP_DIR"/*.md; do
            matches=$(grep -in "$pattern" "$f" 2>/dev/null)
            if [ -n "$matches" ]; then
                name=$(basename "$f")
                echo "--- $name ---"
                grep -in -C "$context" "$pattern" "$f" 2>/dev/null | head -40
                echo ""
                found=$((found + 1))
            fi
        done

        if [ "$found" -eq 0 ]; then
            echo "Nessun risultato per '$pattern'"
            echo "Suggerimento: prova con --list per vedere tutte le guide"
        else
            echo "Trovato in $found file"
        fi
        ;;
esac
