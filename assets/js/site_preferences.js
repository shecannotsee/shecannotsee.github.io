(function () {
  function applyTheme(theme) {
    var root = document.documentElement;
    root.dataset.theme = theme;
    root.style.colorScheme = theme;
    try {
      localStorage.setItem("site-theme", theme);
    } catch (error) {}
  }

  function applyLang(lang) {
    var root = document.documentElement;
    root.dataset.lang = lang;
    root.lang = lang === "en" ? "en" : "zh-CN";
    try {
      localStorage.setItem("site-lang", lang);
    } catch (error) {}
  }

  function syncButtons() {
    var root = document.documentElement;
    var theme = root.dataset.theme || "light";
    var lang = root.dataset.lang || "zh";

    document.querySelectorAll("[data-theme-value]").forEach(function (button) {
      var active = button.getAttribute("data-theme-value") === theme;
      button.setAttribute("aria-pressed", active ? "true" : "false");
      button.classList.toggle("is-active", active);
    });

    document.querySelectorAll("[data-lang-value]").forEach(function (button) {
      var active = button.getAttribute("data-lang-value") === lang;
      button.setAttribute("aria-pressed", active ? "true" : "false");
      button.classList.toggle("is-active", active);
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-theme-value]").forEach(function (button) {
      button.addEventListener("click", function () {
        applyTheme(button.getAttribute("data-theme-value"));
        syncButtons();
      });
    });

    document.querySelectorAll("[data-lang-value]").forEach(function (button) {
      button.addEventListener("click", function () {
        applyLang(button.getAttribute("data-lang-value"));
        syncButtons();
      });
    });

    syncButtons();
  });
})();
