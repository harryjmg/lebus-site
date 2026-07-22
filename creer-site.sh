#!/usr/bin/env bash
#
# creer-site.sh — crée un site GitHub Pages de A à Z, sans un seul clic.
# C'est la partie 100 % automatisable de la méthode (l'achat du domaine et le
# DNS restent manuels — voir GUIDE.md).
#
# Prérequis (une fois) :
#   1. Installer GitHub CLI : https://cli.github.com  (macOS : brew install gh)
#   2. Se connecter :          gh auth login
#
# Usage :
#   ./creer-site.sh mon-site            # part d'une page d'exemple
#   ./creer-site.sh mon-site page.html  # utilise ta propre page comme index.html
#
set -euo pipefail

REPO="${1:?Usage: ./creer-site.sh <nom-du-repo> [fichier-html]}"
SRC_HTML="${2:-}"
USER="$(gh api user --jq .login)"

mkdir -p "$REPO" && cd "$REPO"

# La page : soit celle fournie, soit un exemple minimal.
if [ -n "$SRC_HTML" ]; then
  cp "../$SRC_HTML" index.html
elif [ ! -f index.html ]; then
  cat > index.html <<'HTML'
<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Mon site</title>
<style>body{font-family:system-ui;max-width:40rem;margin:15vh auto;padding:0 1rem;line-height:1.6}</style>
<h1>Ça marche&nbsp;🎉</h1>
<p>Ma première page, hébergée gratuitement par GitHub Pages.</p>
</html>
HTML
fi

# Dépôt + push
git init -q
git add -A
git -c commit.gpgsign=false commit -qm "Premier site"
gh repo create "$USER/$REPO" --public --source . --remote origin --push >/dev/null

# Activer GitHub Pages (branche main, racine)
echo '{"source":{"branch":"main","path":"/"}}' \
  | gh api "repos/$USER/$REPO/pages" -X POST --input - >/dev/null

echo "✅ Repo créé et Pages activé."
echo "   En ligne dans ~1 minute : https://$USER.github.io/$REPO/"
echo
echo "   Étapes suivantes (manuelles) : acheter un domaine + régler le DNS."
echo "   → voir GUIDE.md, parties B et C."
