<!DOCTYPE html>
<html lang="en">
<head>
<link rel="icon" href="/logo-mathswell-square-mirror.ico" type="image/x-icon">
<link rel="icon" href="/logo-mathswell-square-mirror.svg" type="image/svg+xml">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Polynomials vs. Exponentials Explorer</title>
  <!-- Chart.js CDN -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    :root {
      --primary-color: #1565c0; /* Blue */
      --light-gray: #f5f5f5;
      --medium-gray: #e0e0e0;
      --dark-gray: #424242;
      --text-color: #212121;
      --accent-orange: #ed6600;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      line-height: 1.6;
      background-color: var(--light-gray);
      color: var(--text-color);
      display: flex;
      justify-content: center;
      min-height: 100vh;
      padding: 1rem;
    }

    .container {
      width: 100%;
      max-width: 1000px;
      background-color: #fff;
      box-shadow: 0 4px 8px rgb(0 0 0 / 0.1);
      border-radius: 8px;
      padding: 1.5rem;
      display: flex;
      flex-direction: column;
    }

    h2 { text-align:center; font-size:1.75rem; color:var(--primary-color); margin-bottom:1rem; }

    /* Tabs */
    .tabs { display:flex; gap:0.5rem; margin-bottom:1rem; }
    .tab-btn {
      flex:1; padding:0.6rem 0.5rem; border:none; border-radius:6px 6px 0 0;
      background:var(--medium-gray); color:var(--dark-gray); font-weight:600; cursor:pointer;
    }
    .tab-btn.active { background:var(--primary-color); color:#fff; }
    .tab-content { padding:0.5rem 0; }
    .hidden { display:none; }

    /* Info Boxes */
    .info-box {
      background:var(--medium-gray);
      border-left:6px solid var(--primary-color);
      padding:0.75rem 1rem; border-radius:4px; margin-bottom:1rem; font-size:0.95rem;
    }

    /* Controls */
    .controls, .fd-controls {
      background-color: var(--medium-gray);
      border-radius: 6px;
      padding: 0.6rem;
      margin-bottom: 1rem;
      display: flex;
      flex-wrap: wrap;
      gap: 0.6rem 1rem;
      align-items:center; font-size:0.95rem;
      justify-content: center;
    }
    .controls label, .fd-controls label { display:flex; align-items:center; gap:0.35rem; cursor:pointer; }

    /* Square buttons for polynomial choice */
    .square-btn {
      border:2px solid var(--primary-color);
      border-radius:4px; padding:0.3rem 0.6rem; user-select:none;
    }
    .square-btn input { display:none; }
    .square-btn span { color:var(--primary-color); font-weight:600; }
    .square-btn.checked {
      background:var(--primary-color);
      border-color:var(--primary-color);
    }
    .square-btn.checked span { color:#fff; }

    /* Tables */
    .fd-section { margin-bottom:2rem; }
    table { border-collapse:collapse; font-size:0.85rem; margin:0 auto; }
    table th, table td { border:1px solid var(--medium-gray); padding:0.3rem 0.4rem; text-align:right; min-width:2.6rem; }
    table th.func-label { background:var(--primary-color); color:#fff; text-align:center; }
    .ellipsis { text-align:center !important; font-weight:600; }

    /* Canvas */
    .chart-box { position:relative; width:100%; max-width:600px; margin:0 auto; }
    .chart-box canvas { width:100% !important; height:auto !important; aspect-ratio:1 / 1; }
  </style>
   <!-- Mathswell favicon -->

<!-- Mathswell app navbar styles -->
<style>
  .mathswell-nav {
    display: flex;
    justify-content: center;
    margin: .4rem 0 1rem;
    position: sticky;
    top: 0;
    z-index: 1000;
  }
  .mathswell-nav .mw-link {
    display: inline-flex;
    align-items: center;
    gap: .45rem;
    text-decoration: none;
    font-weight: 700;
    font-size: 1rem;
    color: #0f766e;
    padding: .3rem .7rem;
    border-radius: 999px;
    background: rgba(255,255,255,.9);
    box-shadow: 0 1px 4px rgba(0,0,0,.08);
  }
  .mathswell-nav .mw-link img {
    display: block;
  }
</style>
</head>
<body>
  <div class="container">
    <h2>Polynomials vs. Exponentials Explorer</h2>
    <!-- Mathswell brand badge -->
<div style="display:flex;justify-content:center;margin:.75rem 0 1rem;
            position:relative;z-index:1001;">
  <a href="/" style="display:inline-flex;align-items:center;gap:.5rem;
      text-decoration:none;font-weight:800;font-size:1.05rem;color:#0f766e;
      padding:.4rem .8rem;border-radius:999px;background:#fff;
      box-shadow:0 1px 4px rgba(0,0,0,.08);">
    <img src="/logo-mathswell-square-mirror.svg" alt="Mathswell" width="28" height="28" style="display:block">
    <span>MATHSWELL</span>
  </a>
</div>


    <!-- Tab buttons -->
    <div class="tabs">
      <button class="tab-btn active" data-tab="fdTab">Finite Differences</button>
      <button class="tab-btn" data-tab="graphTab">Continuous Graphs</button>
    </div>

    <!-- Finite Differences Tab -->
    <div id="fdTab" class="tab-content">
      <div class="info-box">
        For polynomials the finite‑difference process eventually reaches zero (x³ needs a 3rd difference; x² a 2nd).  
        For an exponential like 2ˣ each new row is the previous row shifted one step and multiplied by the same constant, so the pattern never ends.
      </div>

      <!-- Polynomial section -->
      <div class="fd-section">
        <div class="fd-controls">
          <strong>Choose polynomial:</strong>
          <label class="square-btn checked"><input type="radio" name="poly" value="x2" checked><span>x²</span></label>
          <label class="square-btn"><input type="radio" name="poly" value="x3"><span>x³</span></label>
        </div>
        <div id="polyTable"></div>
      </div>

      <!-- 2^x section -->
      <div class="fd-section">
        <div class="fd-controls">
          <strong>2ˣ Finite Differences</strong>
          <label style="gap:0.3rem;">Levels to show:
            <input type="number" id="expLevels" value="6" min="1" max="10" style="width:4rem;" />
          </label>
        </div>
        <div id="expTable"></div>
      </div>
    </div>

    <!-- Continuous Graphs Tab -->
    <div id="graphTab" class="tab-content hidden">
      <div class="info-box">
        Toggle any combination of functions. The centred axes make growth‑rate comparisons immediate.
      </div>

      <!-- Main graph controls -->
      <div class="controls" id="graphControls">
        <strong>Select Functions:</strong>
        <label><input type="checkbox" data-func="x2" checked /> x²</label>
        <label><input type="checkbox" data-func="x3" checked /> x³</label>
        <label><input type="checkbox" data-func="exp" checked /> eˣ</label>
        <label><input type="checkbox" data-func="2x" checked /> 2ˣ</label>
        <label><input type="checkbox" data-func="3x" checked /> 3ˣ</label>
      </div>
      <div class="chart-box"><canvas id="chartMain"></canvas></div>

      <!-- a^x exploration -->
      <div class="info-box" style="margin-top:2rem;">
        Compare growth and decay of <em>a<sup>x</sup></em> for 0 &lt; a &lt; 1 and a &gt; 1. View (½)<sup>x</sup>, 2<sup>x</sup>, plus a custom base of your choice.
      </div>
      <div class="controls" id="axControls">
        <label><input type="checkbox" id="toggleHalf" checked> (½)ˣ</label>
        <label><input type="checkbox" id="toggleTwo" checked> 2ˣ</label>
        <label>Choose a:
          <input type="number" id="baseA" value="4" min="0.1" max="6" step="0.1" style="width:5rem;" />
        </label>
      </div>
      <div class="chart-box"><canvas id="chartAx"></canvas></div>
    </div>
  </div>

<script>
/***************** Chart.js plugin: centred axes with arrowheads *****************/
const axesArrows = {
  id: 'axesArrows',
  beforeDraw(chart) {
    const { ctx, chartArea:{top,bottom,left,right}, scales:{x,y} } = chart;
    ctx.save();
    ctx.strokeStyle = 'rgba(0,0,0,0.7)';
    ctx.lineWidth = 1.2;
    const arrow = 6;
    const xZero = x.getPixelForValue(0);
    const yZero = y.getPixelForValue(0);
    // y‑axis
    ctx.beginPath(); ctx.moveTo(xZero, top); ctx.lineTo(xZero, bottom); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(xZero, top); ctx.lineTo(xZero - arrow, top + arrow * 1.2); ctx.lineTo(xZero + arrow, top + arrow * 1.2); ctx.stroke();
    // x‑axis
    ctx.beginPath(); ctx.moveTo(left, yZero); ctx.lineTo(right, yZero); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(right, yZero); ctx.lineTo(right - arrow * 1.2, yZero - arrow); ctx.lineTo(right - arrow * 1.2, yZero + arrow); ctx.stroke();
    ctx.restore();
  }
};
Chart.register(axesArrows);

/***************** Helpers *****************/
const COLORS = {
  x2   : 'rgba(21,101,192,1)',
  x3   : 'rgba(21,101,192,0.6)',
  exp  : 'rgba(237,102,0,1)',
  '2x' : 'rgba(237,102,0,0.8)',
  '3x' : 'rgba(237,102,0,0.55)',
  halfx: 'rgba(21,101,192,0.5)',
  ax   : 'rgba(66,66,66,0.85)'
};
const RANGE = 8; // –RANGE … +RANGE for x‑axis
const YMAX = 300; // symmetric y‑range for square plot

function evalFunc(key, x, a = 2) {
  switch (key) {
    case 'x2': return x ** 2;
    case 'x3': return x ** 3;
    case 'exp': return Math.E ** x;
    case '2x': return 2 ** x;
    case '3x': return 3 ** x;
    case 'halfx': return 0.5 ** x;
    case 'ax': return a ** x;
    default: return 0;
  }
}
function formatPow2(exp) {
  return exp < 0 ? `1/${2 ** (-exp)}` : `${2 ** exp}`;
}

/***************** Finite‑difference builders *****************/
function buildPolyTable(func) {
  const xs = [...Array(6).keys()];
  const firstRow = xs.map(x => func === 'x2' ? x ** 2 : x ** 3);
  const rows = [firstRow];
  let current = firstRow;
  while (!current.every(v => v === 0)) {
    const next = current.slice(1).map((v,i) => current[i+1] - current[i]);
    rows.push(next);
    current = next;
  }
  let html = `<table><thead><tr><th class="func-label" colspan="${xs.length}">${func === 'x2' ? 'x²' : 'x³'}</th></tr></thead><tbody>`;
  rows.forEach(r => {
    html += '<tr>'; r.forEach(v => html += `<td>${v}</td>`); html += '</tr>'; });
  html += '</tbody></table>';
  document.getElementById('polyTable').innerHTML = html;
}

function buildExpTable(levels) {
  const xs = Array.from({length:11}, (_,i) => i-5); // –5 … 5
  const rows = [];
  for (let k=0;k<levels;k++) {
    rows.push(xs.map(x => 2 ** (x+k)));
  }
  let html = `<table><thead><tr><th class="func-label" colspan="13">2ˣ</th></tr></thead><tbody>`;
  rows.forEach(r=>{
    html += '<tr><td class="ellipsis">…</td>';
    r.forEach(expVal=> html += `<td>${formatPow2(Math.log2(expVal))}</td>`);
    html += '<td class="ellipsis">…</td></tr>';
  });
  html += '</tbody></table>';
  document.getElementById('expTable').innerHTML = html;
}

/***************** Chart builders *****************/
let chartMain=null, chartAx=null;
function datasetFor(key, aVal) {
  const data = [];
  for (let x=-RANGE;x<=RANGE;x+=0.25) data.push({x, y:evalFunc(key,x,aVal)});
  return {
    label:key,
    data,
    parsing:false,
    borderColor:COLORS[key],
    borderWidth:1.8,
    pointRadius:0
  };
}
function createMainChart() {
  const ctx=document.getElementById('chartMain');
  chartMain=new Chart(ctx,{
    type:'line',
    data:{datasets:[]},
    options:{
      maintainAspectRatio:true,
      responsive:true,
      plugins:{legend:{display:false}},
      scales:{
        x:{type:'linear',min:-RANGE,max:RANGE,display:false},
        y:{min:-YMAX,max:YMAX,display:false}
      }
    },plugins:[axesArrows]
  });
  updateMainChart();
}
function updateMainChart() {
  const checks=[...document.querySelectorAll('#graphControls input[type=checkbox]:checked')];
  const funcs=checks.map(c=>c.dataset.func);
  chartMain.data.datasets=funcs.map(f=>datasetFor(f,2));
  chartMain.update();
}
function createAxChart() {
  const ctx=document.getElementById('chartAx');
  chartAx=new Chart(ctx,{
    type:'line',
    data:{datasets:[]},
    options:{
      maintainAspectRatio:true,
      responsive:true,
      plugins:{legend:{display:false}},
      scales:{x:{type:'linear',min:-RANGE,max:RANGE,display:false},y:{min:-YMAX,max:YMAX,display:false}}
    },plugins:[axesArrows]
  });
  updateAxChart();
}
function updateAxChart() {
  const datasets=[];
  if(document.getElementById('toggleHalf').checked) datasets.push(datasetFor('halfx'));
  if(document.getElementById('toggleTwo').checked) datasets.push(datasetFor('2x'));
  const a=parseFloat(document.getElementById('baseA').value||2);
  datasets.push(datasetFor('ax',a));
  chartAx.data.datasets=datasets;
  chartAx.update();
}

/***************** UI wiring *****************/
window.addEventListener('DOMContentLoaded',()=>{
  // initial tables
  buildPolyTable('x2');
  buildExpTable(parseInt(document.getElementById('expLevels').value,10));

  // poly buttons
  document.querySelectorAll('.square-btn').forEach(btn=>{
    btn.addEventListener('click',()=>{
      document.querySelectorAll('.square-btn').forEach(b=>b.classList.remove('checked'));
      btn.classList.add('checked');
      const val=btn.querySelector('input').value; buildPolyTable(val);
    });
  });
  // exp levels
  document.getElementById('expLevels').addEventListener('input',e=>{
    const lvl=Math.max(1,Math.min(10,parseInt(e.target.value,10)||1));
    buildExpTable(lvl);
  });

  // tabs
  document.querySelectorAll('.tab-btn').forEach(btn=>btn.addEventListener('click',()=>{
    document.querySelectorAll('.tab-btn').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('.tab-content').forEach(div=>div.classList.add('hidden'));
    document.getElementById(btn.dataset.tab).classList.remove('hidden');
  }));

  // charts
  createMainChart();
  createAxChart();

  // graph controls
  document.querySelectorAll('#graphControls input[type=checkbox]').forEach(cb=>cb.addEventListener('change',updateMainChart));
  // ax controls
  document.getElementById('toggleHalf').addEventListener('change',updateAxChart);
  document.getElementById('toggleTwo').addEventListener('change',updateAxChart);
  document.getElementById('baseA').addEventListener('input',updateAxChart);

  // keep axes centred on resize
  window.addEventListener('resize',()=>{chartMain.update(); chartAx.update();});
});
</script>
</body>
</html>
