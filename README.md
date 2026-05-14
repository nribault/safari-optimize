# safari-optimize

Script Bash pour optimiser Safari sur macOS (Ventura 13+, Sonoma 14+, Sequoia 15+).

Applique des réglages de **confidentialité**, de **sécurité** et de **performances** via `defaults write`, installe les extensions recommandées via le Mac App Store, avec sauvegarde automatique et rollback intégré.

## Fonctionnalités

**Confidentialité & Sécurité**
- Bloque les cookies tiers et le stockage des traceurs (ITP)
- Désactive la géolocalisation automatique
- Désactive les suggestions de recherche universelle Apple
- Force DuckDuckGo comme moteur de recherche
- Désactive l'ouverture automatique des téléchargements
- Active les avertissements de sites frauduleux
- Affiche l'URL complète dans la barre d'adresse

**Performances**
- Désactive l'ouverture automatique des pop-ups JavaScript
- Désactive le préchargement réseau de la page d'accueil

**Extensions Safari** (installation automatique via Mac App Store)
- [AdGuard for Safari](https://adguard.com/fr/adguard-safari/overview.html) — bloqueur de publicités et de traceurs
- [Hush](https://oblador.github.io/hush/) — suppression des bandeaux de consentement cookies

**Automatisation**
- Installation automatique de [Homebrew](https://brew.sh) si absent
- Installation automatique de [mas](https://github.com/mas-cli/mas) (Mac App Store CLI) si absent
- Sauvegarde des réglages existants avant toute modification
- Fermeture propre de Safari via AppleScript

## Compatibilité

| macOS | Version Safari | Statut |
|---|---|---|
| Tahoe 26.x | Safari 19 | ✅ Testé |
| Sequoia 15.x | Safari 18 | ✅ Testé |
| Sonoma 14.x | Safari 17 | ✅ Supporté |
| Ventura 13.x | Safari 16 | ✅ Supporté |
| Monterey 12.x et antérieur | — | ❌ Non supporté |

## Utilisation

```bash
chmod +x safari_optimize.sh
./safari_optimize.sh
```

Le script gère automatiquement les dépendances (Homebrew, mas) si elles sont absentes.

Après exécution, **activer les extensions manuellement** : Safari > Réglages > Extensions.

## Rollback

```bash
defaults import com.apple.Safari ~/.safari_defaults_backup_<timestamp>.plist
```

Le chemin exact du fichier de sauvegarde est affiché à la fin de chaque exécution.

## Réglages appliqués

| Clé | Valeur | Effet |
|---|---|---|
| `WebKitPreferences.storageBlockingPolicy` | `1` | Bloque le stockage des traceurs (ITP) |
| `BlockStoragePolicy` | `2` | Bloque les cookies tiers en navigation privée |
| `SafariGeolocationPermissionPolicy` | `0` | Désactive la géolocalisation automatique |
| `UniversalSearchEnabled` | `false` | Désactive la recherche universelle Apple |
| `SuppressSearchSuggestions` | `true` | Désactive les suggestions dans la barre d'adresse |
| `ShowFullURLInSmartSearchField` | `true` | Affiche l'URL complète |
| `WebKitJavaScriptCanOpenWindowsAutomatically` | `false` | Bloque les popups JS |
| `PreloadTopHit` | `false` | Désactive le préchargement réseau |
| `SearchProviderIdentifier` | `com.duckduckgo` | Moteur de recherche DuckDuckGo |
| `WarnAboutFraudulentWebsites` | `true` | Avertissement sites frauduleux |
| `AutoOpenSafeDownloads` | `false` | Désactive l'ouverture auto des téléchargements |

## Licence

MIT
