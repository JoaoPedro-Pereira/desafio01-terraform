const initialLogs = [
    "INITIALIZING CLOUD SERVER CORE...",
    "CONNECTING TO NEURAL NET...",
    "AUTHENTICATION SUCCESSFUL."
];

let cpuUsage = 24.5;
let ramUsage = 45.2;
let networkTraffic = 120;

const terminal = document.getElementById('terminal');
const cursorLine = document.getElementById('cursor-line');

function formatLogLine(text) {
    const div = document.createElement('div');
    div.className = 'log-line';
    div.innerHTML = `<span class="prompt">&gt;</span> ${text}`;
    return div;
}

function addLog(text) {
    terminal.insertBefore(formatLogLine(text), cursorLine);
    // Keep only last 10 lines max to prevent DOM growing forever
    if (terminal.children.length > 12) {
        terminal.removeChild(terminal.firstChild);
    }
    terminal.scrollTop = terminal.scrollHeight;
}

initialLogs.forEach(addLog);

// Dynamic updates
setInterval(() => {
    // CPU Update
    cpuUsage = Math.min(100, Math.max(0, cpuUsage + (Math.random() * 10 - 5)));
    document.getElementById('cpu-value').innerText = cpuUsage.toFixed(1);
    document.getElementById('cpu-bar').style.width = `${cpuUsage}%`;

    // RAM Update
    ramUsage = Math.min(100, Math.max(0, ramUsage + (Math.random() * 5 - 2.5)));
    document.getElementById('ram-value').innerText = ramUsage.toFixed(1);
    document.getElementById('ram-bar').style.width = `${ramUsage}%`;

    // Network Update
    networkTraffic = Math.max(0, networkTraffic + (Math.random() * 40 - 20));
    document.getElementById('network-value').innerText = networkTraffic.toFixed(0);

    // Random Logs
    if (Math.random() > 0.5) {
        const newLogs = [
            `[SYSTEM] ping response time: ${Math.floor(Math.random() * 50)}ms`,
            `[TRAFFIC] packet received from node-${Math.floor(Math.random() * 9999)}`,
            `[SECURITY] firewall scanning sector ${Math.floor(Math.random() * 9)}... OK`,
            `[DATA] synchronizing cluster block ${Math.floor(Math.random() * 10000)}...`
        ];
        addLog(newLogs[Math.floor(Math.random() * newLogs.length)]);
    }
}, 1500);
