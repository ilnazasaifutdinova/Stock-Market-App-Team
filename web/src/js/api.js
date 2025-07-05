const API_BASE = 'http://localhost:4000/api';
const ALPHA_VANTAGE_API_KEY = 'ILW4RW6EOV0BJRXN';
const MARKETAUX_API_KEY = '0ib8rrVP2fbSrUFst7f2fKKw1VdBeEwgat4i8hgX';

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

export async function fetchStockData(symbol) {
    try {
        const response = await fetch(`https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${symbol}&apikey=${ALPHA_VANTAGE_API_KEY}`);
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();

        if (data.Note) {
            console.warn('API limit reached:', data.Note);
            throw new Error('API limit reached');
        }

        if (data['Global Quote']) {
            return {
                price: data['Global Quote']['05. price'],
                change: data['Global Quote']['09. change'],
                changePercent: data['Global Quote']['10. change percent']
            };
        } else {
            console.error('Invalid data structure received:', data);
            throw new Error('Invalid API response');
        }
    } catch (error) {
        console.error('Error fetching stock data:', error);
        throw error;
    }
}

export async function fetchMarketNews() {
    try {
        const response = await fetch(
            `https://api.marketaux.com/v1/news/all?api_token=${MARKETAUX_API_KEY}&language=en&limit=5`
        );
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        return data.data || []; // MarketAux returns news in data array
    } catch (error) {
        console.error('Error fetching news:', error);
        return [];
    }
}

export async function updateStockTable() {
    const stocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'META'];
    const tbody = document.querySelector('.stock-snapshot-table tbody');

    for (let i = 0; i < stocks.length; i++) {
        try {
            const data = await fetchStockData(stocks[i]);
            if (data) {
                const row = tbody.children[i];
                const priceCell = row.children[2];
                const changeCell = row.children[3];

                const price = parseFloat(data.price).toFixed(2);
                const changePercent = parseFloat(data.changePercent).toFixed(2);
                const change = parseFloat(data.change);

                priceCell.textContent = `$${price}`;
                changeCell.textContent = `${change >= 0 ? '+' : ''}${changePercent}%`;
                changeCell.className = change >= 0 ? 'change-positive' : 'change-negative';

                // Add background flash effect
                row.style.backgroundColor = change >= 0 ?
                    'rgba(84, 209, 43, 0.1)' : 'rgba(255, 68, 68, 0.1)';

                setTimeout(() => {
                    row.style.transition = 'background-color 0.5s ease';
                    row.style.backgroundColor = 'transparent';
                }, 1000);
            }
        } catch (error) {
            console.error(`Error updating ${stocks[i]}:`, error);
        }
    }
}

export async function updateNewsCards() {
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

export function startDataUpdates() {
    updateStockTable();
    updateNewsCards();

    setInterval(() => {
        updateStockTable();
        updateNewsCards();
    }, 60000); // Update every minute
}