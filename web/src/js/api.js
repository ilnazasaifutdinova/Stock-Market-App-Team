const API_BASE = 'http://localhost:4000/api';

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
