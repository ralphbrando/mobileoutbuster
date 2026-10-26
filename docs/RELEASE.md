# Outbuster : visuels et chaîne de compilation

Projet Codemagic : https://codemagic.io/app/6adf2390a506dbe905d07c09/settings

Dépôt Flutter : `ralphbrando/mobileoutbuster`, branche `codex/outbuster-release-setup`.
Le projet Codemagic historique `outbuster` vise le dépôt Laravel, pas cette application.

## Visuels

Les sources sont dans `assets/branding/`. Le mot-symbole haute définition et le fond cinéma
ont été produits avec ImageGen à partir de l'identité existante. Les tailles et marges sont
exportées de façon déterministe par `dart run tool/generate_brand_assets.dart`.

- `outbuster-wordmark-master.png` : source transparente haute définition.
- `cinema-background.png` : fond portrait noir et jaune cinéma.
- `app-icon.png` : icône opaque 1024 × 1024.
- `adaptive-foreground.png` : premier plan Android avec marge pour le masque.
- `splash-logo.png` : mot-symbole natif 960 × 360.
- `splash-android12.png` : canevas transparent 1152 × 1152, logo dans la zone sûre.
- `splash-preview.png` : aperçu de composition 1080 × 1920.
- `test/previews/` : captures des widgets Flutter réels, exportées par les tests.

Le lancement natif Android/iOS/web affiche le logo sur fond noir. Dès la première image
Flutter, le fond cinéma apparaît ; l'accueil reprend ce fond et le bouton Démarrer.
Poppins est embarquée avec sa licence OFL pour éviter un téléchargement au lancement.

Régénération :

```sh
flutter pub get
dart run tool/generate_brand_assets.dart
dart run flutter_launcher_icons
dart run flutter_native_splash:create
OUTBUSTER_EXPORT_PREVIEWS=true flutter test test/launch_screen_test.dart --update-goldens
```

## Workflows Codemagic

Tous sont manuels. Aucun déclencheur automatique ni notification par email n'est ajouté.

| Workflow | Résultat | Accès aux stores requis |
| --- | --- | --- |
| `web-preview` | analyse, tests et ZIP web | Non |
| `android-preview` | APK debug installable | Non |
| `ios-preview` | application pour simulateur iOS | Non |
| `android-release` | AAB signé, envoi en brouillon sur la piste interne Google Play | Oui |
| `ios-release` | IPA signée, upload App Store Connect | Oui |

Flutter est fixé à 3.35.7, version vérifiée sur le poste local. Les releases ne sont
pas prêtes à exécuter avant la configuration des secrets spécifiques à Outbuster.
La branche doit être sélectionnée dans Codemagic puis les fichiers rechargés.

## Identité des applications à confirmer après invitation

Le code source déclare `com.outbuster.app` sur Android et iOS. L'application Apple historique
porte l'identifiant numérique `6447878468` (confirmé par les notifications Apple).
Il faut comparer les identifiants de package/bundle aux fiches existantes dans les consoles,
et corriger le dépôt ainsi que le YAML s'ils diffèrent. Ne pas créer une nouvelle fiche.
Après vérification, définir `OUTBUSTER_STORE_IDS_CONFIRMED=true` dans chaque groupe de release.

Invitations demandées :

- Google Play Console : **admin@ralphbrando.com**.
- App Store Connect / Apple Developer : **contact@billard-brando.com**.

## Secrets propres à l'application

Les groupes suivants sont créés dans les réglages de **mobileoutbuster**, avec
`OUTBUSTER_STORE_IDS_CONFIRMED=false`. Les secrets de signature restent à renseigner.
Ne pas reprendre les groupes ou les certificats d'un autre projet.

Groupe `outbuster_android_release` :

- `OUTBUSTER_KEYSTORE_BASE64` : clé d'upload existante, encodée en base64.
- `OUTBUSTER_KEYSTORE_PASSWORD`, `OUTBUSTER_KEY_ALIAS`, `OUTBUSTER_KEY_PASSWORD`.
- `GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS` : JSON du compte de service autorisé sur Outbuster.
- `OUTBUSTER_STORE_IDS_CONFIRMED=true` après contrôle des identifiants.

Groupe `outbuster_ios_release` :

- `APP_STORE_CONNECT_PRIVATE_KEY`, `APP_STORE_CONNECT_KEY_IDENTIFIER`, `APP_STORE_CONNECT_ISSUER_ID`.
- `CERTIFICATE_PRIVATE_KEY` : clé privée correspondant au certificat de distribution existant.
- `OUTBUSTER_STORE_IDS_CONFIRMED=true` après contrôle des identifiants.

Le workflow iOS récupère les profils existants, sans en créer automatiquement. Si les anciens
certificats ne sont plus valides, il faudra préparer la signature à partir du compte Apple.
Les numéros de build sont lus dans chaque store puis incrémentés ; une erreur de lecture bloque
la release, afin de ne pas réutiliser un numéro existant. Le nom de version préparé est 1.0.2.
Google Play reçoit un brouillon interne. L'upload iOS ne soumet ni à la revue TestFlight ni à
la publication App Store. Les contrôles de conformité store restent à effectuer avant diffusion.

Une archive de clés historiques est mentionnée dans le mail d'Axel du 21 mars 2022 ; elle n'a pas
été ouverte, copiée dans le dépôt ou importée dans Codemagic pendant cette préparation.

## Validation

Les tests vérifient le rendu sans dépassement sur petit téléphone, paysage et tablette,
l'action du bouton Démarrer et l'absence de bouton pendant le chargement.
L'analyse signale encore des avertissements historiques sans erreur bloquante après correction
de l'ancien nom de paramètre `videoid` lors de l'ouverture du lecteur depuis SeasonCard.
Les tests visuels sont isolés et ne contactent pas Firebase ou l'API de production.

Validation locale du 26 octobre 2026 : analyse Dart sans erreur, quatre tests de lancement
réussis (dont deux exports visuels), compilation web de production réussie et APK Android
debug compilé avec succès. La compilation et la signature iOS ne sont pas encore validées.

Première exécution Codemagic `web-preview` réussie le 26 octobre 2026, incluant
l'analyse, les tests, la compilation et la création de l'archive web :
https://codemagic.io/app/6adf2390a506dbe905d07c09/build/6adf27bf4a72334e32e548ca

Documentation de référence :

- https://docs.codemagic.io/yaml-quick-start/building-a-flutter-app/
- https://docs.codemagic.io/yaml-publishing/google-play/
- https://docs.codemagic.io/yaml-code-signing/alternative-code-signing-methods/
- https://pub.dev/packages/flutter_native_splash
