# safari-optimize

Script Bash pour optimiser Safari sur macOS (Ventura 13+, Sonoma 14+, Sequoia 15+).

Applique des réglages de **confidentialité**, de **sécurité** et de **performances** via `defaults write`, avec sauvegarde automatique et rollback intégré.

## Fonctionnalités

- Bloque les cookies tiers et le stockage des traceurs
- Désactive les suggestions de recherche universelle
- Force DuckDuckGo comme moteur de recherche
- Désactive l'ouverture automatique des téléchargements
- Active les avertissements de sites frauduleux
- Sauvegarde les réglages existants avant modification
- Fermeture propre de Safari via AppleScript

## Compatibilité

| macOS | Version Safari | Statut |
|---|---|---|
| Sequoia 15.x | Safari 18 | ✅ Testé |
| Sonoma 14.x | Safari 17 | ✅ Testé |
| Ventura 13.x | Safari 16 | ✅ Supporté |
| Monterey 12.x et antérieur | — | ❌ Non supporté |

## Utilisation

```bash
chmod +x safari_optimize.sh
./safari_optimize.sh
```

Le script crée automatiquement un fichier de sauvegarde `~/.safari_defaults_backup_YYYYMMDD_HHMMSS.plist`.

## Rollback

```bash
defaults import com.apple.Safari ~/.safari_defaults_backup_<timestamp>.plist
```

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
