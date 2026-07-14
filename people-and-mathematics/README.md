# People and Mathematics · آدم‌ها و ریاضیات

A bilingual online journal for teaching, thinking, and conversation in mathematics.
A **Mathswell** publication.

---

## ✏️ How to change any wording (titles, articles, subtitles…)

**You only ever edit one file: `content.js`.**

1. In this repository, click **`content.js`**.
2. Click the **pencil ✏️ icon** (top-right of the file).
3. Change the words **between the "quotation marks"**. Each line is
   labelled in plain English (and the file has both `en` English and
   `fa` Persian sections).
4. Scroll down, click the green **Commit changes** button.
5. Wait ~30 seconds — the live site updates by itself.

**Three rules so nothing breaks:**
- Keep the `"quotation marks"` around every piece of text.
- Keep the comma `,` at the end of each line.
- Don't change the labels before the colon (`title:`, `dek:`, `name:` …).

> Safety net: if `content.js` ever has a typo, the site falls back to
> built-in default text instead of going blank. Fix the typo and commit
> again to restore your wording.

You never need to touch `index.html`.

---

## 🚀 Publishing on GitHub Pages

1. Create a repository (e.g. `people-and-mathematics`) and upload the
   contents of this `site/` folder to it (`index.html`, `content.js`,
   `assets/`, `fonts/`).
2. Repo **Settings → Pages → Build and deployment**:
   set **Source = Deploy from a branch**, **Branch = main / (root)**, Save.
3. After a minute your site is live at
   `https://<your-username>.github.io/<repo>/`.

### Use a mathswell.com subdomain (recommended)
So the link reads as part of your site (e.g. `journal.mathswell.com`):

1. In your DNS provider, add a **CNAME** record:
   `journal` → `<your-username>.github.io`
2. In repo **Settings → Pages → Custom domain**, enter
   `journal.mathswell.com` and Save. Tick **Enforce HTTPS** once it's ready.
3. Point the banner on mathswell.com at `https://journal.mathswell.com`.

(GitHub will create a `CNAME` file in the repo automatically — leave it.)

---

## 🔤 Persian font (B Nazanin)

The site uses **B Nazanin** for Persian. See **`fonts/README.txt`** —
drop a licensed `BNazanin.woff2` into the `fonts/` folder and it turns on
automatically. Until then Persian uses the free **Noto Naskh Arabic**
fallback so the site always looks right.

---

## 📄 The issue PDF (free download)

The file **`issue-01-print.html`** is the print-ready magazine layout.
To make the downloadable PDF:

1. Open `issue-01-print.html` in Chrome.
2. Press **Ctrl/Cmd + P** → Destination **Save as PDF**.
3. Paper **Letter**, Margins **None**, turn **ON** "Background graphics",
   turn **OFF** "Headers and footers".
4. Save it as **`issue-01.pdf`** and upload it next to `index.html`.

The homepage's **"Download the PDF"** button already points to
`issue-01.pdf` (set by `issuePdfUrl` in `content.js`).

To edit the issue's words, edit the text directly inside
`issue-01-print.html` — each page is marked with a clear comment.

## ❤️ "Pay what you like" support (Stripe)

The journal is free; support is a gift, never a gate.

1. In **Stripe → Payment Links**, create a link with
   **"Let customers choose what to pay"** turned ON.
2. Copy the link (it starts with `https://buy.stripe.com/…`).
3. Paste it into `content.js` as **`donateUrl`** and commit.

The **"Pay what you like"** button appears automatically once the link
is set, and stays hidden while it's empty.

## Files

- `index.html` — the homepage (design + layout). You rarely touch this.
- `content.js` — **all the wording**, plus `issuePdfUrl` and `donateUrl`.
- `issue-01-print.html` — the print-ready issue → Save as PDF.
- `assets/logo.jpg` — the logo.
- `fonts/` — put `BNazanin.woff2` here.
