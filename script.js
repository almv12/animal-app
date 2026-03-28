// ZooJoy — script.js

// ─── Telegram Web App init ───
if (window.Telegram && window.Telegram.WebApp) {
  const tg = window.Telegram.WebApp;
  tg.ready();
  tg.expand();
  // Sync theme colors with Telegram
  if (tg.colorScheme === 'dark') {
    document.documentElement.style.setProperty('--bg', '#1a1a1a');
    document.documentElement.style.setProperty('--white', '#2a2a2a');
    document.documentElement.style.setProperty('--text', '#f0f0f0');
  }
}

// ─── Fade-in on scroll ───
function initFadeIn() {
  const fadeEls = document.querySelectorAll('.fade-in');
  const fadeObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        fadeObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12 });
  fadeEls.forEach(el => fadeObserver.observe(el));
}

// ─── CountUp animation ───
function animateCounter(el) {
  const target = parseInt(el.dataset.target, 10);
  const duration = 1600;
  const start = performance.now();
  const update = (now) => {
    const elapsed = now - start;
    const progress = Math.min(elapsed / duration, 1);
    // easeOutExpo
    const eased = progress === 1 ? 1 : 1 - Math.pow(2, -10 * progress);
    el.textContent = Math.round(eased * target);
    if (progress < 1) requestAnimationFrame(update);
  };
  requestAnimationFrame(update);
}

function initCounters() {
  const statNumbers = document.querySelectorAll('.stat__number');
  const statsObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        statsObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.3 });
  statNumbers.forEach(el => statsObserver.observe(el));
}

// ─── Hamburger menu ───
function initHamburger() {
  const hamburger = document.getElementById('hamburger');
  const nav = document.getElementById('nav');
  if (!hamburger || !nav) return;
  hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('open');
    nav.classList.toggle('open');
  });
  nav.querySelectorAll('.nav__link').forEach(link => {
    link.addEventListener('click', () => {
      hamburger.classList.remove('open');
      nav.classList.remove('open');
    });
  });
}

// ─── Sticky header shadow ───
function initStickyHeader() {
  const header = document.getElementById('header');
  if (!header) return;
  window.addEventListener('scroll', () => {
    header.style.boxShadow = window.scrollY > 10 ? '0 2px 20px rgba(0,0,0,0.08)' : 'none';
  }, { passive: true });
}

// ─── Active nav ───
function setActiveNav() {
  const page = document.body.dataset.page;
  document.querySelectorAll('.nav__link[data-target]').forEach(a => {
    a.classList.toggle('active', a.dataset.target === page);
  });
}

// ─── Init components (header/footer inlined — no fetch needed) ───
function loadComponents() {
  // Header and footer are now inlined in each HTML file
  // Just init the interactive parts
  initHamburger();
  initStickyHeader();
  setActiveNav();
  const yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();
  return Promise.resolve();
}

// ─── Telegram BackButton ───
function initTelegramBackButton(targetPage = '/index.html') {
  if (window.Telegram?.WebApp?.BackButton) {
    if (document.body.dataset.page === 'home') {
      Telegram.WebApp.BackButton.hide();
    } else {
      Telegram.WebApp.BackButton.show();
      Telegram.WebApp.BackButton.onClick(() => {
        window.location.href = targetPage;
      });
    }
  }
}

// ─── Catalog filters ───
function initCatalogFilters() {
  const filterGroups = {
    type: 'all',
    city: 'all',
    status: 'all'
  };

  function applyFilters() {
    const cards = document.querySelectorAll('.animal-card');
    let visible = 0;
    cards.forEach(card => {
      const show =
        (filterGroups.type === 'all' || card.dataset.type === filterGroups.type) &&
        (filterGroups.city === 'all' || card.dataset.city === filterGroups.city) &&
        (filterGroups.status === 'all' || card.dataset.status === filterGroups.status);
      card.classList.toggle('hidden', !show);
      if (show) visible++;
    });
    const noResults = document.getElementById('no-results');
    if (noResults) noResults.classList.toggle('hidden', visible > 0);
  }

  document.querySelectorAll('[data-filter-type]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('[data-filter-type]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      filterGroups.type = btn.dataset.filterType;
      applyFilters();
    });
  });

  document.querySelectorAll('[data-filter-city]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('[data-filter-city]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      filterGroups.city = btn.dataset.filterCity;
      applyFilters();
    });
  });

  document.querySelectorAll('[data-filter-status]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('[data-filter-status]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      filterGroups.status = btn.dataset.filterStatus;
      applyFilters();
    });
  });
}

// ─── Shelter city filter (visual only) ───
function initShelterFilter() {
  document.querySelectorAll('[data-shelter-city]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('[data-shelter-city]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
    });
  });
}

// ─── Apply tabs ───
function initApplyTabs() {
  const tabs = document.querySelectorAll('.apply-tab');
  const forms = document.querySelectorAll('.apply-form-block');

  if (!tabs.length) return;

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      tabs.forEach(t => t.classList.remove('active'));
      forms.forEach(f => f.classList.add('hidden'));
      tab.classList.add('active');
      const target = document.getElementById(tab.dataset.target);
      if (target) target.classList.remove('hidden');
    });
  });

  document.querySelectorAll('.apply-form-block form').forEach(form => {
    form.addEventListener('submit', e => {
      e.preventDefault();
      form.classList.add('hidden');
      const successMsg = form.nextElementSibling;
      if (successMsg) successMsg.classList.remove('hidden');
    });
  });
}

// ─── DOMContentLoaded ───
document.addEventListener('DOMContentLoaded', () => {
  loadComponents().then(() => {
    initTelegramBackButton();
  });

  initFadeIn();
  initCounters();
  initCatalogFilters();
  initShelterFilter();
  initApplyTabs();
});
