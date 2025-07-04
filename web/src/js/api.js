const API_BASE = 'http://localhost:4000/api';
const ALPHA_VANTAGE_API_KEY = ''; // From alphavantage.co
const MARKETAUX_API_KEY = ''; // From marketaux.com

export async function apiRequest(endpoint, method='GET', data=null, auth=true) {
    const headers = { 'Content-Type': 'application/json' };
    if (auth) {
        const token = localStorage.getItem('jwtToken');
        if (token) headers['Authorization'] = `Bearer ${token}`;
    }
    const res = await fetch(`${API_BASE}${endpoint}`, {
        method,
        headers,
        body: data ? JSON.stringify(data) : null
    });
    if (!res.ok) {
        const err = await res.json();
        throw new Error(err.error || err.message || 'API error');
    }
    return res.json();
}

// Function to fetch stock data
async function fetchStockData(symbol) {
    try {
        const response = await fetch(`https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${symbol}&apikey=${ALPHA_VANTAGE_API_KEY}`);
        const data = await response.json();
        return data['Global Quote'];
    } catch (error) {
        console.error('Error fetching stock data:', error);
        return null;
    }
}

// Function to fetch market news using MarketAux API
async function fetchMarketNews() {
    try {
        const response = await fetch(
            `https://api.marketaux.com/v1/news/all?api_token=${MARKETAUX_API_KEY}&language=en&limit=5`
        );
        const data = await response.json();
        return data.data; // MarketAux returns news in data array
    } catch (error) {
        console.error('Error fetching news:', error);
        return [];
    }
}

// Function to update stock table
async function updateStockTable() {
    const stocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'META'];
    const tbody = document.querySelector('.stock-snapshot-table tbody');

    for (let i = 0; i < stocks.length; i++) {
        const data = await fetchStockData(stocks[i]);
        if (data) {
            const price = parseFloat(data['05. price']).toFixed(2);
            const change = parseFloat(data['09. change']).toFixed(2);
            const changePercent = parseFloat(data['10. change percent']).toFixed(2);

            const row = tbody.children[i];
            row.children[2].textContent = `$${price}`;
            row.children[3].textContent = `${change > 0 ? '+' : ''}${changePercent}%`;
            row.children[3].className = change > 0 ? 'change-positive' : 'change-negative';
        }
    }
}

// Function to update news cards with MarketAux data
async function updateNewsCards() {
    const news = await fetchMarketNews();
    const newsGrid = document.querySelector('.market-news-grid');

    newsGrid.innerHTML = ''; // Clear existing news

    news.forEach(article => {
        const newsCard = document.createElement('div');
        newsCard.className = 'news-card';
        newsCard.innerHTML = `
            <div class="icon-wrapper"><i class="fa-solid fa-newspaper"></i></div>
            <h3>${article.title}</h3>
            <p class="news-description">${article.description || ''}</p>
            <p class="news-time">${new Date(article.published_at).toLocaleString()}</p>
            <div class="news-source">${article.source}</div>
        `;
        newsCard.addEventListener('click', () => window.open(article.url, '_blank'));
        newsGrid.appendChild(newsCard);
    });
}

// Update data every 60 seconds
function startDataUpdates() {
    updateStockTable();
    updateNewsCards();

    setInterval(() => {
        updateStockTable();
        updateNewsCards();
    }, 60000);
}

// Start updates when page loads
document.addEventListener('DOMContentLoaded', startDataUpdates);