# Le bus — landing page

Site vitrine de l'app **Le bus** (méditations guidées), hébergé gratuitement par
**GitHub Pages**. Un seul fichier `index.html`, aucune dépendance, aucun build.

---

## 🎯 La méthode, pour débutants (repro en 15 min)

Cette page sert d'exemple. Voici la recette complète pour publier n'importe quel
site vitrine sur un domaine à toi. **80 % est automatisable ; il reste ~5 min
manuelles chez le registrar** (achat + DNS) — ces deux étapes touchent à l'argent
et à ton compte, aucun outil ne les fait à ta place.

### 1. Le site (automatisé)
```bash
gh repo create <compte>/mon-site --public --source . --push
gh api repos/<compte>/mon-site/pages -X POST -f source.branch=main -f source.path=/
```
→ En ligne sur `https://<compte>.github.io/mon-site/` après ~1 min.

### 2. Le domaine (manuel — action financière)
Achète le domaine chez un registrar. Pour un débutant :
- **Cloudflare Registrar** — prix coûtant, DNS au même endroit, le plus extensible.
- **Namecheap** ou **Porkbun** — panneau clair, `.com` pas cher la 1ʳᵉ année.

### 3. Le DNS (manuel — copier-coller, identique partout)
Dans le panneau DNS du registrar, ajoute **exactement** ces 5 lignes :

| Type  | Nom | Valeur                 |
|-------|-----|------------------------|
| A     | @   | 185.199.108.153        |
| A     | @   | 185.199.109.153        |
| A     | @   | 185.199.110.153        |
| A     | @   | 185.199.111.153        |
| CNAME | www | `<compte>.github.io`   |

> ⚠️ **Cloudflare** : mettre chaque enregistrement en **« DNS only » (nuage gris)**,
> jamais proxifié, sinon conflit avec le certificat HTTPS de GitHub Pages.

### 4. Lier le domaine à Pages (automatisé)
```bash
echo "mondomaine.com" > CNAME
git add CNAME && git commit -m "Domaine personnalisé" && git push
gh api repos/<compte>/mon-site/pages -X PUT -f cname=mondomaine.com -F https_enforced=true
```
GitHub crée seul la redirection `www → apex` et le certificat HTTPS (quelques minutes).

---

## Modifier le contenu
Tout est dans `index.html`. Les liens App Store / Google Play sont des `href="#"`
à remplacer (cherche les commentaires `<!-- Remplace ... -->`). Un `git push`
publie automatiquement.
