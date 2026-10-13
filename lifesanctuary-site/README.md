# Life Sanctuary Church — website

A one-page church website in the style of TheChurchCo templates: full-screen hero,
service-times bar, "What to expect", ministry tiles, latest sermon, events, giving and footer.

Plain HTML/CSS/JS — no build step. Open `index.html` in a browser, or upload the folder
to any static host (Netlify, GitHub Pages, cPanel, etc.).

## Fill in before going live

Everything in `[square brackets]` is a placeholder:

- Service times and address (service-times bar and footer)
- Church story / pastors paragraph (About section)
- Sermon series title and video — paste a YouTube `<iframe>` in place of `.video-placeholder`
- Upcoming events
- Email, phone and social media links (footer)
- Give button link (point it at your giving provider)

## Photos

The coloured boxes are stand-ins for photos. Add images to an `images/` folder and set them in
`styles.css`, e.g.:

```css
.hero-bg { background: url("images/hero.jpg") center / cover; }
.media-1 { background-image: url("images/worship.jpg"); }
```

## Brand colours

Change `--brand` (gold accent) and the fonts at the top of `styles.css`.

## Staging

Staging is served by GitHub Pages straight from the `claude/admiring-brown-bxnrg7` branch
(Settings → Pages → Deploy from a branch → that branch, `/ (root)`):
https://robinbannis.github.io/firstapp/

The root `index.html` redirects there, and `.nojekyll` makes Pages serve files as they are.
The page carries `<meta name="robots" content="noindex">` so search engines skip staging —
remove that line when it goes to lifesanctuary.church.
