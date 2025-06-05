import { apiRequest } from '../api.js';

export async function loadDetail() {
    const params = new URLSearchParams(window.location.search);
    const symbol = params.get('symbol');
    document.getElementById('app').innerHTML = `
    <div class="container mt-4">
      <h2>Detail: ${symbol}</h2>
      <div>
        <canvas id="stockChart" width="400" height="200"></canvas>
      </div>
      <div id="stockInfo" class="mt-3"></div>
    </div>
  `;
    try {
        const data = await apiRequest(`/marketdata/${symbol}`);
        const ctx = document.getElementById('stockChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.history.dates,
                datasets: [{
                    label: symbol,
                    data: data.history.prices,
                    borderColor: data.change >= 0 ? 'green' : 'red',
                    fill: false
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: true } },
                scales: { x: { display: true }, y: { display: true } }
            }
        });
        document.getElementById('stockInfo').innerHTML = `
      <p>Current Price: ${data.currentPrice}</p>
      <p>Change: <span class="${data.change >= 0 ? 'text-success' : 'text-danger'}">
         ${data.change.toFixed(2)}%</span></p>
    `;
    } catch (err) {
        document.getElementById('app').innerHTML = `<p class="text-danger">${err.message}</p>`;
    }
}
