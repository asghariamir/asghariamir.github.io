/* People and Mathematics — GoatCounter (tracking + public visible counts).
   One line per page: include this file just before </body>.
   Requires "Allow adding visitor counts on your website" to be ON in
   GoatCounter → Settings, otherwise the visible number stays hidden
   (tracking still works). */
(function () {
  if (location.protocol === "file:") return;
  var HOST = "https://amirasghari.goatcounter.com";

  /* 1 — tracking */
  var s = document.createElement("script");
  s.async = true;
  s.src = "https://gc.zgo.at/count.js";
  s.setAttribute("data-goatcounter", HOST + "/count");
  document.head.appendChild(s);

  /* 2 — public visible count (site total on the homepage, per-page elsewhere) */
  var path = location.pathname;
  var isHome = /\/$|\/index\.html$/.test(path);
  var url = HOST + "/counter/" + (isHome ? "TOTAL" : encodeURI(path)) + ".json";

  fetch(url)
    .then(function (r) { return r.ok ? r.json() : null; })
    .then(function (d) {
      if (!d || !d.count) return;
      var n = String(d.count).replace(/[\s\u2009\u00a0]+/g, ",").trim();
      var el = document.createElement("div");
      el.setAttribute("data-pm-views", "");
      el.style.cssText =
        "font-family:'Hanken Grotesk','Vazirmatn',sans-serif;" +
        "font-size:11px;letter-spacing:.1em;color:#948876;" +
        "text-align:center;padding:8px 20px 30px;direction:ltr;";
      el.textContent = isHome
        ? n + " visits so far · " + "\u062a\u0627\u06a9\u0646\u0648\u0646 " + n + " \u0628\u0627\u0632\u062f\u06cc\u062f"
        : n + " views · " + n + " \u0628\u0627\u0632\u062f\u06cc\u062f";
      document.body.appendChild(el);
    })
    .catch(function () {});
})();
