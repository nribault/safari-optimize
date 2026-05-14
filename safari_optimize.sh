#!/bin/bash
set -euo pipefail

# Vérification macOS 13+ (Ventura minimum)
OS_VERSION=$(sw_vers -productVersion)
OS_MAJOR=$(echo "$OS_VERSION" | cut -d'.' -f1)
if [[ "$OS_MAJOR" -lt 13 ]]; then
  echo "❌ macOS $OS_VERSION non supporté — Ventura 13 minimum requis."
  exit 1
fi

echo "🔍 macOS $OS_VERSION détecté"

# Sauvegarde des valeurs existantes
BACKUP_FILE="$HOME/.safari_defaults_backup_$(date +%Y%m%d_%H%M%S).plist"
defaults export com.apple.Safari "$BACKUP_FILE" 2>/dev/null \
  && echo "💾 Sauvegarde créée : $BACKUP_FILE" \
  || echo "⚠️  Impossible de créer une sauvegarde (Safari jamais lancé ?)"

# --- Confidentialité ---

# Prévention du traçage inter-sites (ITP) — valide jusqu'à Safari 18
defaults write com.apple.Safari WebKitPreferences.storageBlockingPolicy -int 1

# Désactiver la géolocalisation automatique
defaults write com.apple.Safari SafariGeolocationPermissionPolicy -int 0

# Ne pas partager les données d'utilisation avec Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Masquer l'URL complète dans la barre d'adresse (désactivé = affiche le domaine complet)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Bloquer les cookies tiers (recommandé pour la vie privée)
defaults write com.apple.Safari BlockStoragePolicy -int 2

# --- Performances ---

# Désactiver l'ouverture automatique des pop-ups JavaScript
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Désactiver le préchargement de la page d'accueil (réduit la consommation réseau)
defaults write com.apple.Safari PreloadTopHit -bool false

# --- Moteur de recherche ---
defaults write com.apple.Safari SearchProviderIdentifier -string "com.duckduckgo"
defaults write com.apple.Safari SearchProviderShortName -string "DuckDuckGo"

# --- Sécurité ---

# Avertir si le site est potentiellement frauduleux (SafeBrowsing Apple)
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Ne pas ouvrir automatiquement les fichiers téléchargés
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# --- Extensions Safari via mas ---

install_extension() {
  local name="$1"
  local app_id="$2"

  if mas list | grep -q "^$app_id"; then
    echo "✅ $name déjà installé"
  else
    echo "📦 Installation de $name..."
    mas install "$app_id" && echo "✅ $name installé" || echo "⚠️  Échec installation $name (vérifier l'App Store)"
  fi
}

if ! command -v brew &>/dev/null; then
  echo "📦 Installation de Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Charger brew dans le PATH selon l'architecture (Apple Silicon vs Intel)
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if ! command -v mas &>/dev/null; then
  if command -v brew &>/dev/null; then
    echo "📦 Installation de mas (Mac App Store CLI)..."
    brew install mas
  else
    echo "⚠️  Homebrew introuvable après installation — extensions ignorées."
  fi
fi

if command -v mas &>/dev/null; then
  install_extension "AdGuard for Safari" 1440147259
  install_extension "Hush"               1544743900
  echo "ℹ️  Activer les extensions : Safari > Réglages > Extensions"
fi

# --- Redémarrage propre de Safari ---
if pgrep -x Safari &>/dev/null; then
  echo "🔄 Fermeture propre de Safari..."
  osascript -e 'tell application "Safari" to quit' 2>/dev/null || killall Safari
  sleep 1
fi

echo "✅ Safari optimisé — macOS $OS_VERSION"
echo "   Pour annuler : defaults import com.apple.Safari \"$BACKUP_FILE\""
