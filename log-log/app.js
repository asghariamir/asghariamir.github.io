document.addEventListener('DOMContentLoaded', () => {
    // --- DATASETS & STATE ---
    const datasets = {
        bacteria: {
            name: "Bacteria Growth",
            type: "exponential",
            straightensOn: "semi-log",
            points: Array.from({length: 10}, (_, i) => ({x: i, y: 5 * Math.pow(1.8, i)}))
        },
        capacitor: {
            name: "Capacitor Discharge",
            type: "exponential",
            straightensOn: "semi-log",
            points: Array.from({length: 10}, (_, i) => ({x: i, y: 10 * Math.exp(-0.5 * i)}))
        },
        earthquake: {
            name: "Earthquake Energy",
            type: "power-law",
            straightensOn: "log-log",
            points: Array.from({length: 7}, (_, i) => ({x: Math.pow(10, i), y: 2 * Math.pow(Math.pow(10, i), 1.5)}))
        }
    };
    const challenges = [
        { scenario: "A bacterial culture doubles in size every hour.", correct: 'semi-log' },
        { scenario: "The relationship between a planet's orbital period and its distance from the sun (Kepler's 3rd Law).", correct: 'log-log'},
        { scenario: "The voltage across a discharging capacitor over time.", correct: 'semi-log' },
        { scenario: "The price of a car decreasing by a fixed amount each year.", correct: 'linear'},
        { scenario: "The energy released by an earthquake vs. its magnitude.", correct: 'log-log'},
        { scenario: "Radioactive decay, where half the material disappears in a fixed time.", correct: 'semi-log' }
    ];

    let currentPreset = 'bacteria';
    let currentMode = 'linear';
    let mainChart;
    let currentChallengeIndex = 0;

    // --- UI ELEMENTS ---
    const infoDisplay = document.getElementById('infoDisplay');
    const ctx = document.getElementById('mainChart').getContext('2d');

    // --- TAB SWITCHING ---
    const tabs = document.querySelector('.tabs');
    tabs.addEventListener('click', (e) => {
        if (!e.target.matches('.tab-btn')) return;
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        e.target.classList.add('active');
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        document.getElementById(e.target.dataset.tab).classList.add('active');
    });
    document.getElementById('navigateToExplorer').addEventListener('click', () => {
        document.querySelector('[data-tab="explorer"]').click();
    });

    // --- EXPLORER LOGIC ---
    function initializeChart() {
        mainChart = new Chart(ctx, {
            type: 'scatter',
            data: { datasets: [] },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: { type: 'linear', title: { display: true, text: 'X-Axis' } },
                    y: { type: 'linear', title: { display: true, text: 'Y-Axis' } }
                }
            }
        });
    }

    function linearRegression(data) {
        const n = data.length;
        if (n < 2) return { m: 0, b: 0 };
        let sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
        for (const { x, y } of data) {
            sumX += x;
            sumY += y;
            sumXY += x * y;
            sumX2 += x * x;
        }
        const m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
        const b = (sumY - m * sumX) / n;
        return { m, b };
    }

    function updateExplorer() {
        const dataset = datasets[currentPreset];
        const rawPoints = dataset.points;

        // Set axis types for Chart.js
        mainChart.options.scales.x.type = (currentMode === 'log-log') ? 'logarithmic' : 'linear';
        mainChart.options.scales.y.type = (currentMode === 'semi-log' || currentMode === 'log-log') ? 'logarithmic' : 'linear';

        // Main data points
        mainChart.data.datasets[0] = {
            label: dataset.name,
            data: rawPoints,
            backgroundColor: 'rgba(15, 118, 110, 0.8)',
            type: 'scatter'
        };

        // Check if the plot should be straightened
        if (dataset.straightensOn === currentMode) {
            let transformedPoints = rawPoints.map(p => {
                let tx = p.x, ty = p.y;
                if (currentMode === 'semi-log' && p.y > 0) ty = Math.log10(p.y);
                if (currentMode === 'log-log' && p.x > 0 && p.y > 0) {
                    tx = Math.log10(p.x);
                    ty = Math.log10(p.y);
                }
                return { x: tx, y: ty };
            }).filter(p => p.x !== -Infinity && p.y !== -Infinity);

            const { m, b } = linearRegression(transformedPoints);
            infoDisplay.style.display = 'block';
            if (currentMode === 'semi-log') {
                infoDisplay.textContent = `Straightened! log(y) = ${m.toFixed(2)}x + ${b.toFixed(2)}`;
            } else if (currentMode === 'log-log') {
                infoDisplay.textContent = `Straightened! log(y) = ${m.toFixed(2)}log(x) + ${b.toFixed(2)}`;
            }
        } else {
            infoDisplay.style.display = 'none';
        }

        mainChart.update();
    }

    document.querySelectorAll('.presets .chip').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.presets .chip').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentPreset = btn.dataset.preset;
            updateExplorer();
        });
    });

    document.querySelectorAll('.axis-modes .mode-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.axis-modes .mode-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentMode = btn.dataset.mode;
            updateExplorer();
        });
    });

    // --- CHALLENGE LOGIC ---
    const challengeScenario = document.getElementById('challenge-scenario');
    const challengeChoices = document.querySelector('.challenge-choices');
    const challengeFeedback = document.getElementById('challenge-feedback');
    const progressBar = document.getElementById('progressBar');
    const progressText = document.getElementById('progress-text');

    function loadChallenge() {
        if (currentChallengeIndex >= challenges.length) {
            challengeScenario.textContent = "All challenges complete!";
            challengeChoices.style.display = 'none';
            challengeFeedback.textContent = '';
            progressBar.style.width = '100%';
            progressText.textContent = `Complete!`;
            return;
        }
        const challenge = challenges[currentChallengeIndex];
        challengeScenario.textContent = challenge.scenario;
        challengeFeedback.textContent = '';
        challengeFeedback.className = '';
        challengeChoices.querySelectorAll('button').forEach(b => b.disabled = false);
        const progress = (currentChallengeIndex / challenges.length) * 100;
        progressBar.style.width = `${progress}%`;
        progressText.textContent = `Challenge ${currentChallengeIndex + 1} of ${challenges.length}`;
    }
    
    challengeChoices.addEventListener('click', e => {
        if (!e.target.matches('button')) return;
        const choice = e.target.dataset.choice;
        const correct = challenges[currentChallengeIndex].correct;
        challengeChoices.querySelectorAll('button').forEach(b => b.disabled = true);
        if (choice === correct) {
            challengeFeedback.textContent = "Correct! That's the right model.";
            challengeFeedback.className = 'correct';
            currentChallengeIndex++;
            setTimeout(loadChallenge, 1500);
        } else {
            challengeFeedback.textContent = "Not quite. Think about whether the change is additive or multiplicative.";
            challengeFeedback.className = 'incorrect';
            setTimeout(() => {
                challengeChoices.querySelectorAll('button').forEach(b => b.disabled = false);
                challengeFeedback.textContent = '';
                challengeFeedback.className = '';
            }, 2000);
        }
    });

    // --- INITIALIZATION ---
    initializeChart();
    document.querySelector('.presets .chip[data-preset="bacteria"]').classList.add('active');
    updateExplorer();
    loadChallenge();
});
