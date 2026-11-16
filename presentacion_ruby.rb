#!/usr/bin/env ruby
# frozen_string_literal: true

# ==============================================================================
#  Presentación Académica 16:9 en Tiempo Real — Programada en Ruby
#  - Lienzo fijo 1280x720 (16:9 exacto), cero scrollbars, cero botones
#  - Único input: flechas ← y →
#  - Imágenes reales PNG (ruby.png del kit, matz.png, rubygems.png, Ruby-on-Rails-Logo.png)
#  - Layouts variados (línea de tiempo, pipeline, tarjetas, tablas, consola en vivo)
# ==============================================================================

require "webrick"
require "json"
require "open3"
require "timeout"
require "erb"

PORT = (ENV["PORT"] || 4567).to_i
DATA_FILE = File.join(__dir__, "data", "slides_data.json")
SLIDES = JSON.parse(File.read(DATA_FILE, encoding: "UTF-8"))

IMG_DIR = File.join(__dir__, "assets", "img")
ALLOWED_IMAGES = {
  "ruby.png" => File.join(IMG_DIR, "ruby.png"),
  "matz.png" => File.join(IMG_DIR, "matz.png"),
  "rubygems.png" => File.join(IMG_DIR, "rubygems.png"),
  "Ruby-on-Rails-Logo.png" => File.join(IMG_DIR, "Ruby-on-Rails-Logo.png")
}.freeze

HTML_PAGE = <<~'HTML'
  <!DOCTYPE html>
  <html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ruby · Presentación</title>
    <style>
      :root {
        --ruby: #e11d48;
        --ruby-bright: #ff4d6d;
        --ruby-soft: rgba(225, 29, 72, 0.20);
        --text: #f8fafc;
        --muted: #94a3b8;
        --green: #34d399;
        --amber: #fbbf24;
        --border: rgba(255, 255, 255, 0.11);
      }
      * {
        box-sizing: border-box;
        scrollbar-width: none;
      }
      *::-webkit-scrollbar { display: none; }
      html, body {
        margin: 0;
        padding: 0;
        width: 100vw;
        height: 100vh;
        overflow: hidden;
        background: #020306;
        font-family: "Inter", "Segoe UI", system-ui, -apple-system, sans-serif;
        color: var(--text);
        display: flex;
        align-items: center;
        justify-content: center;
        user-select: none;
      }

      #slideFrame {
        width: 1280px;
        height: 720px;
        position: relative;
        overflow: hidden;
        background: #080b12;
        box-shadow: 0 28px 90px rgba(0, 0, 0, 0.85);
        transform-origin: center center;
        flex-shrink: 0;
      }

      .aurora {
        position: absolute;
        inset: 0;
        z-index: 0;
        pointer-events: none;
        background:
          radial-gradient(circle at 14% 18%, rgba(225, 29, 72, 0.18), transparent 46%),
          radial-gradient(circle at 86% 78%, rgba(56, 189, 248, 0.13), transparent 46%),
          radial-gradient(circle at 50% 50%, rgba(159, 18, 57, 0.08), transparent 65%);
        animation: auroraShift 14s ease-in-out infinite alternate;
      }
      @keyframes auroraShift {
        0%   { transform: scale(1) translate(0, 0); }
        100% { transform: scale(1.07) translate(-1%, 1.2%); }
      }
      canvas#particles {
        position: absolute;
        inset: 0;
        width: 1280px;
        height: 720px;
        z-index: 0;
        pointer-events: none;
        opacity: 0.6;
      }

      .slide-progress {
        position: absolute;
        left: 0;
        bottom: 0;
        height: 4px;
        background: linear-gradient(90deg, #e11d48, #fb7185);
        box-shadow: 0 0 14px rgba(225, 29, 72, 0.85);
        transition: width 0.35s cubic-bezier(0.22, 1, 0.36, 1);
        z-index: 5;
      }

      .slide-content {
        position: relative;
        z-index: 2;
        width: 100%;
        height: 100%;
        padding: 38px 54px 36px;
        display: flex;
        flex-direction: column;
        overflow: hidden;
      }

      .slide-enter {
        animation: slideIn 0.42s cubic-bezier(0.22, 1, 0.36, 1) both;
      }
      @keyframes slideIn {
        from { opacity: 0; transform: translateY(14px) scale(0.985); }
        to   { opacity: 1; transform: translateY(0) scale(1); }
      }

      .slide-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 12px;
        flex-shrink: 0;
      }
      .top-left {
        display: flex;
        align-items: center;
        gap: 12px;
      }
      .mini-logo {
        width: 30px;
        height: 30px;
        object-fit: contain;
        filter: drop-shadow(0 0 10px rgba(225, 29, 72, 0.7));
        animation: floatGem 4s ease-in-out infinite;
      }
      @keyframes floatGem {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50%      { transform: translateY(-3px) rotate(3deg); }
      }

      .badge {
        background: var(--ruby-soft);
        color: #fda4af;
        border: 1px solid rgba(255, 77, 109, 0.45);
        padding: 4px 14px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 0.7px;
      }
      .slide-num {
        color: var(--muted);
        font-size: 14px;
        font-family: "JetBrains Mono", monospace;
      }

      .title-row {
        display: flex;
        align-items: center;
        gap: 22px;
        margin-bottom: 18px;
        flex-shrink: 0;
      }
      .hero-logo {
        width: 84px;
        height: 84px;
        object-fit: contain;
        flex-shrink: 0;
        filter: drop-shadow(0 0 24px rgba(225, 29, 72, 0.75));
        animation: heroPulse 3.6s ease-in-out infinite;
      }
      .hero-logo.intro-gem {
        animation:
          gemIntroMove 1.15s cubic-bezier(0.22, 1, 0.36, 1) forwards,
          heroPulse 3.6s ease-in-out 1.15s infinite;
        z-index: 20;
      }
      @keyframes gemIntroMove {
        0% {
          transform: translate(535px, 165px) scale(3.4) rotate(-8deg);
          filter: drop-shadow(0 0 60px rgba(255, 77, 109, 1));
        }
        100% {
          transform: translate(0px, 0px) scale(1) rotate(0deg);
          filter: drop-shadow(0 0 24px rgba(225, 29, 72, 0.75));
        }
      }
      @keyframes heroPulse {
        0%, 100% { transform: scale(1) rotate(-2deg); }
        50%      { transform: scale(1.06) rotate(2deg); }
      }
      .intro-reveal {
        animation: introFadeReveal 0.75s cubic-bezier(0.22, 1, 0.36, 1) 0.45s both;
      }
      @keyframes introFadeReveal {
        from { opacity: 0; transform: translateY(14px); }
        to   { opacity: 1; transform: translateY(0); }
      }

      /* Pantalla de espera inicial en Slide 1 */
      .intro-stage {
        position: relative;
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 16px;
      }
      .flash-burst {
        position: absolute;
        width: 680px;
        height: 680px;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -56%);
        pointer-events: none;
        z-index: 1;
        animation: spinBurst 14s linear infinite;
      }
      .flash-burst-inner {
        position: absolute;
        width: 520px;
        height: 520px;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -56%);
        pointer-events: none;
        z-index: 1;
        animation: spinBurstRev 9s linear infinite;
      }
      @keyframes spinBurst {
        from { transform: translate(-50%, -56%) rotate(0deg); }
        to   { transform: translate(-50%, -56%) rotate(360deg); }
      }
      @keyframes spinBurstRev {
        from { transform: translate(-50%, -56%) rotate(360deg); }
        to   { transform: translate(-50%, -56%) rotate(0deg); }
      }
      .intro-gem-big {
        position: relative;
        z-index: 3;
        width: 270px;
        height: 270px;
        object-fit: contain;
        filter: drop-shadow(0 0 55px rgba(255, 77, 109, 0.95));
        animation: bigGemFloat 3.2s ease-in-out infinite;
      }
      @keyframes bigGemFloat {
        0%, 100% { transform: scale(1) rotate(-3deg); }
        50%      { transform: scale(1.06) rotate(3deg); }
      }
      .intro-word {
        position: relative;
        z-index: 3;
        margin: 0;
        font-size: 86px;
        font-weight: 900;
        letter-spacing: 3px;
        background: linear-gradient(120deg, #ffffff 15%, #fda4af 55%, #ff2d55 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        filter: drop-shadow(0 8px 28px rgba(225, 29, 72, 0.5));
      }

      h1.slide-title {
        margin: 0;
        font-size: 40px;
        font-weight: 800;
        line-height: 1.12;
        background: linear-gradient(95deg, #ffffff 10%, #fda4af 70%, #fb7185 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        letter-spacing: -0.6px;
      }

      .slide-body {
        flex: 1;
        min-height: 0;
        display: grid;
        grid-template-columns: 1fr;
        gap: 20px;
        overflow: hidden;
      }
      .slide-body.with-code {
        grid-template-columns: 0.92fr 1.18fr;
      }
      .slide-body.with-media {
        grid-template-columns: 1.25fr 0.75fr;
      }

      .points-card, .code-card, .media-card {
        background: rgba(18, 23, 34, 0.78);
        backdrop-filter: blur(14px);
        border: 1px solid var(--border);
        border-radius: 16px;
        padding: 20px 22px;
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.35);
        overflow: hidden;
        display: flex;
        flex-direction: column;
      }
      .media-card {
        align-items: center;
        justify-content: center;
        gap: 14px;
        text-align: center;
      }
      .media-card img.portrait {
        width: 220px;
        height: 220px;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid rgba(225, 29, 72, 0.65);
        box-shadow: 0 0 36px rgba(225, 29, 72, 0.35);
      }
      .media-card img.logo-showcase {
        max-width: 82%;
        max-height: 220px;
        object-fit: contain;
        filter: drop-shadow(0 8px 24px rgba(255, 255, 255, 0.12));
        background: rgba(255, 255, 255, 0.92);
        padding: 16px 24px;
        border-radius: 16px;
      }
      .media-card img.logo-transparent {
        max-width: 75%;
        max-height: 230px;
        object-fit: contain;
        filter: drop-shadow(0 8px 28px rgba(225, 29, 72, 0.35));
      }
      .media-caption {
        font-size: 15px;
        color: #cbd5e1;
        font-weight: 600;
      }
      .media-sub {
        font-size: 13px;
        color: var(--muted);
      }

      /* Tarjetas visuales variadas */
      .cards-grid-3 {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 14px;
        height: 100%;
      }
      .cards-grid-2 {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 16px;
        height: 100%;
      }
      .feature-card {
        background: rgba(18, 23, 34, 0.82);
        border: 1px solid var(--border);
        border-top: 3px solid var(--ruby);
        border-radius: 14px;
        padding: 18px 20px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        gap: 8px;
        opacity: 0;
        animation: fadeUp 0.4s ease forwards;
      }
      .feature-num {
        font-size: 12px;
        font-weight: 800;
        color: #fda4af;
        letter-spacing: 0.8px;
        text-transform: uppercase;
      }
      .feature-title {
        font-size: 20px;
        font-weight: 700;
        color: #fff;
      }
      .feature-desc {
        font-size: 15px;
        color: #cbd5e1;
        line-height: 1.4;
      }

      /* Línea de tiempo (Slide 5) */
      .timeline-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 14px;
        align-content: center;
        height: 100%;
      }
      .tl-card {
        background: rgba(18, 23, 34, 0.84);
        border: 1px solid var(--border);
        border-radius: 14px;
        padding: 16px;
        display: flex;
        flex-direction: column;
        gap: 8px;
        opacity: 0;
        animation: fadeUp 0.4s ease forwards;
      }
      .tl-year {
        display: inline-block;
        align-self: flex-start;
        background: linear-gradient(135deg, #f43f5e, #be123c);
        color: #fff;
        font-weight: 800;
        font-size: 15px;
        padding: 3px 12px;
        border-radius: 999px;
      }
      .tl-text {
        font-size: 15.5px;
        color: #e2e8f0;
        line-height: 1.4;
      }

      /* Pipeline / Flujo MVC (Slides 8 y 18) */
      .flow-row {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 14px;
        flex-wrap: nowrap;
      }
      .flow-step {
        flex: 1;
        background: rgba(225, 29, 72, 0.14);
        border: 1px solid rgba(255, 77, 109, 0.35);
        border-radius: 10px;
        padding: 10px 8px;
        text-align: center;
        font-weight: 700;
        font-size: 14px;
        color: #fff;
        opacity: 0;
        animation: fadeUp 0.35s ease forwards;
      }
      .flow-arrow {
        color: #fb7185;
        font-weight: 900;
        font-size: 18px;
      }

      .points-list {
        margin: 0;
        padding: 0;
        list-style: none;
        display: grid;
        grid-template-columns: 1fr;
        gap: 10px;
      }
      .points-list.two-cols {
        grid-template-columns: 1fr 1fr;
        gap: 10px 14px;
      }
      .points-list li {
        font-size: 18px;
        line-height: 1.38;
        color: #e2e8f0;
        padding: 9px 13px;
        background: rgba(255, 255, 255, 0.035);
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-left: 3px solid var(--ruby);
        border-radius: 10px;
        opacity: 0;
        animation: fadeUp 0.38s ease forwards;
      }
      @keyframes fadeUp {
        from { opacity: 0; transform: translateY(8px); }
        to   { opacity: 1; transform: translateY(0); }
      }

      /* Consola Ruby */
      .code-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 10px;
        flex-shrink: 0;
      }
      .live-pill {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-size: 13px;
        color: #cbd5e1;
        font-family: "JetBrains Mono", monospace;
      }
      .live-dot {
        width: 9px;
        height: 9px;
        border-radius: 50%;
        background: var(--amber);
        box-shadow: 0 0 10px var(--amber);
        animation: blinkDot 0.9s infinite;
      }
      .live-dot.done {
        background: var(--green);
        box-shadow: 0 0 10px var(--green);
        animation: none;
      }
      @keyframes blinkDot {
        0%, 100% { opacity: 1; transform: scale(1); }
        50%      { opacity: 0.35; transform: scale(0.85); }
      }
      .exec-badge {
        font-family: "JetBrains Mono", monospace;
        font-size: 12px;
        color: var(--muted);
        padding: 3px 10px;
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid var(--border);
      }

      pre.code-view {
        flex: 1;
        min-height: 0;
        margin: 0;
        width: 100%;
        background: #06090e;
        color: #f1f5f9;
        border: 1px solid var(--border);
        border-radius: 10px;
        padding: 12px 14px;
        font-family: "JetBrains Mono", "Fira Code", monospace;
        font-size: 15px;
        line-height: 1.5;
        white-space: pre-wrap;
        overflow-y: auto;
        overflow-x: hidden;
      }
      .code-line {
        display: block;
        opacity: 0;
        animation: lineReveal 0.25s ease forwards;
      }
      @keyframes lineReveal {
        from { opacity: 0; transform: translateX(-6px); }
        to   { opacity: 1; transform: translateX(0); }
      }
      .kw { color: #fb7185; font-weight: 600; }
      .str { color: #fde68a; }
      .cmt { color: #64748b; font-style: italic; }
      .num { color: #38bdf8; }

      pre.console-out {
        margin: 10px 0 0;
        background: #040609;
        border: 1px solid var(--border);
        border-left: 4px solid var(--amber);
        border-radius: 10px;
        padding: 10px 14px;
        font-family: "JetBrains Mono", monospace;
        font-size: 15px;
        line-height: 1.45;
        color: #fde68a;
        white-space: pre-wrap;
        height: 132px;
        flex-shrink: 0;
        overflow-y: auto;
        overflow-x: hidden;
        transition: border-color 0.3s, color 0.3s;
      }
      pre.console-out.done {
        border-left-color: var(--green);
        color: #a7f3d0;
      }
      pre.console-out.err {
        border-left-color: var(--ruby-bright);
        color: #fda4af;
      }

      /* Tablas comparativas */
      .table-card {
        background: rgba(18, 23, 34, 0.82);
        backdrop-filter: blur(14px);
        border: 1px solid var(--border);
        border-radius: 16px;
        padding: 18px 22px;
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.35);
        overflow: hidden;
        display: flex;
        flex-direction: column;
        justify-content: center;
      }
      table.comp-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 17px;
      }
      table.comp-table th {
        text-align: left;
        padding: 12px 16px;
        background: rgba(255, 255, 255, 0.05);
        color: #f8fafc;
        font-weight: 700;
        border-bottom: 2px solid var(--ruby);
        font-size: 18px;
      }
      table.comp-table th.ruby-col {
        background: rgba(225, 29, 72, 0.24);
        color: #fda4af;
      }
      .th-flex {
        display: flex;
        align-items: center;
        gap: 8px;
      }
      .th-icon {
        width: 22px;
        height: 22px;
        object-fit: contain;
      }
      table.comp-table td {
        padding: 12px 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.07);
        color: #e2e8f0;
        line-height: 1.35;
      }
      table.comp-table td:first-child { font-weight: 700; color: #94a3b8; }
      table.comp-table td.ruby-col {
        background: rgba(225, 29, 72, 0.08);
        color: #fff;
        font-weight: 600;
      }
      table.comp-table tbody tr {
        opacity: 0;
        animation: fadeUp 0.4s ease forwards;
      }
      .table-note {
        margin-top: 12px;
        font-size: 14px;
        color: var(--muted);
        text-align: right;
      }
    </style>
  </head>
  <body>
    <div id="slideFrame">
      <div class="aurora"></div>
      <canvas id="particles" width="1280" height="720"></canvas>
      <div id="slideContent" class="slide-content"></div>
      <div id="progressFill" class="slide-progress"></div>
    </div>

    <script>
      let slides = [];
      let current = 0;
      let runToken = 0;
      let introWaiting = true;

      function buildInterleavedFlashSvg(rays, rInner, rOuter, strokeW, dash) {
        let lines = '';
        for (let i = 0; i < rays; i++) {
          const deg = (360 / rays) * i;
          const isAlt = i % 2 === 0;
          const r1 = isAlt ? rInner : rInner + 28;
          const r2 = isAlt ? rOuter : rOuter - 48;
          const op = isAlt ? 0.55 : 0.28;
          const color = isAlt ? '#ff4d6d' : '#fda4af';
          const dashAttr = isAlt ? '' : `stroke-dasharray="${dash}"`;
          lines += `<line x1="0" y1="-${r1}" x2="0" y2="-${r2}" stroke="${color}" stroke-width="${strokeW}" stroke-linecap="round" opacity="${op}" ${dashAttr} transform="rotate(${deg})"/>`;
        }
        return `<svg viewBox="-340 -340 680 680" width="100%" height="100%">${lines}</svg>`;
      }

      function scaleSlide() {
        const frame = document.getElementById('slideFrame');
        const scale = Math.min(window.innerWidth / 1280, window.innerHeight / 720);
        frame.style.transform = `scale(${scale})`;
      }
      window.addEventListener('resize', scaleSlide);

      function initParticles() {
        const canvas = document.getElementById('particles');
        const ctx = canvas.getContext('2d');
        const pts = Array.from({ length: 24 }, () => ({
          x: Math.random() * 1280,
          y: Math.random() * 720,
          r: 1.2 + Math.random() * 2.2,
          vx: (Math.random() - 0.5) * 0.35,
          vy: -0.15 - Math.random() * 0.3,
          a: 0.2 + Math.random() * 0.4
        }));
        function draw() {
          ctx.clearRect(0, 0, 1280, 720);
          for (const p of pts) {
            p.x = (p.x + p.vx + 1280) % 1280;
            p.y = (p.y + p.vy + 720) % 720;
            ctx.beginPath();
            ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(255, 77, 109, ${p.a})`;
            ctx.fill();
          }
          requestAnimationFrame(draw);
        }
        draw();
      }

      async function init() {
        scaleSlide();
        initParticles();
        const res = await fetch('/api/slides');
        slides = await res.json();

        document.addEventListener('keydown', (e) => {
          if (e.key === 'ArrowRight') {
            e.preventDefault();
            if (current === 0 && introWaiting) {
              introWaiting = false;
              goTo(0, true);
            } else {
              goTo(current + 1);
            }
          } else if (e.key === 'ArrowLeft') {
            e.preventDefault();
            if (current === 0 && !introWaiting) {
              introWaiting = true;
              goTo(0);
            } else {
              goTo(current - 1);
            }
          }
        });

        goTo(0);
      }

      function escapeHtml(str) {
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
      }

      function highlightRubyLine(line) {
        let html = escapeHtml(line);
        const cmtIdx = html.indexOf('#');
        let cmt = '';
        if (cmtIdx !== -1 && !html.slice(0, cmtIdx).includes('#{')) {
          cmt = `<span class="cmt">${html.slice(cmtIdx)}</span>`;
          html = html.slice(0, cmtIdx);
        }
        html = html.replace(/(&quot;|")([^"]*?)(\1)/g, '<span class="str">"$2"</span>');
        html = html.replace(/\b(class|def|end|if|elsif|else|unless|while|for|in|do|puts|print|require|super|private|attr_reader|yield|true|false|nil)\b/g, '<span class="kw">$1</span>');
        html = html.replace(/\b(\d+(?:\.\d+)?)\b/g, '<span class="num">$1</span>');
        return html + cmt;
      }

      // Mantiene tamaños de letra fijos y hace scroll lento automático si algo no cabe
      async function autoScrollSmooth(el, token, speedPxPerFrame = 0.42) {
        if (!el) return;
        await new Promise(r => setTimeout(r, 1200));
        while (token === runToken) {
          const maxScroll = el.scrollHeight - el.clientHeight;
          if (maxScroll <= 4) {
            await new Promise(r => setTimeout(r, 1000));
            continue;
          }
          // Bajar lentamente
          let pos = 0;
          while (pos < maxScroll && token === runToken) {
            pos += speedPxPerFrame;
            el.scrollTop = pos;
            await new Promise(r => requestAnimationFrame(r));
          }
          await new Promise(r => setTimeout(r, 1400));
          if (token !== runToken) return;
          // Regresar suavemente arriba
          while (pos > 0 && token === runToken) {
            pos -= speedPxPerFrame * 2;
            el.scrollTop = Math.max(0, pos);
            await new Promise(r => requestAnimationFrame(r));
          }
          await new Promise(r => setTimeout(r, 1400));
        }
      }

      function setupAutoScrolls(token) {
        const codeView = document.querySelector('pre.code-view');
        if (codeView) autoScrollSmooth(codeView, token, 0.38);

        const pointsCard = document.querySelector('.points-card');
        if (pointsCard && pointsCard.scrollHeight > pointsCard.clientHeight + 4) {
          pointsCard.style.overflowY = 'auto';
          autoScrollSmooth(pointsCard, token, 0.35);
        }
      }

      const CODE_FILENAMES = {
        1: 'hola_ruby.rb',
        4: 'todo_es_objeto.rb',
        7: 'flexibilidad_ciclos.rb',
        10: 'variables_y_tipos.rb',
        11: 'cadenas_arreglos_hashes.rb',
        12: 'entrada_y_salida.rb',
        13: 'condicionales_y_ciclos.rb',
        14: 'metodos_y_bloques.rb',
        15: 'clase_persona.rb',
        16: 'herencia_estudiante.rb',
        19: 'automatizacion_backup.rb',
        25: 'despedida.rb'
      };
      function getCodeFilename(slideNum) {
        return CODE_FILENAMES[slideNum] || `ejemplo_${slideNum}.rb`;
      }

      async function autoRunSlideCode(s, token) {
        const outEl = document.getElementById('consoleOut');
        const dotEl = document.getElementById('liveDot');
        const statusEl = document.getElementById('execBadge');
        if (!outEl) return;

        const res = await fetch('/api/run', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ code: s.code, stdin: s.default_stdin || '' })
        });
        if (token !== runToken) return;

        const data = await res.json();
        const hasErr = Boolean(data.stderr && data.stderr.trim());
        const fullText = hasErr
          ? ((data.stdout ? data.stdout + '\n' : '') + data.stderr)
          : (data.stdout || '(sin salida)');
        const outLines = fullText.trimEnd().split('\n');

        const fname = getCodeFilename(s.slide);
        while (token === runToken) {
          dotEl.className = 'live-dot';
          statusEl.textContent = 'Ejecutando...';
          outEl.className = 'console-out';
          outEl.textContent = `$ ruby ${fname}`;

          await new Promise(r => setTimeout(r, 450));
          if (token !== runToken) return;

          dotEl.className = 'live-dot done';
          statusEl.textContent = `✔ ${data.ms} ms`;
          outEl.className = hasErr ? 'console-out err' : 'console-out done';
          outEl.textContent = '';

          for (let i = 0; i < outLines.length; i++) {
            if (token !== runToken) return;
            outEl.textContent += (i > 0 ? '\n' : '') + outLines[i];
            outEl.scrollTop = outEl.scrollHeight;
            await new Promise(r => setTimeout(r, 160));
          }

          await new Promise(r => setTimeout(r, 2400));
        }
      }

      // Layouts especiales para que las diapositivas sean visualmente variadas
      function renderSpecialBody(s, rawPoints, pointsHtml) {
        if (s.slide === 3) {
          // 6 tarjetas de expositores
          const blocks = [];
          for (let i = 0; i < rawPoints.length - 1; i += 3) {
            if (rawPoints[i].startsWith('Total:')) break;
            blocks.push([rawPoints[i], rawPoints[i+1] || '', rawPoints[i+2] || '']);
          }
          return `
            <div class="cards-grid-3">
              ${blocks.map((b, idx) => `
                <div class="feature-card" style="animation-delay:${idx * 65}ms">
                  <span class="feature-num">${escapeHtml(b[0])}</span>
                  <div class="feature-title">${escapeHtml(b[1])}</div>
                  <div class="feature-desc">${escapeHtml(b[2])}</div>
                </div>
              `).join('')}
            </div>
          `;
        }
        if (s.slide === 5) {
          // Línea de tiempo horizontal en tarjetas con año
          const pairs = [];
          for (let i = 0; i < rawPoints.length; i++) {
            if (/^\d{4}$/.test(rawPoints[i]) && rawPoints[i+1]) {
              pairs.push([rawPoints[i], rawPoints[i+1]]);
              i++;
            } else {
              pairs.push(['META', rawPoints[i]]);
            }
          }
          return `
            <div class="timeline-grid">
              ${pairs.map((p, idx) => `
                <div class="tl-card" style="animation-delay:${idx * 65}ms">
                  <span class="tl-year">${escapeHtml(p[0])}</span>
                  <div class="tl-text">${escapeHtml(p[1])}</div>
                </div>
              `).join('')}
            </div>
          `;
        }
        if (s.slide === 8) {
          const stages = [
            ['1. Código fuente (.rb)', 'Alto nivel: abstrae hardware y punteros'],
            ['2. Lexer & Parser', 'Tokenización y Árbol Sintáctico (AST / Prism)'],
            ['3. Bytecode YARV', 'Compilado a instrucciones para VM de pila'],
            ['4. Ejecución + YJIT', 'Interpreta bytecode o compila a código nativo']
          ];
          const cards = [
            ['Alto nivel de abstracción', 'Prioriza expresividad y legibilidad; sin manejo manual de punteros.'],
            ['Tipado dinámico', 'El tipo pertenece al valor en ejecución: x = 1 y luego x = "a" es válido.'],
            ['Todo es objeto', 'Enteros, textos, nil y clases responden a métodos.'],
            ['Memoria automática (GC)', 'Recolector de basura incremental (Mark & Sweep / Tri-color).']
          ];
          return `
            <div style="display:flex;flex-direction:column;height:100%;gap:14px;">
              <div class="flow-row" style="margin-bottom:0;">
                ${stages.map((st, idx) => `
                  <div class="flow-step" style="animation-delay:${idx * 70}ms;text-align:left;padding:12px 14px;">
                    <div style="color:#fda4af;font-size:14px;font-weight:800;margin-bottom:4px;">${st[0]}</div>
                    <div style="font-size:13px;font-weight:400;color:#e2e8f0;line-height:1.35;">${st[1]}</div>
                  </div>
                  ${idx < stages.length - 1 ? '<span class="flow-arrow">→</span>' : ''}
                `).join('')}
              </div>
              <div class="cards-grid-2" style="flex:1;">
                ${cards.map((c, idx) => `
                  <div class="feature-card" style="animation-delay:${(idx + 4) * 55}ms">
                    <div class="feature-title" style="font-size:18px;">${c[0]}</div>
                    <div class="feature-desc" style="font-size:15px;">${c[1]}</div>
                  </div>
                `).join('')}
              </div>
            </div>
          `;
        }
        if (s.slide === 20) {
          const quads = [
            ['Ventajas', '#34d399', [
              'Sintaxis expresiva, legible y concisa.',
              'Alta productividad (convención sobre configuración en Rails).',
              'Ecosistema de gems maduro y comunidad activa.'
            ]],
            ['Límites y Rendimiento', '#fbbf24', [
              'Menor velocidad pura frente a lenguajes compilados estáticos.',
              'El GVL limita el paralelismo CPU-bound en hilos tradicionales.',
              'YJIT (y ZJIT experimental en 4.0) aceleran rutas calientes.'
            ]],
            ['✅ Cuándo SÍ usarlo', '#38bdf8', [
              'Aplicaciones web rápidas, APIs y MVPs con Ruby on Rails.',
              'Scripts de automatización, DevOps y herramientas CLI.',
              'Prototipado ágil donde importa la velocidad de desarrollo.'
            ]],
            ['⛔ Cuándo NO usarlo', '#fb7185', [
              'Ciencia de datos, Machine Learning o IA (menor ecosistema).',
              'Cómputo paralelo intensivo en CPU o videojuegos 3D.',
              'Sistemas embebidos o tiempo real estricto con memoria mínima.'
            ]]
          ];
          return `
            <div class="cards-grid-2">
              ${quads.map((q, idx) => `
                <div class="feature-card" style="border-top-color:${q[1]};animation-delay:${idx * 65}ms;justify-content:flex-start;">
                  <div class="feature-title" style="color:${q[1]};font-size:19px;">${q[0]}</div>
                  <ul style="margin:4px 0 0;padding-left:18px;display:flex;flex-direction:column;gap:6px;color:#e2e8f0;font-size:15px;line-height:1.38;">
                    ${q[2].map(item => `<li>${escapeHtml(item)}</li>`).join('')}
                  </ul>
                </div>
              `).join('')}
            </div>
          `;
        }
        if (s.slide === 17) {
          // RubyGems + logo oficial
          return `
            <div class="slide-body with-media">
              <div class="points-card"><ul class="points-list">${pointsHtml}</ul></div>
              <div class="media-card">
                <img src="/img/rubygems.png" class="logo-transparent" alt="RubyGems" />
                <div class="media-caption">RubyGems &amp; Bundler</div>
                <div class="media-sub">Ecosistema modular de librerías (.gem)</div>
              </div>
            </div>
          `;
        }
        if (s.slide === 18) {
          // Rails MVC pipeline + logo oficial
          const steps = rawPoints.slice(0, 5);
          const rest = rawPoints.slice(5).map((l, i) => `<li style="animation-delay:${i * 45}ms">${escapeHtml(l)}</li>`).join('');
          return `
            <div style="display:flex;flex-direction:column;height:100%;">
              <div class="flow-row">
                ${steps.map((st, idx) => `
                  <div class="flow-step" style="animation-delay:${idx * 70}ms">${escapeHtml(st)}</div>
                  ${idx < steps.length - 1 ? '<span class="flow-arrow">→</span>' : ''}
                `).join('')}
              </div>
              <div class="slide-body with-media" style="flex:1;">
                <div class="points-card"><ul class="points-list">${rest}</ul></div>
                <div class="media-card">
                  <img src="/img/Ruby-on-Rails-Logo.png" class="logo-transparent" alt="Ruby on Rails" />
                  <div class="media-caption">Arquitectura MVC</div>
                  <div class="media-sub">Convención sobre configuración</div>
                </div>
              </div>
            </div>
          `;
        }
        if (s.slide === 23) {
          // 4 conclusiones en tarjetas 2x2
          const cards = [];
          for (let i = 0; i < rawPoints.length; i += 2) {
            cards.push([rawPoints[i], rawPoints[i+1] || '']);
          }
          return `
            <div class="cards-grid-2">
              ${cards.map((c, idx) => `
                <div class="feature-card" style="animation-delay:${idx * 70}ms">
                  <span class="feature-num">Conclusión ${escapeHtml(c[0])}</span>
                  <div class="feature-title" style="font-size:19px;font-weight:600;line-height:1.4;">${escapeHtml(c[1])}</div>
                </div>
              `).join('')}
            </div>
          `;
        }
        return null;
      }

      function goTo(idx, animateFromIntro = false) {
        if (idx < 0 || idx >= slides.length) return;
        current = idx;
        runToken += 1;
        const token = runToken;
        const s = slides[idx];

        document.getElementById('progressFill').style.width = `${((idx + 1) / slides.length) * 100}%`;
        const container = document.getElementById('slideContent');

        if (idx === 0 && introWaiting) {
          container.innerHTML = `
            <div class="intro-stage slide-enter">
              <div class="flash-burst">${buildInterleavedFlashSvg(24, 145, 325, 3, '12 10')}</div>
              <div class="flash-burst-inner">${buildInterleavedFlashSvg(18, 125, 250, 2, '6 14')}</div>
              <img src="/img/ruby.png" class="intro-gem-big" alt="Ruby" />
              <h1 class="intro-word">Ruby</h1>
            </div>
          `;
          return;
        }

        const alumnoMatch = s.alumno.match(/Alumno \d+/i);
        const badgeText = alumnoMatch ? alumnoMatch[0].toUpperCase() : 'CIERRE';

        const hasCode = Boolean(s.code);
        const hasTable = Boolean(s.table);
        const codeLineSet = new Set(
          hasCode ? s.code.split('\n').map(l => l.trim().replace(/\s+/g, ' ')) : []
        );
        const rawPoints = s.ppt_lines
          .filter((line, i) => {
            if (i === 0 || line === String(s.slide) || line.startsWith('ALUMNO ')) return false;
            if (hasCode && codeLineSet.has(line.trim().replace(/\s+/g, ' '))) return false;
            return true;
          });
        const hasPoints = rawPoints.length > 0;
        const useTwoCols = !hasCode && !hasTable && rawPoints.length > 7;

        const points = rawPoints
          .map((line, i) => `<li style="animation-delay:${i * 40}ms">${escapeHtml(line)}</li>`)
          .join('');

        const tableHtml = hasTable ? `
          <div class="table-card">
            <table class="comp-table">
              <thead>
                <tr>${s.table.headers.map((h, ci) => `
                  <th class="${ci === 1 ? 'ruby-col' : ''}">
                    ${ci === 1 ? `<div class="th-flex"><img src="/img/ruby.png" class="th-icon" alt="Ruby"/><span>${escapeHtml(h)}</span></div>` : escapeHtml(h)}
                  </th>
                `).join('')}</tr>
              </thead>
              <tbody>
                ${s.table.rows.map((r, ri) => `
                  <tr style="animation-delay:${ri * 80}ms">
                    ${r.map((cell, ci) => `<td class="${ci === 1 ? 'ruby-col' : ''}">${escapeHtml(cell)}</td>`).join('')}
                  </tr>
                `).join('')}
              </tbody>
            </table>
            ${hasPoints ? `<div class="table-note">${rawPoints.map(escapeHtml).join(' · ')}</div>` : ''}
          </div>
        ` : '';

        const codeHtml = hasCode
          ? s.code.split('\n').map((ln, i) =>
              `<span class="code-line" style="animation-delay:${i * 35}ms">${highlightRubyLine(ln) || ' '}</span>`
            ).join('')
          : '';

        const isHero = (s.slide === 1 || s.slide === 25);
        const isIntro = (s.slide === 1 && animateFromIntro);
        const specialBody = renderSpecialBody(s, rawPoints, points);

        // En Slide 4 incluimos la foto de Matz en la parte izquierda junto a sus viñetas
        const matzHeader = (s.slide === 4) ? `
          <div style="display:flex;align-items:center;gap:14px;margin-bottom:12px;padding:10px;background:rgba(225,29,72,0.10);border:1px solid rgba(255,77,109,0.3);border-radius:12px;">
            <img src="/img/matz.png" style="width:68px;height:68px;border-radius:50%;object-fit:cover;border:2px solid #ff4d6d;" alt="Matz" />
            <div>
              <div style="font-weight:700;font-size:16px;color:#fff;">Yukihiro “Matz” Matsumoto</div>
              <div style="font-size:13px;color:#cbd5e1;">Creador de Ruby (Japón, 1995)</div>
            </div>
          </div>
        ` : '';

        container.innerHTML = `
          <div class="slide-enter" style="display:flex;flex-direction:column;height:100%;min-height:0;">
            <div class="slide-top ${isIntro ? 'intro-reveal' : ''}">
              <div class="top-left">
                <img src="/img/ruby.png" class="mini-logo" alt="Ruby" />
                <span class="badge">${escapeHtml(badgeText)}</span>
              </div>
              <span class="slide-num">${s.slide} / ${slides.length}</span>
            </div>

            <div class="title-row">
              ${isHero ? `<img src="/img/ruby.png" class="hero-logo ${isIntro ? 'intro-gem' : ''}" alt="Ruby" />` : ''}
              <h1 class="slide-title ${isIntro ? 'intro-reveal' : ''}">${escapeHtml(s.title)}</h1>
            </div>

            ${specialBody ? `<div style="flex:1;min-height:0;">${specialBody}</div>` : `
              <div class="slide-body ${(hasCode && hasPoints) ? 'with-code' : ''} ${isIntro ? 'intro-reveal' : ''}">
                ${hasTable ? tableHtml : (hasPoints ? `
                  <div class="points-card">
                    ${matzHeader}
                    <ul class="points-list ${useTwoCols ? 'two-cols' : ''}">${points}</ul>
                  </div>
                ` : '')}
                ${hasCode ? `
                  <div class="code-card">
                    <div class="code-header">
                      <span class="live-pill"><span id="liveDot" class="live-dot"></span> ${escapeHtml(getCodeFilename(s.slide))} · Ruby <%= RUBY_VERSION %></span>
                      <span id="execBadge" class="exec-badge">Ejecutando...</span>
                    </div>
                    <pre class="code-view">${codeHtml}</pre>
                    <pre id="consoleOut" class="console-out">$ ruby ${escapeHtml(getCodeFilename(s.slide))}</pre>
                  </div>
                ` : ''}
              </div>
            `}
          </div>
        `;

        setupAutoScrolls(token);
        if (hasCode) autoRunSlideCode(s, token);
      }

      init();
    </script>
  </body>
  </html>
HTML

RENDERED_HTML = ERB.new(HTML_PAGE).result(binding)

server = WEBrick::HTTPServer.new(
  Port: PORT,
  Logger: WEBrick::Log.new($stderr, WEBrick::Log::WARN),
  AccessLog: []
)

server.mount_proc "/" do |_req, res|
  res.content_type = "text/html; charset=utf-8"
  res.body = RENDERED_HTML
end

server.mount_proc "/api/slides" do |_req, res|
  res.content_type = "application/json; charset=utf-8"
  res.body = JSON.generate(SLIDES)
end

server.mount_proc "/img" do |req, res|
  name = File.basename(req.path)
  path = ALLOWED_IMAGES[name]
  if path && File.exist?(path)
    res.content_type = "image/png"
    res.body = File.binread(path)
  else
    res.status = 404
    res.body = "Not found"
  end
end

server.mount_proc "/api/run" do |req, res|
  res.content_type = "application/json; charset=utf-8"
  payload = JSON.parse(req.body || "{}")
  code = payload["code"].to_s
  stdin_data = payload["stdin"].to_s

  t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  stdout_str = ""
  stderr_str = ""
  exit_code = 0

  begin
    Timeout.timeout(3) do
      utf8_code = "# encoding: utf-8\n" + code
      stdout_str, stderr_str, status = Open3.capture3({ "LANG" => "C.UTF-8" }, "ruby", "-E", "UTF-8", "-e", utf8_code, stdin_data: stdin_data)
      exit_code = status.exitstatus || 0
    end
  rescue Timeout::Error
    stderr_str = "Error: Tiempo límite excedido (3s)."
    exit_code = 124
  end

  ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0) * 1000).round(2)
  res.body = JSON.generate({
    stdout: stdout_str,
    stderr: stderr_str,
    exit_code: exit_code,
    ms: ms,
    ruby_version: RUBY_VERSION
  })
end

trap("INT") { server.shutdown }
trap("TERM") { server.shutdown }

puts "=" * 60
puts "  💎 Presentación Ruby 16:9 con PNGs y Layouts Dinámicos"
puts "  🌐 Abre en tu navegador: http://localhost:#{PORT}"
puts "  📄 Diapositivas: #{SLIDES.size}"
puts "=" * 60

server.start
