# Créer son site web avec son nom de domaine

**Gratuit, sans code, sans terminal — environ 30 minutes.**

À la fin, tu auras un vrai site en ligne sur *ton* adresse (`tonnom.com`),
hébergé gratuitement par GitHub. Il n'y a que **3 briques** :

- **A.** Le site, hébergé sur GitHub
- **B.** Le nom de domaine, acheté chez un registrar
- **C.** Brancher les deux ensemble

> Il te faut : une adresse e-mail, et une carte bancaire pour le domaine
> (compte ~10 à 15 € par an — c'est la seule dépense).

---

## Partie A — Le site sur GitHub (gratuit)

1. **Créer un compte** sur [github.com](https://github.com) → *Sign up*.
2. **Nouveau dépôt** : bouton **+** en haut à droite → *New repository*.
   - *Repository name* : `mon-site` (ou ce que tu veux)
   - Coche **Public**
   - Clique **Create repository**
3. **Ajouter ta page** : dans le dépôt, *Add file* → *Create new file*.
   - Nomme le fichier **`index.html`**
   - Colle le contenu de ta page dans la grande zone de texte
   - En bas, clique **Commit changes**
4. **Activer l'hébergement** : onglet **Settings** du dépôt → menu **Pages** (à gauche).
   - *Source* : **Deploy from a branch**
   - *Branch* : **main**, dossier **/ (root)** → **Save**
5. **Attends ~1 minute**, puis rafraîchis la page. Ton site est en ligne sur :
   **`https://<ton-pseudo>.github.io/mon-site/`** 🎉

À ce stade le site marche déjà. Les parties B et C servent juste à lui donner
**ta** propre adresse.

### ⚡ Variante automatisée (toute la partie A en une commande)

Cette partie A est la **seule étape 100 % automatisable** de la méthode. Au lieu
des 5 clics ci-dessus, on peut tout faire d'un coup avec l'outil **GitHub CLI**
(`gh`) et le script **[`creer-site.sh`](creer-site.sh)** fourni :

```bash
# Une seule fois : installer et se connecter
brew install gh        # (macOS ; sinon https://cli.github.com)
gh auth login

# Créer le dépôt + la page + activer Pages, d'un coup :
./creer-site.sh mon-site            # avec une page d'exemple
./creer-site.sh mon-site page.html  # ou avec ta propre page
```

Le script crée le dépôt public, pousse ton `index.html` et active Pages tout
seul, puis affiche l'URL en ligne. Idéal si tu prépares plusieurs sites (ou si
tu montes le site *pour* tes élèves). Pour un élève seul qui le fait une fois,
les 5 clics ci-dessus restent le plus simple — aucune installation.

> *L'achat du domaine (B) et le DNS (C) ne s'automatisent pas ainsi : ils
> touchent au paiement et au compte du registrar. Ils restent manuels.*

---

## Partie B — Le nom de domaine

Choisis **un** registrar. Achète **le domaine seul** : à chaque étape, **refuse
toutes les options** (hébergement, e-mails, « DNS premium »…). Tu n'en as besoin
d'aucune, GitHub fait l'hébergement gratuitement.

### Option 1 — Cloudflare *(le moins cher, prix coûtant)*
1. Crée un compte sur [dash.cloudflare.com](https://dash.cloudflare.com).
2. Menu **Domain Registration → Register Domains**.
3. Tape le nom voulu, ajoute au panier, paie. **Rien d'autre à cocher.**

### Option 2 — OVH *(support en français, si tu ne sais pas où aller)*
1. Va sur [ovhcloud.com](https://www.ovhcloud.com) → **Noms de domaine**.
2. Cherche ton nom. À chaque écran, **décoche / refuse** les options
   (hébergement, adresses e-mail, etc.).
3. Paie. La **gestion DNS est incluse gratuitement** — c'est tout ce qu'il faut.

---

## Partie C — Brancher le domaine sur le site

La seule partie un peu technique. C'est partout la même idée : **5 lignes** à
recopier dans la « zone DNS » de ton domaine.

### C1. Ouvrir la zone DNS
- **Cloudflare** : ton domaine → onglet **DNS** → **Records**.
- **OVH** : espace client → ton domaine → onglet **Zone DNS**.

### C2. Ajouter ces 5 enregistrements

| Type  | Nom (Name) | Valeur (cible)          |
|-------|------------|-------------------------|
| A     | `@`        | `185.199.108.153`       |
| A     | `@`        | `185.199.109.153`       |
| A     | `@`        | `185.199.110.153`       |
| A     | `@`        | `185.199.111.153`       |
| CNAME | `www`      | `<ton-pseudo>.github.io` |

*(`@` = ton domaine « nu ». Remplace `<ton-pseudo>` par ton pseudo GitHub.)*

> ⚠️ **Si tu es chez Cloudflare** : chaque ligne doit être en **« DNS only »
> (nuage GRIS)**, pas « Proxied » (nuage orange). Clique le nuage pour le passer
> au gris. C'est l'erreur n°1 : le nuage orange empêche le cadenas HTTPS.
>
> ⚠️ **Si tu es chez OVH** : supprime d'abord la ligne **A** déjà présente sur
> `@` (elle pointe vers une page OVH), puis ajoute les 4 lignes A ci-dessus.

### C3. Dire son domaine à GitHub
Dépôt → **Settings** → **Pages** → champ **Custom domain** → tape
`tondomaine.com` (**sans** le `www`) → **Save**.
GitHub vérifie le DNS — ça peut prendre de quelques minutes à quelques heures la
première fois.

### C4. Activer le cadenas (HTTPS)
Quand la case **Enforce HTTPS** devient cliquable (GitHub a fabriqué le
certificat — de quelques minutes à 24 h), **coche-la**.

### C5. Terminé
Va sur **`https://tondomaine.com`** : ton site s'affiche avec le cadenas 🔒.
Le `www` redirige tout seul vers l'adresse principale.

---

## Si ça ne marche pas (dépannage)

- **Pas de cadenas / « certificate pending »** : normal les premières heures,
  GitHub fabrique le certificat. Attends, puis reviens cocher *Enforce HTTPS*.
- **Rien ne s'affiche sur ton domaine** : la propagation DNS peut prendre jusqu'à
  24 h. Vérifie sur [dnschecker.org](https://dnschecker.org) que ton domaine
  pointe bien vers les IP `185.199.108/109/110/111.153`.
- **Cloudflare** : le nuage est-il bien **GRIS** ?
- **OVH** : reste-t-il une **ancienne ligne A** sur `@` qui pointe ailleurs ?
  Supprime-la.

---

## Récapitulatif express

| Ordre | Où | Quoi |
|------:|----|------|
| **0** | GitHub | Dépôt public + `index.html` + Pages activé |
| **1** | Registrar | Acheter le domaine seul (aucune option) |
| **2** | Zone DNS | 4 lignes A + 1 CNAME `www` |
| **3** | GitHub → Pages | *Custom domain* + cocher *Enforce HTTPS* |

Compte quelques heures max entre l'étape 2 et le site visible sur ton domaine
(le temps que le DNS et le certificat se mettent en place).
